import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingState extends Equatable {
  final List<OnboardingEntity> pages;
  final int currentPage;
  final bool isLastPage;
  final bool isCompleted;

  const OnboardingState({
    this.pages = const [],
    this.currentPage = 0,
    this.isLastPage = false,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    List<OnboardingEntity>? pages,
    int? currentPage,
    bool? isLastPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      pages: pages ?? this.pages,
      currentPage: currentPage ?? this.currentPage,
      isLastPage: isLastPage ?? this.isLastPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [pages, currentPage, isLastPage, isCompleted];
}
