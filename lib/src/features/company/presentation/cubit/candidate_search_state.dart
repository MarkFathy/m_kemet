import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

enum CandidateSearchStatus { initial, loading, success, failure }

class CandidateSearchState extends Equatable {
  final CandidateSearchStatus status;
  final List<CandidateEntity> candidates;
  final CandidateFilterEntity activeFilter;
  final String? errorMessage;
  final CandidateSearchStatus savedStatus;
  final List<CandidateEntity> savedCandidatesList;

  const CandidateSearchState({
    this.status = CandidateSearchStatus.initial,
    this.candidates = const [],
    this.activeFilter = const CandidateFilterEntity(),
    this.errorMessage,
    this.savedStatus = CandidateSearchStatus.initial,
    this.savedCandidatesList = const [],
  });

  List<CandidateEntity> get savedCandidates =>
      savedCandidatesList.isNotEmpty
          ? savedCandidatesList
          : candidates.where((c) => c.isSaved).toList();

  CandidateSearchState copyWith({
    CandidateSearchStatus? status,
    List<CandidateEntity>? candidates,
    CandidateFilterEntity? activeFilter,
    String? errorMessage,
    CandidateSearchStatus? savedStatus,
    List<CandidateEntity>? savedCandidatesList,
  }) {
    return CandidateSearchState(
      status: status ?? this.status,
      candidates: candidates ?? this.candidates,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
      savedStatus: savedStatus ?? this.savedStatus,
      savedCandidatesList: savedCandidatesList ?? this.savedCandidatesList,
    );
  }

  @override
  List<Object?> get props => [
        status,
        candidates,
        activeFilter,
        errorMessage,
        savedStatus,
        savedCandidatesList,
      ];
}
