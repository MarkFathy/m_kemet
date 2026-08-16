import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingEntity item;

  const OnboardingPageItem({
    required this.item,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppPadding.pW24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Asset Image with float/fade animation
          Image.asset(
            item.imagePath,
            height: 260.h,
            fit: BoxFit.contain,
          )
              .animate()
              .scale(
                duration: 800.ms,
                curve: Curves.easeOutBack,
              )
              .fadeIn(duration: 600.ms),

          40.szH,

          // Title
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: getTextStyle().darkNavy.w700.s24,
          )
              .animate()
              .fadeIn(delay: 200.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, delay: 200.ms, duration: 600.ms),

          16.szH,

          // Subtitle / Description
          Text(
            item.subTitle,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.6),
          )
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, delay: 400.ms, duration: 600.ms),
        ],
      ),
    );
  }
}
