import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/toggle_save_candidate_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_state.dart';

class CandidateSearchCubit extends Cubit<CandidateSearchState> {
  final GetCandidatesUseCase getCandidatesUseCase;
  final ToggleSaveCandidateUseCase toggleSaveCandidateUseCase;

  CandidateSearchCubit({
    required this.getCandidatesUseCase,
    required this.toggleSaveCandidateUseCase,
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
    final result = await toggleSaveCandidateUseCase(candidateId);
    result.fold(
      (failure) {},
      (updatedCandidate) {
        final updatedList = state.candidates.map((c) {
          return c.id == updatedCandidate.id ? updatedCandidate : c;
        }).toList();
        emit(state.copyWith(candidates: updatedList));
      },
    );
  }
}
