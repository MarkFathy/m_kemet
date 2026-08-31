import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class GetGendersUseCase {
  final AuthRepository repository;

  GetGendersUseCase(this.repository);

  Future<Either<Failure, List<GenderEntity>>> call() {
    return repository.fetchGenders();
  }
}
