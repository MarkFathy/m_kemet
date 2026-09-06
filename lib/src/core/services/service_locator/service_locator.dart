import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/network/connectivity_cubit.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/core/services/app_lock_service.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/core/services/user_status_service.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:m_kemet/src/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:m_kemet/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:m_kemet/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:m_kemet/src/features/auth/domain/usecases/delete_account_usecase.dart';
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
import 'package:m_kemet/src/features/bookmarks/data/datasources/bookmarks_local_data_source.dart';
import 'package:m_kemet/src/features/bookmarks/data/datasources/bookmarks_remote_data_source.dart';
import 'package:m_kemet/src/features/bookmarks/data/repositories/bookmarks_repository_impl.dart';
import 'package:m_kemet/src/features/bookmarks/domain/repositories/bookmarks_repository.dart';
import 'package:m_kemet/src/features/bookmarks/domain/usecases/get_bookmarks_usecase.dart';
import 'package:m_kemet/src/features/bookmarks/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:m_kemet/src/features/bookmarks/presentation/cubit/bookmarks_cubit.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_local_data_source.dart';
import 'package:m_kemet/src/features/company/data/datasources/candidate_remote_data_source.dart';
import 'package:m_kemet/src/features/company/data/repositories/candidate_repository_impl.dart';
import 'package:m_kemet/src/features/company/domain/repositories/candidate_repository.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidate_detail_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/get_saved_candidates_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/send_contact_request_usecase.dart';
import 'package:m_kemet/src/features/company/domain/usecases/toggle_save_candidate_usecase.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_detail_cubit.dart';
import 'package:m_kemet/src/features/company/presentation/cubit/candidate_search_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/data/datasources/job_seeker_remote_data_source.dart';
import 'package:m_kemet/src/features/job_seeker/data/repositories/job_seeker_repository_impl.dart';
import 'package:m_kemet/src/features/job_seeker/domain/repositories/job_seeker_repository.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_candidate_profile_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_job_seeker_lookups_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/update_candidate_profile_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/upload_candidate_document_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/upload_candidate_video_usecase.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
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
  sl.registerFactory(ConnectivityCubit.new);

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
    ..registerLazySingleton(() => DeleteAccountUseCase(sl()))
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
        deleteAccountUseCase: sl(),
        getGendersUseCase: sl(),
        getCountriesUseCase: sl(),
      ),
    )

    // ─── Job Seeker Profile Feature ────────────────────────────────────────
    ..registerLazySingleton<JobSeekerRemoteDataSource>(
      () => JobSeekerRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<JobSeekerRepository>(
      () => JobSeekerRepositoryImpl(remoteDataSource: sl()),
    )
    ..registerLazySingleton(() => GetJobSeekerLookupsUseCase(sl()))
    ..registerLazySingleton(() => GetCandidateProfileUseCase(sl()))
    ..registerLazySingleton(() => UpdateCandidateProfileUseCase(sl()))
    ..registerLazySingleton(() => UploadCandidateDocumentUseCase(sl()))
    ..registerLazySingleton(() => UploadCandidateVideoUseCase(sl()))
    ..registerFactory(
      () => JobSeekerProfileCubit(
        getJobSeekerLookupsUseCase: sl(),
        getCandidateProfileUseCase: sl(),
        updateCandidateProfileUseCase: sl(),
        uploadCandidateDocumentUseCase: sl(),
        uploadCandidateVideoUseCase: sl(),
      ),
    )

    // ─── Employer Candidate Search Feature ─────────────────────────────────
    ..registerLazySingleton<CandidateLocalDataSource>(
      CandidateLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<CandidateRemoteDataSource>(
      () => CandidateRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<CandidateRepository>(
      () => CandidateRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton(() => GetCandidatesUseCase(sl()))
    ..registerLazySingleton(() => GetSavedCandidatesUseCase(sl()))
    ..registerLazySingleton(() => ToggleSaveCandidateUseCase(sl()))
    ..registerLazySingleton(() => GetCandidateDetailUseCase(sl()))
    ..registerLazySingleton(() => SendContactRequestUseCase(sl()))
    ..registerFactory(
      () => CandidateSearchCubit(
        getCandidatesUseCase: sl(),
        toggleSaveCandidateUseCase: sl(),
        getSavedCandidatesUseCase: sl(),
      ),
    )
    ..registerFactoryParam<CandidateDetailCubit, CandidateEntity, void>(
      (candidate, _) => CandidateDetailCubit(
        getCandidateDetailUseCase: sl(),
        sendContactRequestUseCase: sl(),
        initialCandidate: candidate,
        initialIsBookmarked: sl<BookmarksCubit>().state.bookmarkedIds.contains(candidate.id),
      ),
    )

    // ─── Bookmarks Feature ──────────────────────────────────────────────────
    ..registerLazySingleton<BookmarksLocalDataSource>(
      BookmarksLocalDataSourceImpl.new,
    )
    ..registerLazySingleton<BookmarksRemoteDataSource>(
      () => BookmarksRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<BookmarksRepository>(
      () => BookmarksRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton(() => GetBookmarksUseCase(sl()))
    ..registerLazySingleton(() => ToggleBookmarkUseCase(sl()))
    ..registerLazySingleton(
      () => BookmarksCubit(
        getBookmarksUseCase: sl(),
        toggleBookmarkUseCase: sl(),
      ),
    );
}
