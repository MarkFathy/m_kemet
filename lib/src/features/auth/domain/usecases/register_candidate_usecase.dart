import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';

class RegisterCandidateParams extends Equatable {
  final String name;
  /* Email made optional as per client request to register with phone only */
  final String? email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final int currentCountryId;
  final String birthDate;
  final int genderId;

  const RegisterCandidateParams({
    required this.name,
    this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.currentCountryId,
    required this.birthDate,
    required this.genderId,
  });

  @override
  List<Object?> get props => [
        name,
        email,
        phone,
        password,
        passwordConfirmation,
        currentCountryId,
        birthDate,
        genderId,
      ];
}

class RegisterCandidateUseCase implements BaseUseCase<AuthEntity, RegisterCandidateParams> {
  final AuthRepository repository;

  RegisterCandidateUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(RegisterCandidateParams params) {
    return repository.registerCandidate(
      name: params.name,
      email: params.email,
      phone: params.phone,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      currentCountryId: params.currentCountryId,
      birthDate: params.birthDate,
      genderId: params.genderId,
    );
  }
}
