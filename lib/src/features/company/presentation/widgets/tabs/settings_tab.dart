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
import 'package:m_kemet/src/core/widgets/buttons/language_switcher_button.dart';
import 'package:m_kemet/src/core/widgets/confirm_action_bottom_sheet.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/setting_action_tile.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_cubit.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_state.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  void _showLogoutWarningSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.logout_rounded,
      iconBgColor: AppColors.softBlueBg,
      iconColor: AppColors.darkNavy,
      title: S.of(context).logoutConfirmTitle,
      message: S.of(context).logoutConfirmMsg,
      cancelLabel: S.of(context).cancel,
      confirmLabel: S.of(context).logout,
      confirmColor: AppColors.darkNavy,
      onConfirm: () async {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.darkNavy),
          ),
        );

        await context.read<AuthCubit>().logout();

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
        Go.offAllNamed(NamedRoutes.userTypeSelection);
      },
    );
  }

  void _showDeleteAccountWarningSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.warning_amber_rounded,
      iconBgColor: AppColors.errorBg,
      iconColor: AppColors.errorRed,
      title: S.of(context).deleteAccountConfirmTitle,
      message: S.of(context).deleteAccountConfirmMsg,
      cancelLabel: S.of(context).cancel,
      confirmLabel: S.of(context).confirmDeleteAction,
      confirmColor: AppColors.errorRed,
      onConfirm: () async {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(
            child: CircularProgressIndicator(color: AppColors.errorRed),
          ),
        );

        final success = await context.read<AuthCubit>().deleteAccount();

        if (context.mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }

        if (success) {
          if (context.mounted) {
            CustomSnackBar.showSuccess(
              context,
              message: S.of(context).deleteAccountSuccess,
            );
          }
          Go.offAllNamed(NamedRoutes.userTypeSelection);
        } else {
          if (context.mounted) {
            final error = context.read<AuthCubit>().state.errorMessage ?? S.of(context).deleteAccountFailure;
            CustomSnackBar.showError(context, message: error);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: AppPadding.pW12,
        vertical: AppPadding.pH12,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(S.of(context).navSettings, style: getTextStyle().darkNavy.w700.s24),

          20.szH,

          // 1. Notifications Toggle
          BlocProvider.value(
            value: sl<NotificationsCubit>()..loadNotificationStatus(),
            child: BlocBuilder<NotificationsCubit, NotificationsState>(
              builder: (context, state) {
                return Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.borderGrey),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10.r,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: AppColors.softBlueBg,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Icon(Icons.notifications_active_outlined,
                            color: AppColors.darkNavy, size: 24.sp),
                      ),
                      12.szW,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(S.of(context).notificationsToggleTitle,
                                style: getTextStyle().darkNavy.w700.s15),
                            4.szH,
                            Text(S.of(context).notificationsToggleSub,
                                style: getTextStyle().greyColor.w400.s12),
                          ],
                        ),
                      ),
                      Switch(
                        value: state.notificationsEnabled,
                        activeTrackColor: AppColors.switchActiveTrack,
                        activeThumbColor: AppColors.darkNavy,
                        inactiveTrackColor: AppColors.switchInactiveTrack,
                        inactiveThumbColor: AppColors.switchInactiveThumb,
                        onChanged: (val) {
                          context
                              .read<NotificationsCubit>()
                              .toggleNotificationStatus(val);
                          CustomSnackBar.showSuccess(
                            context,
                            message: val
                                ? S.of(context).notificationsEnabledMsg
                                : S.of(context).notificationsDisabledMsg,
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          14.szH,

          // 2. Saved Candidates
          SettingActionTile(
            icon: Icons.bookmark_border_rounded,
            iconBgColor: AppColors.warningBg,
            iconColor: AppColors.warningAmber,
            title: S.of(context).savedCandidatesTitle,
            subtitle: S.of(context).savedCandidatesSub,
            onTap: () => Go.toNamed(NamedRoutes.savedCandidates),
          ),

          14.szH,

          // 3. Language Switcher
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.chipBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.language_rounded, color: AppColors.darkNavy, size: 24.sp),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).appLanguageTitle, style: getTextStyle().darkNavy.w700.s15),
                      4.szH,
                      Text(S.of(context).appLanguageSub, style: getTextStyle().greyColor.w400.s12),
                    ],
                  ),
                ),
                const LanguageSwitcherButton(),
              ],
            ),
          ),

          14.szH,

          // 5. Logout
          SettingActionTile(
            icon: Icons.logout_rounded,
            iconBgColor: AppColors.softBlueBg,
            iconColor: AppColors.darkNavy,
            title: S.of(context).logout,
            subtitle: S.of(context).logoutSub,
            onTap: () => _showLogoutWarningSheet(context),
          ),

          14.szH,

          // 6. Delete Account
          SettingActionTile(
            icon: Icons.delete_outline_rounded,
            iconBgColor: AppColors.errorBg,
            iconColor: AppColors.errorRed,
            title: S.of(context).deleteAccount,
            subtitle: S.of(context).deleteAccountSub,
            onTap: () => _showDeleteAccountWarningSheet(context),
          ),

          100.szH,
        ],
      ),
    );
  }
}
