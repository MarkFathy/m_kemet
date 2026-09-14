import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/paginated_candidates_entity.dart';
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

  Timer? _debounceTimer;

  CandidateSearchCubit({
    required this.getInitialCandidatesUseCase,
    required this.searchCandidatesUseCase,
    required this.filterCandidatesUseCase,
    required this.getTopCountriesUseCase,
    required this.getPopularProfessionsUseCase,
  }) : super(const CandidateSearchState());

  /// Fetch candidates (resets to page 1) and pre-load top-6 countries & popular professions
  Future<void> fetchCandidates({bool isRefresh = false}) async {
    emit(state.copyWith(
      status: isRefresh && state.candidates.isNotEmpty
          ? state.status
          : CandidateSearchStatus.loading,
      currentPage: 1,
      hasMore: true,
      isLoadingMore: false,
    ));

    // Also trigger lookups if not yet loaded
    if (state.topCountries.isEmpty || state.popularProfessions.isEmpty) {
      loadFilterLookups();
    }

    if (state.activeFilter.hasActiveFilters) {
      if (state.activeFilter.searchQuery.trim().isNotEmpty &&
          state.activeFilter.activeFilterCount == 0) {
        // Pure text search (page 1)
        final result = await searchCandidatesUseCase(
          SearchCandidatesParams(
            query: state.activeFilter.searchQuery.trim(),
            page: 1,
          ),
        );
        _handleInitialFetchResult(result);
        return;
      }

      // Filter query (page 1)
      final result = await filterCandidatesUseCase(
        FilterCandidatesParams(
          filter: state.activeFilter,
          page: 1,
        ),
      );
      _handleInitialFetchResult(result);
      return;
    }

    // Default initial candidates (page 1)
    final result = await getInitialCandidatesUseCase(1);
    _handleInitialFetchResult(result);
  }

  void _handleInitialFetchResult(Either<Failure, PaginatedCandidatesEntity> result) {
    result.fold(
      (failure) => emit(state.copyWith(
        status: CandidateSearchStatus.failure,
        errorMessage: failure.serverException.message,
        isLoadingMore: false,
      )),
      (paginated) => emit(state.copyWith(
        status: CandidateSearchStatus.success,
        candidates: paginated.candidates,
        currentPage: paginated.currentPage,
        hasMore: paginated.hasMore && paginated.candidates.isNotEmpty,
        totalCandidates: paginated.total,
        isLoadingMore: false,
        errorMessage: null,
      )),
    );
  }

  /// Load more candidates for infinite scroll pagination
  Future<void> loadMoreCandidates() async {
    if (state.isLoadingMore || !state.hasMore || state.status == CandidateSearchStatus.loading) {
      return;
    }

    emit(state.copyWith(isLoadingMore: true));
    final nextPage = state.currentPage + 1;

    if (state.activeFilter.hasActiveFilters) {
      if (state.activeFilter.searchQuery.trim().isNotEmpty &&
          state.activeFilter.activeFilterCount == 0) {
        // Pure text search next page
        final result = await searchCandidatesUseCase(
          SearchCandidatesParams(
            query: state.activeFilter.searchQuery.trim(),
            page: nextPage,
          ),
        );
        _handleLoadMoreResult(result, nextPage);
        return;
      }

      // Filter query next page
      final result = await filterCandidatesUseCase(
        FilterCandidatesParams(
          filter: state.activeFilter,
          page: nextPage,
        ),
      );
      _handleLoadMoreResult(result, nextPage);
      return;
    }

    // Default initial candidates next page
    final result = await getInitialCandidatesUseCase(nextPage);
    _handleLoadMoreResult(result, nextPage);
  }

  void _handleLoadMoreResult(
    Either<Failure, PaginatedCandidatesEntity> result,
    int requestedPage,
  ) {
    result.fold(
      (failure) {
        emit(state.copyWith(isLoadingMore: false));
      },
      (paginated) {
        final existingIds = state.candidates.map((c) => c.id).toSet();
        final newCandidates = paginated.candidates
            .where((c) => !existingIds.contains(c.id))
            .toList();

        emit(state.copyWith(
          candidates: [...state.candidates, ...newCandidates],
          currentPage: paginated.currentPage,
          hasMore: paginated.hasMore && paginated.candidates.isNotEmpty,
          totalCandidates: paginated.total ?? state.totalCandidates,
          isLoadingMore: false,
        ));
      },
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

  /// Triggered when typing in search bar (with 400ms debounce)
  void updateSearchQuery(String query) {
    _debounceTimer?.cancel();
    final updatedFilter = state.activeFilter.copyWith(searchQuery: query);
    emit(state.copyWith(activeFilter: updatedFilter));

    if (query.trim().isEmpty) {
      fetchCandidates();
      return;
    }

    _debounceTimer = Timer(const Duration(milliseconds: 400), () {
      fetchCandidates();
    });
  }

  /// Apply filter options from CandidateFilterBottomSheet
  Future<void> applyFilter(CandidateSearchFilterEntity filter) async {
    _debounceTimer?.cancel();
    emit(state.copyWith(activeFilter: filter));
    await fetchCandidates();
  }

  /// Reset all filters
  Future<void> resetFilter() async {
    _debounceTimer?.cancel();
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

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
