import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/entities/candidate_search_filter_entity.dart';
import 'package:m_kemet/src/features/job_seeker/domain/entities/profession_entity.dart';

abstract class CandidateSearchRepository {
  Future<Either<Failure, List<CandidateEntity>>> getInitialCandidates();
  Future<Either<Failure, List<CandidateEntity>>> searchCandidates(String query);
  Future<Either<Failure, List<CandidateEntity>>> filterCandidates(CandidateSearchFilterEntity filter);
  Future<Either<Failure, List<CountryEntity>>> getTopCountries();
  Future<Either<Failure, List<ProfessionEntity>>> getPopularProfessions();
}
