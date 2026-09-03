import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:m_kemet/src/features/auth/data/models/user_model.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/country_entity.dart';
import 'package:m_kemet/src/features/auth/domain/entities/gender_entity.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/features/auth/data/models/auth_response_model.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthEntity>> registerCandidate({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required int currentCountryId,
    required String birthDate,
    required int genderId,
  }) async {
    try {
      final result = await remoteDataSource.registerCandidate(
        name: name,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        currentCountryId: currentCountryId,
        birthDate: birthDate,
        genderId: genderId,
      );

      if (result.accessToken != null && result.accessToken!.isNotEmpty) {
        await localDataSource.saveAuthSession(
          token: result.accessToken!,
          refreshToken: result.refreshToken,
          user: result.user as UserModel?,
        );
      }

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Server error',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> registerCompany({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await remoteDataSource.registerCompany(
        name: name,
        phone: phone,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );

      if (result.accessToken != null && result.accessToken!.isNotEmpty) {
        await localDataSource.saveAuthSession(
          token: result.accessToken!,
          refreshToken: result.refreshToken,
          user: result.user as UserModel?,
        );
      }

      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Server error',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  String _getMismatchErrorMessage(UserType expectedUserType) {
    final isLookingForJobSeeker = expectedUserType == UserType.jobSeeker;
    final context = Go.navigatorKey.currentContext;
    if (context != null) {
      final s = S.maybeOf(context);
      if (s != null) {
        return isLookingForJobSeeker
            ? s.userTypeMismatchCompanyError
            : s.userTypeMismatchCandidateError;
      }
    }
    return isLookingForJobSeeker
        ? 'هذا الحساب مسجل كشركة، يرجى تسجيل الدخول من بوابة أصحاب الأعمال والشركات.'
        : 'هذا الحساب مسجل كباحث عن عمل، يرجى تسجيل الدخول من بوابة الباحثين عن عمل.';
  }

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
    UserType? expectedUserType,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
      );

      UserModel? user = result.user as UserModel?;

      if (user == null && result.accessToken != null && result.accessToken!.isNotEmpty) {
        try {
          user = await remoteDataSource.getProfile();
        } catch (_) {}
      }

      if (expectedUserType != null && user != null && user.userType != expectedUserType) {
        return Left(
          ServerFailure(
            ServerException(403, _getMismatchErrorMessage(expectedUserType), null),
          ),
        );
      }

      if (result.accessToken != null && result.accessToken!.isNotEmpty) {
        await localDataSource.saveAuthSession(
          token: result.accessToken!,
          refreshToken: result.refreshToken,
          user: user ?? (result.user as UserModel?),
        );
      }

      return Right(
        AuthResponseModel(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          tokenType: result.tokenType,
          user: user ?? result.user,
          message: result.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Login failed',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> verifyOtp({
    required String email,
    required String code,
    UserType? expectedUserType,
  }) async {
    try {
      final result = await remoteDataSource.verifyOtp(
        email: email,
        code: code,
      );

      UserModel? user = result.user as UserModel?;

      if (user == null && result.accessToken != null && result.accessToken!.isNotEmpty) {
        try {
          user = await remoteDataSource.getProfile();
        } catch (_) {}
      }

      if (expectedUserType != null && user != null && user.userType != expectedUserType) {
        return Left(
          ServerFailure(
            ServerException(403, _getMismatchErrorMessage(expectedUserType), null),
          ),
        );
      }

      if (result.accessToken != null && result.accessToken!.isNotEmpty) {
        await localDataSource.saveAuthSession(
          token: result.accessToken!,
          refreshToken: result.refreshToken,
          user: user ?? (result.user as UserModel?),
        );
      }

      return Right(
        AuthResponseModel(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          tokenType: result.tokenType,
          user: user ?? result.user,
          message: result.message,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Verification failed',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, String>> resendOtp({
    required String email,
  }) async {
    try {
      final result = await remoteDataSource.resendOtp(email: email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to resend code',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({
    required String email,
  }) async {
    try {
      final result = await remoteDataSource.forgotPassword(email: email);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to request reset',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, String>> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    try {
      final result = await remoteDataSource.verifyResetOtp(
        email: email,
        code: code,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Invalid code',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String code,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await remoteDataSource.resetPassword(
        email: email,
        code: code,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Password reset failed',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final result = await remoteDataSource.getProfile();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to get profile',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearAuthSession();
      return const Right(null);
    } on ServerException catch (e) {
      await localDataSource.clearAuthSession();
      return Left(ServerFailure(e));
    } catch (e) {
      await localDataSource.clearAuthSession();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, void>> logoutAll() async {
    try {
      await remoteDataSource.logoutAll();
      await localDataSource.clearAuthSession();
      return const Right(null);
    } on ServerException catch (e) {
      await localDataSource.clearAuthSession();
      return Left(ServerFailure(e));
    } catch (e) {
      await localDataSource.clearAuthSession();
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, List<GenderEntity>>> fetchGenders() async {
    try {
      final result = await remoteDataSource.fetchGenders();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch genders',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> fetchCountries() async {
    try {
      final result = await remoteDataSource.fetchCountries();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e));
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'Failed to fetch countries',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
