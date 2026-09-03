import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/services/app_lock_service.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/core/services/user_status_service.dart';
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
import 'package:m_kemet/src/features/onboarding/data/datasources/onboarding_local_data_source.dart';
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
  // External Storage
  final sharedPrefs = await SharedPreferences.getInstance();
  await CacheStorage.init(sharedPrefs);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPrefs);
  sl.registerLazySingleton(() => const FlutterSecureStorage());

  // App Cubit
  sl
    ..registerLazySingleton(AppCubit.new)

    // Services
    ..registerLazySingleton(NotificationService.new)
    ..registerLazySingleton(UserStatusService.new)
    ..registerLazySingleton(AppLockService.new)

    // Onboarding Feature
    ..registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sl()),
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

    // User Type Selection Feature
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

    // Employer Dashboard Candidate Search Feature
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
        toggleBookmarkUseCase: sl(),
        initialCandidate: candidate,
        initialIsBookmarked: sl<BookmarksCubit>().state.isBookmarked(candidate.id),
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
