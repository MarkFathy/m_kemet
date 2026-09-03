import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class GetCandidateDetailUseCase extends BaseUseCase<CandidateEntity, String> {
  final CandidateRepository repository;

  GetCandidateDetailUseCase(this.repository);

  @override
  Future<Either<Failure, CandidateEntity>> call(String candidateId) async {
    return await repository.getCandidateDetail(candidateId);
  }
}
