import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';

enum CandidateSearchStatus { initial, loading, success, failure }

class CandidateSearchState extends Equatable {
  final CandidateSearchStatus status;
  final List<CandidateEntity> candidates;
  final CandidateFilterEntity activeFilter;
  final String? errorMessage;

  const CandidateSearchState({
    this.status = CandidateSearchStatus.initial,
    this.candidates = const [],
    this.activeFilter = const CandidateFilterEntity(),
    this.errorMessage,
  });

  List<CandidateEntity> get savedCandidates => candidates.where((c) => c.isSaved).toList();

  CandidateSearchState copyWith({
    CandidateSearchStatus? status,
    List<CandidateEntity>? candidates,
    CandidateFilterEntity? activeFilter,
    String? errorMessage,
  }) {
    return CandidateSearchState(
      status: status ?? this.status,
      candidates: candidates ?? this.candidates,
      activeFilter: activeFilter ?? this.activeFilter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, candidates, activeFilter, errorMessage];
}
