import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class GetCountriesUseCase {
  final AuthRepository repository;

  GetCountriesUseCase(this.repository);

  Future<Either<Failure, List<CountryEntity>>> call() {
    return repository.fetchCountries();
  }
}
