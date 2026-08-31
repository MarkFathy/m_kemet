import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class GetProfileUseCase implements BaseUseCaseNoParams<UserEntity> {
  final AuthRepository repository;

  GetProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call() {
    return repository.getProfile();
  }
}
