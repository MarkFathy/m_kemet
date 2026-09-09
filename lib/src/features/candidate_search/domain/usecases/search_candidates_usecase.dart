import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class SearchCandidatesUseCase implements BaseUseCase<List<CandidateEntity>, String> {
  final CandidateSearchRepository repository;

  SearchCandidatesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CandidateEntity>>> call(String query) {
    return repository.searchCandidates(query);
  }
}
