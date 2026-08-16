import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {
  final String title;
  final String subTitle;
  final String imagePath;

  const OnboardingEntity({
    required this.title,
    required this.subTitle,
    required this.imagePath,
  });

  @override
  List<Object?> get props => [title, subTitle, imagePath];
}
