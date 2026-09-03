import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_saved_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/toggle_save_candidate_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_state.dart';

class CandidateSearchCubit extends Cubit<CandidateSearchState> {
  final GetCandidatesUseCase getCandidatesUseCase;
  final ToggleSaveCandidateUseCase toggleSaveCandidateUseCase;
  final GetSavedCandidatesUseCase getSavedCandidatesUseCase;

  CandidateSearchCubit({
    required this.getCandidatesUseCase,
    required this.toggleSaveCandidateUseCase,
    required this.getSavedCandidatesUseCase,
  }) : super(const CandidateSearchState());

  Future<void> fetchCandidates() async {
    emit(state.copyWith(status: CandidateSearchStatus.loading));
    final result = await getCandidatesUseCase(state.activeFilter);
    result.fold(
      (failure) => emit(state.copyWith(
        status: CandidateSearchStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (candidates) => emit(state.copyWith(
        status: CandidateSearchStatus.success,
        candidates: candidates,
      )),
    );
  }

  Future<void> fetchSavedCandidates() async {
    emit(state.copyWith(savedStatus: CandidateSearchStatus.loading));
    final result = await getSavedCandidatesUseCase(NoParams());
    result.fold(
      (failure) => emit(state.copyWith(
        savedStatus: CandidateSearchStatus.failure,
        errorMessage: failure.serverException.message,
      )),
      (savedList) => emit(state.copyWith(
        savedStatus: CandidateSearchStatus.success,
        savedCandidatesList: savedList,
      )),
    );
  }

  Future<void> updateSearchQuery(String query) async {
    final updatedFilter = state.activeFilter.copyWith(searchQuery: query);
    emit(state.copyWith(activeFilter: updatedFilter));
    await fetchCandidates();
  }

  Future<void> applyFilter(CandidateFilterEntity filter) async {
    emit(state.copyWith(activeFilter: filter));
    await fetchCandidates();
  }

  Future<void> resetFilter() async {
    emit(state.copyWith(activeFilter: const CandidateFilterEntity()));
    await fetchCandidates();
  }

  Future<void> toggleSaveCandidate(String candidateId) async {
    // 1. Identify current state & candidate
    final inCandidates = state.candidates.any((c) => c.id == candidateId);
    final inSaved = state.savedCandidatesList.any((c) => c.id == candidateId);

    CandidateEntity? targetCandidate;
    if (inCandidates) {
      targetCandidate = state.candidates.firstWhere((c) => c.id == candidateId);
    } else if (inSaved) {
      targetCandidate = state.savedCandidatesList.firstWhere((c) => c.id == candidateId);
    }

    final previousSaved = targetCandidate?.isSaved ?? false;
    final newSaved = !previousSaved;

    // 2. Instant Optimistic UI Update (0 delay!)
    final optimisticCandidates = state.candidates.map((c) {
      return c.id == candidateId ? c.copyWith(isSaved: newSaved) : c;
    }).toList();

    final optimisticSaved = List<CandidateEntity>.from(state.savedCandidatesList);
    if (newSaved) {
      if (targetCandidate != null && !optimisticSaved.any((c) => c.id == candidateId)) {
        optimisticSaved.add(targetCandidate.copyWith(isSaved: true));
      }
    } else {
      optimisticSaved.removeWhere((c) => c.id == candidateId);
    }

    emit(state.copyWith(
      candidates: optimisticCandidates,
      savedCandidatesList: optimisticSaved,
    ));

    // 3. Network call in background
    final result = await toggleSaveCandidateUseCase(candidateId);
    result.fold(
      (failure) {
        // Revert on failure
        final revertedCandidates = state.candidates.map((c) {
          return c.id == candidateId ? c.copyWith(isSaved: previousSaved) : c;
        }).toList();

        final revertedSaved = List<CandidateEntity>.from(state.savedCandidatesList);
        if (previousSaved) {
          if (targetCandidate != null && !revertedSaved.any((c) => c.id == candidateId)) {
            revertedSaved.add(targetCandidate.copyWith(isSaved: true));
          }
        } else {
          revertedSaved.removeWhere((c) => c.id == candidateId);
        }

        emit(state.copyWith(
          candidates: revertedCandidates,
          savedCandidatesList: revertedSaved,
          errorMessage: failure.serverException.message,
        ));
      },
      (updatedCandidate) {
        // Confirm with server response if server returned different status
        if (updatedCandidate.isSaved != newSaved) {
          final confirmedCandidates = state.candidates.map((c) {
            return c.id == candidateId ? c.copyWith(isSaved: updatedCandidate.isSaved) : c;
          }).toList();

          final confirmedSaved = List<CandidateEntity>.from(state.savedCandidatesList);
          if (updatedCandidate.isSaved) {
            if (targetCandidate != null && !confirmedSaved.any((c) => c.id == candidateId)) {
              confirmedSaved.add(targetCandidate.copyWith(isSaved: true));
            }
          } else {
            confirmedSaved.removeWhere((c) => c.id == candidateId);
          }

          emit(state.copyWith(
            candidates: confirmedCandidates,
            savedCandidatesList: confirmedSaved,
          ));
        }
      },
    );
  }
}
