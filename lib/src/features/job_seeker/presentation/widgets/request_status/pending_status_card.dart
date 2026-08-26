import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/status_badge.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/application_timeline_step.dart';

class PendingStatusCard extends StatelessWidget {
  const PendingStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.5), width: 1.5.w),
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
          // Hourglass Animated Badge Icon
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              color: AppColors.warningBg,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.warningAmber, width: 2.w),
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              color: AppColors.warningAmber,
              size: 32.sp,
            ),
          ),

          14.szH,

          StatusBadge(
            label: S.of(context).statusPending,
            color: AppColors.warningAmber,
            bgColor: AppColors.warningBg,
          ),

          14.szH,

          Text(
            S.of(context).pendingHeaderTitle,
            textAlign: TextAlign.center,
            style: getTextStyle().darkNavy.w700.s18,
          ),

          6.szH,

          Text(
            S.of(context).pendingHeaderDesc,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.4),
          ),

          20.szH,

          // Application Steps Timeline Box
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.pageBg,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Column(
              children: [
                ApplicationTimelineStep(
                  stepNum: '1',
                  title: S.of(context).step1Title,
                  subtitle: 'تمت العملية بنجاح',
                  isCompleted: true,
                  isActive: false,
                ),
                const ApplicationTimelineDivider(isCompleted: true),
                ApplicationTimelineStep(
                  stepNum: '2',
                  title: S.of(context).step2Title,
                  subtitle: 'جارٍ الفحص والمراجعة الحالية',
                  isCompleted: false,
                  isActive: true,
                ),
                const ApplicationTimelineDivider(isCompleted: false),
                ApplicationTimelineStep(
                  stepNum: '3',
                  title: S.of(context).step3Title,
                  subtitle: 'بانتظار اكتمال الفحص',
                  isCompleted: false,
                  isActive: false,
                ),
              ],
            ),
          ),

          16.szH,

          // Request Reference Summary Box
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.softBlueBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.tag_rounded,
                  label: S.of(context).requestIdLabel,
                  value: '#MSR-84920',
                ),
                Divider(height: 16.h, color: AppColors.borderGrey),
                _buildInfoRow(
                  icon: Icons.calendar_today_rounded,
                  label: S.of(context).submissionDateLabel,
                  value: '17 أغسطس 2026',
                ),
                Divider(height: 16.h, color: AppColors.borderGrey),
                _buildInfoRow(
                  icon: Icons.timer_outlined,
                  label: S.of(context).estimatedTimeLabel,
                  value: S.of(context).estimatedTimeValue,
                ),
              ],
            ),
          ),

          20.szH,

          // Support Button
          OutlinedButton(
            onPressed: () {
              CustomSnackBar.showInfo(
                context,
                message: 'فريق الدعم متاح على مدار الساعة عبر البريد أو الوتساب',
              );
            },
            style: OutlinedButton.styleFrom(
              minimumSize: Size(double.infinity, 48.h),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 18.sp, color: AppColors.darkNavy),
        8.szW,
        Text(
          label,
          style: getTextStyle().darkNavy.w600.s13,
        ),
        const Spacer(),
        Text(
          value,
          style: getTextStyle().darkNavy.w700.s13,
        ),
      ],
    );
  }
}
