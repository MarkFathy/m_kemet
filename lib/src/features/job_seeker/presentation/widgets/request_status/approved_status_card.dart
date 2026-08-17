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

class ApprovedStatusCard extends StatelessWidget {
  const ApprovedStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.5), width: 1.5.w),
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
          // Emerald Checkmark Badge Icon
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.successBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.successGreen, width: 2.w),
            ),
            child: Icon(
              Icons.check_circle_rounded,
              color: AppColors.successGreen,
              size: 36.sp,
            ),
          ),

          14.szH,

          // Status Pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8.w,
                  height: 8.w,
                  decoration: const BoxDecoration(
                    color: AppColors.successGreen,
                    shape: BoxShape.circle,
                  ),
                ),
                8.szW,
                Text(
                  S.of(context).statusApproved,
                  style: getTextStyle().w700.s13.copyWith(color: AppColors.successGreen),
                ),
              ],
            ),
          ),

          14.szH,

          Text(
            S.of(context).approvedHeaderTitle,
            textAlign: TextAlign.center,
            style: getTextStyle().darkNavy.w700.s18,
          ),

          6.szH,

          Text(
            S.of(context).approvedHeaderDesc,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.4),
          ),

          20.szH,

          // Unlocked Feature Benefits List Card
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.successBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.successGreen.withValues(alpha: 0.4)),
            ),
            child: Column(
              children: [
                _buildFeatureCheckRow('سيرتك الذاتية أصبحت متاحة للعرض أمام كبرى الشركات الدولية'),
                10.szH,
                _buildFeatureCheckRow('إمكانية التقديم المباشر والتواصل مع أصحاب العمل'),
                10.szH,
                _buildFeatureCheckRow('تفعيل التنبيهات الفورية للوظائف المتطابقة مع تخصصك'),
              ],
            ),
          ),

          20.szH,

          CustomButton(
            text: S.of(context).goToHome,
            onPressed: () {
              Go.offAllNamed(NamedRoutes.home);
            },
            backgroundColor: AppColors.darkNavy,
            textStyle: getTextStyle().whiteColor.w700.s16,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCheckRow(String text) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline_rounded, color: AppColors.successGreen, size: 18.sp),
        10.szW,
        Expanded(
          child: Text(
            text,
            style: getTextStyle().darkNavy.w600.s13.copyWith(height: 1.4),
          ),
        ),
      ],
    );
  }
}
