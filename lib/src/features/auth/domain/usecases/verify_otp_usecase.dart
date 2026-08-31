import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class VerifyOtpParams extends Equatable {
  final String email;
  final String code;

  const VerifyOtpParams({
    required this.email,
    required this.code,
  });

  @override
  List<Object?> get props => [email, code];
}

class VerifyOtpUseCase implements BaseUseCase<AuthEntity, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(
      email: params.email,
      code: params.code,
    );
  }
}
