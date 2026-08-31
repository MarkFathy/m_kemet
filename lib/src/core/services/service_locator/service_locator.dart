import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/core/services/app_lock_service.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/core/services/user_status_service.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:m_kemet/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_countries_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_genders_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/login_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/logout_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_candidate_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/register_company_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/resend_otp_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/verify_reset_otp_usecase.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_local_data_source.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_remote_data_source.dart';
import 'package:m_kemet/src/features/company/data/repositories/candidate_repository_impl.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/toggle_save_candidate_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:m_kemet/src/features/onboarding/data/datasources/onboarding_remote_data_source.dart';
import 'package:m_kemet/src/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:m_kemet/src/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:m_kemet/src/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:m_kemet/src/features/onboarding/domain/usecases/get_onboarding_data_usecase.dart';
import 'package:m_kemet/src/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:m_kemet/src/features/user_type_selection/data/datasources/user_type_local_data_source.dart';
import 'package:m_kemet/src/features/user_type_selection/data/repositories/user_type_repository_impl.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/repositories/user_type_repository.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/usecases/save_user_type_usecase.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async => setupServiceLocator();

Future<void> setupServiceLocator() async {
  // ─── External Storage ────────────────────────────────────────────────────
  final sharedPrefs = await SharedPreferences.getInstance();
  await CacheStorage.init(sharedPrefs);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // ─── Network ─────────────────────────────────────────────────────────────
  // DioClient is a singleton that holds the configured Dio instance with:
  //   • AuthInterceptor   — attaches Bearer token from SecureStorage
  //   • ErrorInterceptor  — maps HTTP errors → typed ServerException
  //   • PrettyDioLogger   — request/response logging (debug builds only)
  sl.registerLazySingleton(DioClient.new);

  // ─── App Cubit ───────────────────────────────────────────────────────────
  sl
    ..registerLazySingleton(AppCubit.new)

    // ─── Services ──────────────────────────────────────────────────────────
    ..registerLazySingleton(NotificationService.new)
    ..registerLazySingleton(UserStatusService.new)
    ..registerLazySingleton(AppLockService.new)

    // ─── Onboarding Feature ────────────────────────────────────────────────
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<OnboardingRemoteDataSource>(
      // TODO: Swap to real impl when backend is ready:
      // () => OnboardingRemoteDataSourceImpl(sl<DioClient>()),
      OnboardingRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetOnboardingDataUseCase(sl()))
    ..registerLazySingleton(() => CompleteOnboardingUseCase(sl()))
    ..registerFactory(
      () => OnboardingCubit(
        getOnboardingDataUseCase: sl(),
        completeOnboardingUseCase: sl(),
      ),
    )

    // ─── User Type Selection Feature ───────────────────────────────────────
    ..registerLazySingleton<UserTypeLocalDataSource>(
      () => UserTypeLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<UserTypeRepository>(
      () => UserTypeRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => SaveUserTypeUseCase(sl()))
    ..registerFactory(
      () => UserTypeCubit(
        saveUserTypeUseCase: sl(),
      ),
    )

    // ─── Auth Feature ──────────────────────────────────────────────────────
    ..registerLazySingleton<AuthLocalDataSource>(
      AuthLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton(() => RegisterCandidateUseCase(sl()))
    ..registerLazySingleton(() => RegisterCompanyUseCase(sl()))
    ..registerLazySingleton(() => LoginUseCase(sl()))
    ..registerLazySingleton(() => VerifyOtpUseCase(sl()))
    ..registerLazySingleton(() => ResendOtpUseCase(sl()))
    ..registerLazySingleton(() => ForgotPasswordUseCase(sl()))
    ..registerLazySingleton(() => VerifyResetOtpUseCase(sl()))
    ..registerLazySingleton(() => ResetPasswordUseCase(sl()))
    ..registerLazySingleton(() => GetProfileUseCase(sl()))
    ..registerLazySingleton(() => LogoutUseCase(sl()))
    ..registerLazySingleton(() => GetGendersUseCase(sl()))
    ..registerLazySingleton(() => GetCountriesUseCase(sl()))
    ..registerFactory(
      () => AuthCubit(
        registerCandidateUseCase: sl(),
        registerCompanyUseCase: sl(),
        loginUseCase: sl(),
        verifyOtpUseCase: sl(),
        resendOtpUseCase: sl(),
        forgotPasswordUseCase: sl(),
        verifyResetOtpUseCase: sl(),
        resetPasswordUseCase: sl(),
        getProfileUseCase: sl(),
        logoutUseCase: sl(),
        getGendersUseCase: sl(),
        getCountriesUseCase: sl(),
      ),
    )

    // ─── Employer Candidate Search Feature ─────────────────────────────────
    ..registerLazySingleton<CandidateLocalDataSource>(
      CandidateLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<CandidateRemoteDataSource>(
      // TODO: Swap to real impl when backend is ready:
      // () => CandidateRemoteDataSourceImpl(sl<DioClient>()),
      CandidateRemoteDataSourceImpl.new,
    )
    ..registerLazySingleton<CandidateRepository>(
      () => CandidateRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton(() => GetCandidatesUseCase(sl()))
    ..registerLazySingleton(() => ToggleSaveCandidateUseCase(sl()))
    ..registerFactory(
      () => CandidateSearchCubit(
        getCandidatesUseCase: sl(),
        toggleSaveCandidateUseCase: sl(),
      ),
    );
}
