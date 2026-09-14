import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/paginated_candidates_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';

class SearchCandidatesParams extends Equatable {
  final String query;
  final int page;

  const SearchCandidatesParams({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

class SearchCandidatesUseCase implements BaseUseCase<PaginatedCandidatesEntity, SearchCandidatesParams> {
  final CandidateSearchRepository repository;

  SearchCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedCandidatesEntity>> call(SearchCandidatesParams params) {
    return repository.searchCandidates(params.query, page: params.page);
  }
}
