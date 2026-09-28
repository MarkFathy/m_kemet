import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
// import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/status_badge.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/request_status/application_timeline_step.dart';

class PendingStatusCard extends StatelessWidget {
  final int? requestId;

  const PendingStatusCard({
    super.key,
    this.requestId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Icon & Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.hourglass_top_rounded,
                  color: AppColors.warningAmber,
                  size: 32.sp,
                ),
              ),
              StatusBadge(
                label: S.of(context).statusPending,
                color: AppColors.warningAmber,
                bgColor: AppColors.warningBg,
              ),
            ],
          ),

          16.szH,

          // Main Card Title
          Text(
            S.of(context).pendingHeaderTitle,
            style: getTextStyle().darkNavy.w700.s20,
          ),

          8.szH,

          // Descriptive Notice Message
          Text(
            S.of(context).pendingHeaderDesc,
            style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
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
                  subtitle: S.of(context).timelineStepCompletedSub,
                  isCompleted: true,
                  isActive: false,
                ),
                const ApplicationTimelineDivider(isCompleted: true),
                ApplicationTimelineStep(
                  stepNum: '2',
                  title: S.of(context).step2Title,
                  subtitle: S.of(context).timelineStepUnderReviewSub,
                  isCompleted: false,
                  isActive: true,
                ),
                const ApplicationTimelineDivider(isCompleted: false),
                ApplicationTimelineStep(
                  stepNum: '3',
                  title: S.of(context).step3Title,
                  subtitle: S.of(context).timelineStepPendingReviewSub,
                  isCompleted: false,
                  isActive: false,
                ),
              ],
            ),
          ),

          16.szH,

          // Request Reference Summary Box (Only real data, no dummy values)
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.softBlueBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                if (requestId != null) ...[
                  _buildInfoRow(
                    icon: Icons.tag_rounded,
                    label: S.of(context).requestIdLabel,
                    value: '#$requestId',
                  ),
                  Divider(height: 16.h, color: AppColors.borderGrey),
                ],
                _buildInfoRow(
                  icon: Icons.timer_outlined,
                  label: S.of(context).estimatedTimeLabel,
                  value: S.of(context).estimatedTimeValue,
                ),
              ],
            ),
          ),

          // 20.szH,

          // // Support Button
          // OutlinedButton(
          //   onPressed: () {
          //     CustomSnackBar.showInfo(
          //       context,
          //       message: S.of(context).supportAvailable247,
          //     );
          //   },
          //   style: OutlinedButton.styleFrom(
          //     minimumSize: Size(double.infinity, 48.h),
          //     side: const BorderSide(color: AppColors.darkNavy),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12.r),
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(
          //         Icons.support_agent_rounded,
          //         color: AppColors.darkNavy,
          //         size: 20.sp,
          //       ),
          //       8.szW,
          //       Text(
          //         S.of(context).contactSupport,
          //         style: getTextStyle().darkNavy.w700.s14,
          //       ),
          //     ],
          //   ),
          // ),
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
        Icon(icon, size: 16.sp, color: AppColors.darkNavy),
        8.szW,
        Text(
          label,
          style: getTextStyle().greyColor.w500.s13,
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
