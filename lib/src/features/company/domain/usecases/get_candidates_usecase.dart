import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_filter_entity.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';

class GetCandidatesUseCase extends BaseUseCase<List<CandidateEntity>, CandidateFilterEntity> {
  final CandidateRepository repository;

  GetCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(CandidateFilterEntity filter) async {
    return await repository.filterCandidates(filter);
  }
}
