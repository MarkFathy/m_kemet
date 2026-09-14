import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/paginated_candidates_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';

class GetInitialCandidatesUseCase implements BaseUseCase<PaginatedCandidatesEntity, int> {
  final CandidateSearchRepository repository;

  GetInitialCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedCandidatesEntity>> call(int page) {
    return repository.getInitialCandidates(page: page);
  }
}
