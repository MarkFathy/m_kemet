import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/services/app_lock_service.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/core/services/user_status_service.dart';
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
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
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
    );
}
