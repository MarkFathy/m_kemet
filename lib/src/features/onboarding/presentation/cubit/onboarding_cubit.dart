import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:m_kemet/src/features/onboarding/domain/usecases/get_onboarding_data_usecase.dart';
import 'package:m_kemet/src/features/onboarding/presentation/cubit/onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  final GetOnboardingDataUseCase getOnboardingDataUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;

  OnboardingCubit({
    required this.getOnboardingDataUseCase,
    required this.completeOnboardingUseCase,
  }) : super(const OnboardingState());

  void loadOnboardingData() async {
    final result = await getOnboardingDataUseCase();
    result.fold(
      (failure) {},
      (pages) {
        emit(state.copyWith(
          pages: pages,
          isLastPage: pages.length <= 1,
        ));
      },
    );
  }

  void onPageChanged(int index) {
    final isLast = index == state.pages.length - 1;
    emit(state.copyWith(
      currentPage: index,
      isLastPage: isLast,
    ));
  }

  Future<void> finishOnboarding() async {
    await completeOnboardingUseCase();
    emit(state.copyWith(isCompleted: true));
  }
}
