import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class PaginatedCandidatesEntity extends Equatable {
  final List<CandidateEntity> candidates;
  final int currentPage;
  final int? lastPage;
  final int? total;
  final bool hasMore;

  const PaginatedCandidatesEntity({
    required this.candidates,
    required this.currentPage,
    this.lastPage,
    this.total,
    required this.hasMore,
  });

  @override
  List<Object?> get props => [candidates, currentPage, lastPage, total, hasMore];
}
