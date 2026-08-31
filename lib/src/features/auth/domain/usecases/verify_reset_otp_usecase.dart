import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/verify_otp_usecase.dart';

class VerifyResetOtpUseCase implements BaseUseCase<String, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyResetOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyOtpParams params) {
    return repository.verifyResetOtp(
      email: params.email,
      code: params.code,
    );
  }
}
