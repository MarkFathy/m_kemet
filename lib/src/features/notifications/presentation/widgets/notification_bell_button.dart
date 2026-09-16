import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_state.dart';

class NotificationBellButton extends StatefulWidget {
  final VoidCallback? onTap;

  const NotificationBellButton({
    super.key,
    this.onTap,
  });

  @override
  State<NotificationBellButton> createState() => _NotificationBellButtonState();
}

class _NotificationBellButtonState extends State<NotificationBellButton> {
  @override
  void initState() {
    super.initState();
    final cubit = sl<NotificationsCubit>();
    if (cubit.state.status == NotificationListStatus.initial) {
      cubit.loadNotifications();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotificationsCubit>(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final unreadCount = state.unreadCount;

          return InkWell(
            onTap: () async {
              if (widget.onTap != null) {
                widget.onTap!();
              } else {
                await Go.toNamed(NamedRoutes.notifications);
                if (context.mounted) {
                  context.read<NotificationsCubit>().loadNotifications();
                }
              }
            },
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.borderGrey),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8.r,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    Icons.notifications_none_rounded,
                    color: AppColors.darkNavy,
                    size: 24.sp,
                  ),
                  if (unreadCount > 0)
                    PositionedDirectional(
                      top: -4.h,
                      end: -4.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                        constraints: BoxConstraints(
                          minWidth: 17.w,
                          minHeight: 17.w,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorRed,
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.whiteColor,
                            width: 1.5.w,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.errorRed.withValues(alpha: 0.35),
                              blurRadius: 4.r,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          unreadCount > 99 ? '99+' : unreadCount.toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w700,
                            height: 1.1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
