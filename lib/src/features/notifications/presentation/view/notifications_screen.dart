import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/confirm_action_bottom_sheet.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_state.dart';
import 'package:m_kemet/src/features/notifications/presentation/widgets/notification_card.dart';
import 'package:m_kemet/src/features/notifications/presentation/widgets/notification_detail_bottom_sheet.dart';
import 'package:m_kemet/src/features/notifications/presentation/widgets/notifications_empty_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<NotificationsCubit>()..loadNotifications(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  void _showDeleteAllConfirmation(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.delete_sweep_rounded,
      iconBgColor: AppColors.errorBg,
      iconColor: AppColors.errorRed,
      title: S.of(context).notificationsDeleteAllTitle,
      message: S.of(context).notificationsDeleteAllMsg,
      cancelLabel: S.of(context).cancel,
      confirmLabel: S.of(context).notificationsDeleteAllConfirm,
      confirmColor: AppColors.errorRed,
      onConfirm: () {
        context.read<NotificationsCubit>().deleteAllNotifications();
      },
    );
  }

  void _onNotificationTap(BuildContext context, NotificationEntity item) {
    if (!item.isRead) {
      context.read<NotificationsCubit>().markAsRead(item.id);
    }
    NotificationDetailBottomSheet.show(context, item.copyWith(isRead: true));
  }

  void _onDeleteNotification(BuildContext context, int index, NotificationEntity item) {
    context.read<NotificationsCubit>().deleteNotification(item.id);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.midnightNavy,
        content: Text(
          S.of(context).notificationDeleted,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
        action: SnackBarAction(
          label: S.of(context).notificationsUndo,
          textColor: AppColors.skyBlue,
          onPressed: () {
            context.read<NotificationsCubit>().restoreNotification(index, item);
          },
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationsCubit, NotificationsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        if (state.errorMessage != null) {
          CustomSnackBar.showError(context, message: state.errorMessage!);
        } else if (state.successMessage != null) {
          CustomSnackBar.showSuccess(context, message: state.successMessage!);
        }
      },
      builder: (context, state) {
        final displayList = state.filteredNotifications;

        return AppScaffold(
          safeTop: true,
          safeBottom: true,
          backgroundColor: AppColors.pageBg,
          body: Column(
            children: [
              // ── Header Bar ─────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppPadding.pW12,
                  vertical: AppPadding.pH12,
                ),
                child: Row(
                  children: [
                    const CustomBackButton(),
                    12.szW,
                    Text(
                      S.of(context).notificationsTitle,
                      style: getTextStyle().darkNavy.w700.s20,
                    ),
                    const Spacer(),

                    // Mark all as read button
                    if (state.unreadCount > 0) ...[
                      InkWell(
                        onTap: () => context.read<NotificationsCubit>().markAllAsRead(),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                          child: Row(
                            children: [
                              Icon(
                                Icons.done_all_rounded,
                                size: 16.sp,
                                color: AppColors.steelBlue,
                              ),
                              4.szW,
                              Text(
                                S.of(context).notificationsMarkAllAsRead,
                                style: getTextStyle().steelBlue.w600.s12,
                              ),
                            ],
                          ),
                        ),
                      ),
                      6.szW,
                    ],

                    // Delete all button
                    if (state.notifications.isNotEmpty)
                      InkWell(
                        onTap: () => _showDeleteAllConfirmation(context),
                        borderRadius: BorderRadius.circular(10.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                          child: Icon(
                            Icons.delete_outline_rounded,
                            size: 20.sp,
                            color: AppColors.errorRed.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // ── Filter Chips ────────────────────────────────────────────
              if (state.notifications.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppPadding.pW12,
                    vertical: 4.h,
                  ),
                  child: Row(
                    children: [
                      _buildFilterChip(
                        context: context,
                        index: 0,
                        label: S.of(context).notificationsFilterAll,
                        count: state.notifications.length,
                        isSelected: state.selectedFilterIndex == 0,
                      ),
                      8.szW,
                      _buildFilterChip(
                        context: context,
                        index: 1,
                        label: S.of(context).notificationsFilterUnread,
                        count: state.unreadCount,
                        isSelected: state.selectedFilterIndex == 1,
                      ),
                    ],
                  ),
                ),

              12.szH,

              // ── Notifications Body ──────────────────────────────────────
              Expanded(
                child: _buildBody(context, state, displayList),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(
    BuildContext context,
    NotificationsState state,
    List<NotificationEntity> displayList,
  ) {
    if (state.status == NotificationListStatus.loading && state.notifications.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.darkNavy),
      );
    }

    if (state.status == NotificationListStatus.failure && state.notifications.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off_rounded, size: 48.sp, color: AppColors.greyColor),
              12.szH,
              Text(
                state.errorMessage ?? S.of(context).notificationsLoadError,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w500.s14,
              ),
              16.szH,
              ElevatedButton.icon(
                onPressed: () => context.read<NotificationsCubit>().loadNotifications(),
                icon: const Icon(Icons.refresh_rounded),
                label: Text(S.of(context).notificationsRetry),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkNavy,
                  foregroundColor: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (displayList.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
        color: AppColors.darkNavy,
        backgroundColor: AppColors.whiteColor,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: AppPadding.pW12,
            vertical: AppPadding.pH16,
          ),
          child: const NotificationsEmptyCard(),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<NotificationsCubit>().loadNotifications(),
      color: AppColors.darkNavy,
      backgroundColor: AppColors.whiteColor,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW12,
          vertical: 6.h,
        ),
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          final item = displayList[index];
          return Dismissible(
            key: ValueKey('notification_${item.id}_${item.createdAt.millisecondsSinceEpoch}'),
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: EdgeInsetsDirectional.only(end: 20.w),
              decoration: BoxDecoration(
                color: AppColors.errorRed,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.delete_outline_rounded, color: AppColors.whiteColor, size: 22.sp),
                  8.szW,
                  Text(
                    S.of(context).notificationsSwipeDelete,
                    style: getTextStyle().whiteColor.w600.s14,
                  ),
                ],
              ),
            ),
            onDismissed: (_) => _onDeleteNotification(context, index, item),
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: NotificationCard(
                notification: item,
                onTap: () => _onNotificationTap(context, item),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChip({
    required BuildContext context,
    required int index,
    required String label,
    required int count,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => context.read<NotificationsCubit>().setFilter(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavy : AppColors.whiteColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.darkNavy : AppColors.borderGrey,
            width: 1.w,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.darkNavy.withValues(alpha: 0.18),
                    blurRadius: 8.r,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: isSelected
                  ? getTextStyle().whiteColor.w600.s13
                  : getTextStyle().darkNavy.w500.s13,
            ),
            if (count > 0) ...[
              6.szW,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.whiteColor.withValues(alpha: 0.22)
                      : AppColors.softBlueBg,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  count > 99 ? '99+' : count.toString(),
                  style: isSelected
                      ? getTextStyle().whiteColor.w700.s11
                      : getTextStyle().darkNavy.w700.s11,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
