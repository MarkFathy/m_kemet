import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/widgets/confirm_action_bottom_sheet.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/setting_action_tile.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/settings/job_seeker_language_tile.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/settings/job_seeker_notification_toggle_tile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/settings/job_seeker_request_status_tile.dart';

class JobSeekerSettingsTab extends StatelessWidget {
  const JobSeekerSettingsTab({super.key});

  static final ValueNotifier<bool> _notificationsNotifier = ValueNotifier<bool>(true);

  void _showLogoutWarningSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.logout_rounded,
      iconBgColor: AppColors.softBlueBg,
      iconColor: AppColors.darkNavy,
      title: S.of(context).logoutConfirmTitle,
      message: S.of(context).jobSeekerLogoutConfirmMsg,
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
      title: S.of(context).jobSeekerDeleteAccountConfirmTitle,
      message: S.of(context).jobSeekerDeleteAccountConfirmMsg,
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

          // 1. Request Status Highlight Tile
          const JobSeekerRequestStatusTile(),

          14.szH,

          // 2. Notifications Toggle
          ValueListenableBuilder<bool>(
            valueListenable: _notificationsNotifier,
            builder: (context, notificationsEnabled, _) {
              return JobSeekerNotificationToggleTile(
                value: notificationsEnabled,
                onChanged: (val) {
                  _notificationsNotifier.value = val;
                  CustomSnackBar.showSuccess(
                    context,
                    message: val
                        ? S.of(context).notificationsEnabledMsg
                        : S.of(context).notificationsDisabledMsg,
                  );
                },
              );
            },
          ),

          14.szH,

          // 3. Notifications History
          SettingActionTile(
            icon: Icons.notifications_none_rounded,
            iconBgColor: AppColors.successBg,
            iconColor: AppColors.successGreen,
            title: S.of(context).notificationsTitle,
            subtitle: S.of(context).notificationsHistorySub,
            onTap: () => Go.toNamed(NamedRoutes.notifications),
          ),

          14.szH,

          // 4. Terms & Privacy
          SettingActionTile(
            icon: Icons.description_outlined,
            iconBgColor: AppColors.chipBg,
            iconColor: AppColors.darkNavy,
            title: S.of(context).termsScreenTitle,
            subtitle: 'الشروط والأحكام وسياسة الخصوصية للاستخدام',
            onTap: () => Go.toNamed(NamedRoutes.termsAndConditions),
          ),

          14.szH,

          // 5. Language Switcher
          const JobSeekerLanguageTile(),

          14.szH,

          // 6. Logout
          SettingActionTile(
            icon: Icons.logout_rounded,
            iconBgColor: AppColors.softBlueBg,
            iconColor: AppColors.darkNavy,
            title: S.of(context).logout,
            subtitle: S.of(context).logoutSub,
            onTap: () => _showLogoutWarningSheet(context),
          ),

          14.szH,

          // 7. Delete Account
          SettingActionTile(
            icon: Icons.delete_outline_rounded,
            iconBgColor: AppColors.errorBg,
            iconColor: AppColors.errorRed,
            title: S.of(context).deleteAccount,
            subtitle: S.of(context).jobSeekerDeleteAccountSub,
            onTap: () => _showDeleteAccountWarningSheet(context),
          ),

          100.szH,
        ],
      ),
    );
  }
}
