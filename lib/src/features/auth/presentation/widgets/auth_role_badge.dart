import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class AuthRoleBadge extends StatelessWidget {
  final bool isEmployer;

  const AuthRoleBadge({
    super.key,
    required this.isEmployer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isEmployer ? AppColors.successBg : const Color(0xFFD0E8FF),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isEmployer ? Icons.business_rounded : Icons.person_search_rounded,
            size: 16.sp,
            color: isEmployer ? AppColors.successGreen : AppColors.darkNavy,
          ),
          6.szW,
          Text(
            isEmployer ? S.of(context).employerTitle : S.of(context).jobSeekerTitle,
            style: getTextStyle().darkNavy.w600.s12,
          ),
        ],
      ),
    );
  }
}
