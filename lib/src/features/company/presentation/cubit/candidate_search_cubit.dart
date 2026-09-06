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

  /// Local-only optimistic update — no API call.
  /// The actual API call is made exclusively by BookmarksCubit to avoid
  /// making the same network request twice.
  void toggleSaveCandidate(String candidateId) {
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
  }

  /// Called externally (e.g., by a BlocListener on BookmarksCubit) to sync
  /// the local search list state after an API rollback.
  void syncCandidateBookmark(String candidateId, {required bool isSaved}) {
    final updatedCandidates = state.candidates.map((c) {
      return c.id == candidateId ? c.copyWith(isSaved: isSaved) : c;
    }).toList();

    final updatedSaved = List<CandidateEntity>.from(state.savedCandidatesList);
    if (isSaved) {
      final candidate = state.candidates.where((c) => c.id == candidateId).firstOrNull;
      if (candidate != null && !updatedSaved.any((c) => c.id == candidateId)) {
        updatedSaved.add(candidate.copyWith(isSaved: true));
      }
    } else {
      updatedSaved.removeWhere((c) => c.id == candidateId);
    }

    emit(state.copyWith(
      candidates: updatedCandidates,
      savedCandidatesList: updatedSaved,
    ));
  }
}
