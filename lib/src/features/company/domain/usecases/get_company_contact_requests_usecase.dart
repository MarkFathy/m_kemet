import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/company/data/models/company_contact_request_model.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class GetCompanyContactRequestsUseCase {
  final CandidateRepository repository;

  GetCompanyContactRequestsUseCase(this.repository);

  Future<Either<Failure, List<CompanyContactRequestModel>>> call() async {
    return await repository.getCompanyContactRequests();
  }
}
