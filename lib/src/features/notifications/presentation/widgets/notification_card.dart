import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

class NotificationCard extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback? onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    this.onDelete,
  });

  IconData _getIcon() {
    switch (notification.type) {
      case 'request':
        return Icons.work_outline_rounded;
      case 'approval':
        return Icons.verified_rounded;
      case 'status':
        return Icons.swap_horiz_rounded;
      case 'security':
        return Icons.shield_outlined;
      case 'tip':
        return Icons.lightbulb_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  Color _getIconColor() {
    switch (notification.type) {
      case 'approval':
        return AppColors.successGreen;
      case 'security':
        return AppColors.warningAmber;
      case 'request':
        return AppColors.darkNavy;
      case 'status':
        return AppColors.steelBlue;
      default:
        return AppColors.darkNavy;
    }
  }

  Color _getIconBgColor() {
    switch (notification.type) {
      case 'approval':
        return AppColors.successBg;
      case 'security':
        return AppColors.warningBg;
      case 'request':
      case 'status':
        return AppColors.softBlueBg;
      default:
        return AppColors.chipBg;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderGrey
              : AppColors.skyBlue.withValues(alpha: 0.5),
          width: notification.isRead ? 1 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: notification.isRead
                ? Colors.black.withValues(alpha: 0.02)
                : AppColors.darkNavy.withValues(alpha: 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(AppPadding.pW12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: _getIconBgColor(),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: _getIconColor(),
                    size: 22.sp,
                  ),
                ),

                12.szW,

                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: getTextStyle().darkNavy.s14.copyWith(
                                    fontWeight: notification.isRead
                                        ? FontWeight.w600
                                        : FontWeight.w700,
                                  ),
                            ),
                          ),
                          if (!notification.isRead) ...[
                            6.szW,
                            Container(
                              width: 8.w,
                              height: 8.h,
                              decoration: const BoxDecoration(
                                color: AppColors.steelBlue,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),

                      6.szH,

                      Text(
                        notification.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: getTextStyle().greyColor.w400.s12.copyWith(
                              height: 1.4,
                            ),
                      ),

                      8.szH,

                      // Time stamp
                      if (notification.timeAgo != null)
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_rounded,
                              size: 12.sp,
                              color: AppColors.greyColor,
                            ),
                            4.szW,
                            Text(
                              notification.timeAgo!,
                              style: getTextStyle().greyColor.w400.s11,
                            ),
                          ],
                        ),
                    ],
                  ),
                ),

                8.szW,

                // Forward Arrow
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14.sp,
                    color: AppColors.lightGrey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
