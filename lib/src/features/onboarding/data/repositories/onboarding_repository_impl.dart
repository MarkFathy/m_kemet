import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/onboarding/data/datasources/onboarding_local_data_source.dart';
import 'package:m_kemet/src/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:m_kemet/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<OnboardingEntity>>> getOnboardingData() async {
    try {
      final result = localDataSource.getOnboardingPages();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> setOnboardingCompleted() async {
    try {
      await localDataSource.setOnboardingCompleted();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, bool>> isOnboardingCompleted() async {
    try {
      final result = await localDataSource.isOnboardingCompleted();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
