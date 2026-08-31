import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ForgotPasswordUseCase implements BaseUseCase<String, ForgotPasswordParams> {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(
      email: params.email,
    );
  }
}
