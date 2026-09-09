import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

class GetPopularProfessionsUseCase implements BaseUseCase<List<ProfessionEntity>, NoParams> {
  final CandidateSearchRepository repository;

  GetPopularProfessionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<ProfessionEntity>>> call(NoParams params) {
    return repository.getPopularProfessions();
  }
}
