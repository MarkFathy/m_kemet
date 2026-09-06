import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class DeleteAccountUseCase implements BaseUseCaseNoParams<void> {
  final AuthRepository repository;

  DeleteAccountUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() {
    return repository.deleteAccount();
  }
}
