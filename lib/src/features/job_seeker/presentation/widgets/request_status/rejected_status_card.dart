import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';

class RejectedStatusCard extends StatelessWidget {
  const RejectedStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.5), width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Crimson Warning Badge Icon
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.errorRed, width: 2.w),
            ),
            child: Icon(
              Icons.cancel_rounded,
              color: AppColors.errorRed,
              size: 36.sp,
            ),
          ),

          14.szH,

          // Status Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.errorRed,
                    shape: BoxShape.circle,
                  ),
                ),
                8.szW,
                Text(
                  S.of(context).statusRejected,
                  style: getTextStyle().w700.s13.copyWith(color: AppColors.errorRed),
                ),
              ],
            ),
          ),

          14.szH,

          Text(
            S.of(context).rejectedHeaderTitle,
            textAlign: TextAlign.center,
            style: getTextStyle().darkNavy.w700.s18,
          ),

          6.szH,

          Text(
            S.of(context).rejectedHeaderDesc,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.4),
          ),

          20.szH,

          // Rejection Reason Detail Box
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.errorBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.report_problem_outlined, color: AppColors.errorRed, size: 18.sp),
                    8.szW,
                    Text(
                      S.of(context).rejectionReasonTitle,
                      style: getTextStyle().darkNavy.w700.s15.copyWith(color: AppColors.errorRed),
                    ),
                  ],
                ),
                8.szH,
                Text(
                  S.of(context).rejectionReasonSample,
                  style: getTextStyle().darkNavy.w500.s13.copyWith(
                        color: AppColors.errorRed,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          ),

          20.szH,

          // Resubmit Application Action Button
          CustomButton(
            text: S.of(context).resubmitRequest,
            onPressed: () {
              Go.offAllNamed(NamedRoutes.jobSeekerProfileSetup);
            },
            backgroundColor: AppColors.errorRed,
            textStyle: getTextStyle().whiteColor.w700.s16,
          ),

          12.szH,

          OutlinedButton(
            onPressed: () {
              CustomSnackBar.showInfo(
                context,
                message: 'فريق الدعم الفني جاهز لمساعدتك في استكمال ملفك',
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 44.h),
              foregroundColor: AppColors.darkNavy,
              side: const BorderSide(color: AppColors.darkNavy),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.headset_mic_outlined, size: 18.sp, color: AppColors.darkNavy),
                8.szW,
                Text(
                  S.of(context).contactSupport,
                  style: getTextStyle().darkNavy.w700.s14,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
