import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingDotsIndicator extends StatelessWidget {
  final PageController controller;
  final int count;

  const OnboardingDotsIndicator({
    required this.controller,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SmoothPageIndicator(
      controller: controller,
      count: count,
      effect: ExpandingDotsEffect(
        activeDotColor: AppColors.darkNavy,
        dotColor: AppColors.greyColor.withValues(alpha: 0.4),
        dotHeight: 8.h,
        dotWidth: 8.w,
        expansionFactor: 3,
        spacing: 8.w,
      ),
    );
  }
}
