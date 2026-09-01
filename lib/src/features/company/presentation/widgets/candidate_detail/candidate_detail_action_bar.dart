import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';

class CandidateDetailActionBar extends StatelessWidget {
  const CandidateDetailActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              CustomSnackBar.showSuccess(
                context,
                message: S.of(context).contactRequestSuccess,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkNavy,
              foregroundColor: AppColors.whiteColor,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              S.of(context).requestContact,
              style: getTextStyle().whiteColor.w700.s14,
            ),
          ),
        ),
        12.szW,
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              CustomSnackBar.showInfo(
                context,
                message: S.of(context).cvDownloadInfo,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.darkNavy, width: 1.5.w),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Icon(
              Icons.download_rounded,
              color: AppColors.darkNavy,
              size: 20.sp,
            ),
          ),
        ),
      ],
    );
  }
}
