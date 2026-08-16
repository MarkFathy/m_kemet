import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, List<OnboardingEntity>>> getOnboardingData();
  Future<Either<Failure, void>> setOnboardingCompleted();
  Future<Either<Failure, bool>> isOnboardingCompleted();
}
