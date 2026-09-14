import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

enum CandidateSearchStatus { initial, loading, success, failure }

class CandidateSearchState extends Equatable {
  final CandidateSearchStatus status;
  final List<CandidateEntity> candidates;
  final String? errorMessage;
  final CandidateSearchFilterEntity activeFilter;
  final List<CountryEntity> topCountries;
  final List<ProfessionEntity> popularProfessions;
  final bool lookupsLoading;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final int? totalCandidates;

  const CandidateSearchState({
    this.status = CandidateSearchStatus.initial,
    this.candidates = const [],
    this.errorMessage,
    this.activeFilter = const CandidateSearchFilterEntity(),
    this.topCountries = const [],
    this.popularProfessions = const [],
    this.lookupsLoading = false,
    this.currentPage = 1,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.totalCandidates,
  });

  CandidateSearchState copyWith({
    CandidateSearchStatus? status,
    List<CandidateEntity>? candidates,
    String? errorMessage,
    CandidateSearchFilterEntity? activeFilter,
    List<CountryEntity>? topCountries,
    List<ProfessionEntity>? popularProfessions,
    bool? lookupsLoading,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    int? totalCandidates,
  }) {
    return CandidateSearchState(
      status: status ?? this.status,
      candidates: candidates ?? this.candidates,
      errorMessage: errorMessage ?? this.errorMessage,
      activeFilter: activeFilter ?? this.activeFilter,
      topCountries: topCountries ?? this.topCountries,
      popularProfessions: popularProfessions ?? this.popularProfessions,
      lookupsLoading: lookupsLoading ?? this.lookupsLoading,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      totalCandidates: totalCandidates ?? this.totalCandidates,
    );
  }

  @override
  List<Object?> get props => [
        status,
        candidates,
        errorMessage,
        activeFilter,
        topCountries,
        popularProfessions,
        lookupsLoading,
        currentPage,
        hasMore,
        isLoadingMore,
        totalCandidates,
      ];
}
