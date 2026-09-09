import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class FilterCandidatesUseCase implements BaseUseCase<List<CandidateEntity>, CandidateSearchFilterEntity> {
  final CandidateSearchRepository repository;

  FilterCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(CandidateSearchFilterEntity filter) {
    return repository.filterCandidates(filter);
  }
}
