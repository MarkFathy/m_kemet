import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class SendContactRequestUseCase extends BaseUseCase<Map<String, dynamic>, String> {
  final CandidateRepository repository;

  SendContactRequestUseCase(this.repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(String candidateId) async {
    return await repository.sendContactRequest(candidateId);
  }
}
