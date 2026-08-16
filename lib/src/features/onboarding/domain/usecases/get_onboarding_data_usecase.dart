import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:m_kemet/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingDataUseCase extends BaseUseCaseNoParams<List<OnboardingEntity>> {
  final OnboardingRepository repository;

  GetOnboardingDataUseCase(this.repository);

  @override
  Future<Either<Failure, List<OnboardingEntity>>> call() async {
    return await repository.getOnboardingData();
  }
}
