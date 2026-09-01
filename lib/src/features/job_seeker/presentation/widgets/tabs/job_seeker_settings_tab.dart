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
import 'package:m_kemet/src/features/job_seeker/presentation/widgets/settings/job_seeker_request_status_tile.dart';

class JobSeekerSettingsTab extends StatefulWidget {
  const JobSeekerSettingsTab({super.key});

  @override
  State<JobSeekerSettingsTab> createState() => _JobSeekerSettingsTabState();
}

class _JobSeekerSettingsTabState extends State<JobSeekerSettingsTab> {
  bool _notificationsEnabled = true;

  void _showLogoutWarningSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.logout_rounded,
      iconBgColor: AppColors.softBlueBg,
      iconColor: AppColors.darkNavy,
      title: S.of(context).logoutConfirmTitle,
      message: 'هل أنت متأكد من رغبتك في تسجيل الخروج من حسابك؟',
      cancelLabel: S.of(context).cancel,
      confirmLabel: S.of(context).logout,
      confirmColor: AppColors.darkNavy,
      onConfirm: () => Go.offAllNamed(NamedRoutes.userTypeSelection),
    );
  }

  void _showDeleteAccountWarningSheet(BuildContext context) {
    showConfirmActionBottomSheet(
      context,
      icon: Icons.warning_amber_rounded,
      iconBgColor: AppColors.errorBg,
      iconColor: AppColors.errorRed,
      title: 'تنبيه: حذف حساب الباحث عن عمل',
      message: 'سيؤدي حذف الحساب إلى إلغاء طلبك وكافة بيانات السيرة الذاتية والمستندات نهائياً ولا يمكن استعادتها.',
      cancelLabel: S.of(context).cancel,
      confirmLabel: S.of(context).confirmDeleteAction,
      confirmColor: AppColors.errorRed,
      onConfirm: () => Go.offAllNamed(NamedRoutes.userTypeSelection),
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
          JobSeekerNotificationToggleTile(
            value: _notificationsEnabled,
            onChanged: (val) {
              setState(() => _notificationsEnabled = val);
              CustomSnackBar.showSuccess(
                context,
                message: val
                    ? S.of(context).notificationsEnabledMsg
                    : S.of(context).notificationsDisabledMsg,
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
            subtitle: 'حذف حسابك نهائياً وكافة البيانات المرفوعة',
            onTap: () => _showDeleteAccountWarningSheet(context),
          ),

          24.szH,
        ],
      ),
    );
  }
}
