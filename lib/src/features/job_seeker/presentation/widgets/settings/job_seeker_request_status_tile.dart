import 'dart:async';

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
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/view/request_status_screen.dart';

class JobSeekerRequestStatusTile extends StatefulWidget {
  const JobSeekerRequestStatusTile({super.key});

  @override
  State<JobSeekerRequestStatusTile> createState() =>
      _JobSeekerRequestStatusTileState();
}

class _JobSeekerRequestStatusTileState
    extends State<JobSeekerRequestStatusTile> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    // 1. Initial immediate check on mount
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<JobSeekerProfileCubit>().refreshProfile();
      }
    });

    // 2. Periodic polling every 4 seconds to catch backend status changes live
    _pollingTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (mounted) {
        context.read<JobSeekerProfileCubit>().refreshProfile();
      }
    });

    // 3. Instant 0ms update when any push notification arrives
    NotificationService.notificationTriggerNotifier.addListener(_onNotificationReceived);
  }

  void _onNotificationReceived() {
    if (mounted) {
      context.read<JobSeekerProfileCubit>().refreshProfile();
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    NotificationService.notificationTriggerNotifier.removeListener(_onNotificationReceived);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
      builder: (context, state) {
        final statusStr = state.profileDetail?.status?.toLowerCase().trim();
        final Color statusColor;
        final Color statusBgColor;
        final IconData statusIcon;
        final String statusLabel;
        final RequestApprovalStatus initialStatusEnum;

        if (statusStr == 'approved') {
          statusColor = AppColors.successGreen;
          statusBgColor = AppColors.successBg;
          statusIcon = Icons.check_circle_rounded;
          statusLabel = S.of(context).statusApproved;
          initialStatusEnum = RequestApprovalStatus.approved;
        } else if (statusStr == 'rejected') {
          statusColor = AppColors.errorRed;
          statusBgColor = AppColors.errorBg;
          statusIcon = Icons.cancel_rounded;
          statusLabel = S.of(context).statusRejected;
          initialStatusEnum = RequestApprovalStatus.rejected;
        } else {
          statusColor = AppColors.warningAmber;
          statusBgColor = AppColors.warningBg;
          statusIcon = Icons.hourglass_top_rounded;
          statusLabel = S.of(context).statusPending;
          initialStatusEnum = RequestApprovalStatus.pending;
        }

        return InkWell(
          onTap: () async {
            await Go.toNamed(
              NamedRoutes.requestStatus,
              arguments: initialStatusEnum,
            );
            // Reload profile from backend so the status badge is always up-to-date
            if (context.mounted) {
              context.read<JobSeekerProfileCubit>().refreshProfile();
            }
          },
          borderRadius: BorderRadius.circular(16.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
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
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
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
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
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
                        S.of(context).requestStatusTileSubtitle,
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

