import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class ResendOtpParams extends Equatable {
  final String email;

  const ResendOtpParams({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class ResendOtpUseCase implements BaseUseCase<String, ResendOtpParams> {
  final AuthRepository repository;

  ResendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(ResendOtpParams params) {
    return repository.resendOtp(
      email: params.email,
    );
  }
}
