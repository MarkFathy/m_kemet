import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordParams extends Equatable {
  final String email;
  final String code;
  final String password;
  final String passwordConfirmation;

  const ResetPasswordParams({
    required this.email,
    required this.code,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [email, code, password, passwordConfirmation];
}

class ResetPasswordUseCase implements BaseUseCase<String, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ResetPasswordParams params) {
    return repository.resetPassword(
      email: params.email,
      code: params.code,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
