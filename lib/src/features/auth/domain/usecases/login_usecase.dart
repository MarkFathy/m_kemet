import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class LoginParams extends Equatable {
  final String email;
  final String password;
  final UserType? expectedUserType;

  const LoginParams({
    required this.email,
    required this.password,
    this.expectedUserType,
  });

  @override
  List<Object?> get props => [email, password, expectedUserType];
}

class LoginUseCase implements BaseUseCase<AuthEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthEntity>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
      expectedUserType: params.expectedUserType,
    );
  }
}
