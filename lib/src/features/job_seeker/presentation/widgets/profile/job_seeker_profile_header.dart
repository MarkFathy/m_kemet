import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';

class JobSeekerProfileHeader extends StatelessWidget {
  const JobSeekerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).candidateProfileTitle,
          style: getTextStyle().darkNavy.w700.s22,
        ),
        InkWell(
          onTap: () => Go.toNamed(NamedRoutes.notifications),
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              Icons.notifications_none_rounded,
              color: AppColors.darkNavy,
              size: 24.sp,
            ),
          ),
        ),
      ],
    );
  }
}
