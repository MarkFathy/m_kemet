import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/onboarding/domain/repositories/onboarding_repository.dart';

class CompleteOnboardingUseCase extends BaseUseCaseNoParams<void> {
  final OnboardingRepository repository;

  CompleteOnboardingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call() async {
    return await repository.setOnboardingCompleted();
  }
}
