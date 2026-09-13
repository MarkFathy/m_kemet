import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/job_seeker/data/models/contact_request_model.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';

class GetMyContactRequestsUseCase {
  final JobSeekerRepository repository;

  GetMyContactRequestsUseCase(this.repository);

  Future<Either<Failure, List<ContactRequestModel>>> call() async {
    return await repository.getMyContactRequests();
  }
}
