import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterCompanyParams extends Equatable {
  final String name;
  final String phone;
  /* Email made optional as per client request to register with phone only */
  final String? email;
  final String password;
  final String passwordConfirmation;

  const RegisterCompanyParams({
    required this.name,
    required this.phone,
    this.email,
    required this.password,
    required this.passwordConfirmation,
  });

  @override
  List<Object?> get props => [name, phone, email, password, passwordConfirmation];
}

class RegisterCompanyUseCase implements BaseUseCase<AuthEntity, RegisterCompanyParams> {
  final AuthRepository repository;

  RegisterCompanyUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterCompanyParams params) {
    return repository.registerCompany(
      name: params.name,
      phone: params.phone,
      email: params.email,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
    );
  }
}
