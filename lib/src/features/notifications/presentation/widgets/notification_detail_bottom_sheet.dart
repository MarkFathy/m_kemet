import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

class NotificationDetailBottomSheet extends StatelessWidget {
  final NotificationEntity notification;

  const NotificationDetailBottomSheet({
    super.key,
    required this.notification,
  });

  static Future<void> show(BuildContext context, NotificationEntity notification) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NotificationDetailBottomSheet(notification: notification),
    );
  }

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
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pW16,
        vertical: AppPadding.pH16,
      ),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle Bar
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),

            16.szH,

            // Header Row (Icon + Tag)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: _getIconBgColor(),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    _getIcon(),
                    color: _getIconColor(),
                    size: 26.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 4.h,
                  ),
                  decoration: BoxDecoration(
                    color: notification.isRead
                        ? AppColors.chipBg
                        : AppColors.softBlueBg,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!notification.isRead) ...[
                        Container(
                          width: 6.w,
                          height: 6.h,
                          decoration: const BoxDecoration(
                            color: AppColors.steelBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                        6.szW,
                      ],
                      Text(
                        notification.isRead
                            ? S.of(context).notificationStatusRead
                            : S.of(context).notificationStatusNew,
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: notification.isRead
                              ? AppColors.greyColor
                              : AppColors.darkNavy,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            14.szH,

            // Title
            Text(
              notification.title,
              style: getTextStyle().darkNavy.w700.s18,
            ),

            8.szH,

            // Time Ago
            if (notification.timeAgo != null)
              Row(
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    size: 14.sp,
                    color: AppColors.greyColor,
                  ),
                  6.szW,
                  Text(
                    notification.timeAgo!,
                    style: getTextStyle().greyColor.w400.s12,
                  ),
                ],
              ),

            16.szH,

            // Body Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppColors.pageBg,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.borderGrey),
              ),
              child: Text(
                notification.body,
                style: getTextStyle().darkNavy.w400.s14.copyWith(
                      height: 1.6,
                    ),
              ),
            ),

            20.szH,

            // Action Buttons
            Row(
              children: [
                if (notification.actionRoute != null) ...[
                  Expanded(
                    child: SizedBox(
                      height: 46.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (notification.actionRoute == 'contact_requests') {
                            Go.toNamed(NamedRoutes.myContactRequests);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkNavy,
                          foregroundColor: AppColors.whiteColor,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          S.of(context).notificationGoToDetails,
                          style: getTextStyle().whiteColor.w600.s14,
                        ),
                      ),
                    ),
                  ),
                  12.szW,
                ],
                Expanded(
                  child: SizedBox(
                    height: 46.h,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderGrey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        S.of(context).notificationClose,
                        style: getTextStyle().greyColor.w600.s14,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            10.szH,
          ],
        ),
      ),
    );
  }
}
