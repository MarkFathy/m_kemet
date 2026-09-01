import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class JobSeekerProfileHeader extends StatelessWidget {
  final VoidCallback onEdit;

  const JobSeekerProfileHeader({
    super.key,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            S.of(context).candidateProfileTitle,
            style: getTextStyle().darkNavy.w700.s22,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        8.szW,
        InkWell(
          onTap: onEdit,
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.softBlueBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.darkNavy.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_note_rounded, color: AppColors.darkNavy, size: 18.sp),
                4.szW,
                Text(
                  'تعديل الحساب',
                  style: getTextStyle().darkNavy.w700.s12,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
