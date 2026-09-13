import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';

class JobSeekerRequestStatusTile extends StatelessWidget {
  const JobSeekerRequestStatusTile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
      builder: (context, state) {
        final statusStr = state.profileDetail?.status?.toLowerCase().trim();
        final Color statusColor;
        final Color statusBgColor;
        final IconData statusIcon;
        final String statusLabel;

        if (statusStr == 'approved') {
          statusColor = AppColors.successGreen;
          statusBgColor = AppColors.successBg;
          statusIcon = Icons.check_circle_rounded;
          statusLabel = S.of(context).statusApproved;
        } else if (statusStr == 'rejected') {
          statusColor = AppColors.errorRed;
          statusBgColor = AppColors.errorBg;
          statusIcon = Icons.cancel_rounded;
          statusLabel = S.of(context).statusRejected;
        } else {
          statusColor = AppColors.warningAmber;
          statusBgColor = AppColors.warningBg;
          statusIcon = Icons.hourglass_top_rounded;
          statusLabel = S.of(context).statusPending;
        }

        return InkWell(
          onTap: () => Go.toNamed(NamedRoutes.requestStatus),
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: statusColor.withValues(alpha: 0.4),
                width: 1.2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: statusColor.withValues(alpha: 0.08),
                  blurRadius: 12.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    statusIcon,
                    color: statusColor,
                    size: 26.sp,
                  ),
                ),
                14.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              S.of(context).requestStatusScreenTitle,
                              style: getTextStyle().darkNavy.w700.s15,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          8.szW,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: statusBgColor,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              statusLabel,
                              style: getTextStyle().w700.s11.copyWith(
                                    color: statusColor,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      4.szH,
                      Text(
                        'اضغط لمتابعة مراحل مراجعة واعتماد ملفك',
                        style: getTextStyle().greyColor.w400.s12,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: AppColors.greyColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

