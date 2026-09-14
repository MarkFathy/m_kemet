import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/paginated_candidates_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

abstract class CandidateSearchRepository {
  Future<Either<Failure, PaginatedCandidatesEntity>> getInitialCandidates({int page = 1});
  Future<Either<Failure, PaginatedCandidatesEntity>> searchCandidates(String query, {int page = 1});
  Future<Either<Failure, PaginatedCandidatesEntity>> filterCandidates(CandidateSearchFilterEntity filter, {int page = 1});
  Future<Either<Failure, List<CountryEntity>>> getTopCountries();
  Future<Either<Failure, List<ProfessionEntity>>> getPopularProfessions();
}
