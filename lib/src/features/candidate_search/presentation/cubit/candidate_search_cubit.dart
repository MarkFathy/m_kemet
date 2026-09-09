import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/usecases/filter_candidates_usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/usecases/get_initial_candidates_usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/usecases/get_popular_professions_usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/usecases/get_top_countries_usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/usecases/search_candidates_usecase.dart';
import 'package:m_kemet/src/features/candidate_search/presentation/cubit/candidate_search_state.dart';

class CandidateSearchCubit extends Cubit<CandidateSearchState> {
  final GetInitialCandidatesUseCase getInitialCandidatesUseCase;
  final SearchCandidatesUseCase searchCandidatesUseCase;
  final FilterCandidatesUseCase filterCandidatesUseCase;
  final GetTopCountriesUseCase getTopCountriesUseCase;
  final GetPopularProfessionsUseCase getPopularProfessionsUseCase;

  CandidateSearchCubit({
    required this.getInitialCandidatesUseCase,
    required this.searchCandidatesUseCase,
    required this.filterCandidatesUseCase,
    required this.getTopCountriesUseCase,
    required this.getPopularProfessionsUseCase,
  }) : super(const CandidateSearchState());

  /// Fetch candidates and pre-load top-6 countries & popular professions
  Future<void> fetchCandidates() async {
    emit(state.copyWith(status: CandidateSearchStatus.loading));

    // Also trigger lookups if not yet loaded
    if (state.topCountries.isEmpty || state.popularProfessions.isEmpty) {
      loadFilterLookups();
    }

    if (state.activeFilter.hasActiveFilters) {
      if (state.activeFilter.searchQuery.trim().isNotEmpty &&
          state.activeFilter.activeFilterCount == 0) {
        // Pure text search
        final result = await searchCandidatesUseCase(state.activeFilter.searchQuery);
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
        return;
      }

      // Filter query
      final result = await filterCandidatesUseCase(state.activeFilter);
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
      return;
    }

    // Default initial candidates
    final result = await getInitialCandidatesUseCase(NoParams());
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

  /// Load top-6 countries and popular professions for the filter bottom sheet
  Future<void> loadFilterLookups() async {
    emit(state.copyWith(lookupsLoading: true));
    final countriesResult = await getTopCountriesUseCase(NoParams());
    final professionsResult = await getPopularProfessionsUseCase(NoParams());

    final countries = countriesResult.getOrElse(() => []);
    final professions = professionsResult.getOrElse(() => []);

    emit(state.copyWith(
      lookupsLoading: false,
      topCountries: countries.isNotEmpty ? countries : state.topCountries,
      popularProfessions: professions.isNotEmpty ? professions : state.popularProfessions,
    ));
  }

  /// Triggered when typing in search bar
  Future<void> updateSearchQuery(String query) async {
    final updatedFilter = state.activeFilter.copyWith(searchQuery: query);
    emit(state.copyWith(activeFilter: updatedFilter));

    if (query.trim().isEmpty && !updatedFilter.hasActiveFilters) {
      await fetchCandidates();
      return;
    }

    emit(state.copyWith(status: CandidateSearchStatus.loading));
    if (updatedFilter.activeFilterCount > 0) {
      // Both search query and filter criteria are active
      final result = await filterCandidatesUseCase(updatedFilter);
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
    } else {
      // Pure search
      final result = await searchCandidatesUseCase(query.trim());
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
  }

  /// Apply filter options from CandidateFilterBottomSheet
  Future<void> applyFilter(CandidateSearchFilterEntity filter) async {
    emit(state.copyWith(activeFilter: filter));
    await fetchCandidates();
  }

  /// Reset all filters
  Future<void> resetFilter() async {
    emit(state.copyWith(
      activeFilter: CandidateSearchFilterEntity(
        searchQuery: state.activeFilter.searchQuery,
      ),
    ));
    await fetchCandidates();
  }

  /// Instant local optimistic bookmark toggle
  void toggleSaveCandidate(String candidateId) {
    final updatedCandidates = state.candidates.map((c) {
      return c.id == candidateId ? c.copyWith(isSaved: !c.isSaved) : c;
    }).toList();

    emit(state.copyWith(candidates: updatedCandidates));
  }

  /// Sync local state with BookmarksCubit
  void syncCandidateBookmark(String candidateId, {required bool isSaved}) {
    final updatedCandidates = state.candidates.map((c) {
      return c.id == candidateId ? c.copyWith(isSaved: isSaved) : c;
    }).toList();

    emit(state.copyWith(candidates: updatedCandidates));
  }
}
