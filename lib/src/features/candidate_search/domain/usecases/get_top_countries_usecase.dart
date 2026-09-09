import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/candidate_search/domain/repositories/candidate_search_repository.dart';

class GetTopCountriesUseCase implements BaseUseCase<List<CountryEntity>, NoParams> {
  final CandidateSearchRepository repository;

  GetTopCountriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<CountryEntity>>> call(NoParams params) {
    return repository.getTopCountries();
  }
}
