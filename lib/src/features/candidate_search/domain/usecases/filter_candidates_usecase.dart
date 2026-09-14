import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/paginated_candidates_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';

class FilterCandidatesParams extends Equatable {
  final CandidateSearchFilterEntity filter;
  final int page;

  const FilterCandidatesParams({
    required this.filter,
    this.page = 1,
  });

  @override
  List<Object?> get props => [filter, page];
}

class FilterCandidatesUseCase implements BaseUseCase<PaginatedCandidatesEntity, FilterCandidatesParams> {
  final CandidateSearchRepository repository;

  FilterCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedCandidatesEntity>> call(FilterCandidatesParams params) {
    return repository.filterCandidates(params.filter, page: params.page);
  }
}
