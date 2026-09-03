import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> registerCandidate({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int currentCountryId,
    required String birthDate,
    required int genderId,
  });

  Future<Either<Failure, AuthEntity>> registerCompany({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    UserType? expectedUserType,
  });

  Future<Either<Failure, AuthEntity>> verifyOtp({
    required String email,
    required String code,
    UserType? expectedUserType,
  });

  Future<Either<Failure, String>> resendOtp({
    required String email,
  });

  Future<Either<Failure, String>> forgotPassword({
    required String email,
  });

  Future<Either<Failure, String>> verifyResetOtp({
    required String email,
    required String code,
  });

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, UserEntity>> getProfile();

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> logoutAll();

  Future<Either<Failure, List<GenderEntity>>> fetchGenders();

  Future<Either<Failure, List<CountryEntity>>> fetchCountries();
}
