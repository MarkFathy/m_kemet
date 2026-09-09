import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class GetInitialCandidatesUseCase implements BaseUseCase<List<CandidateEntity>, NoParams> {
  final CandidateSearchRepository repository;

  GetInitialCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(NoParams params) {
    return repository.getInitialCandidates();
  }
}
