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
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/setting_action_tile.dart';

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  bool _notificationsEnabled = true;

  void _showLogoutWarningSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: const BoxDecoration(
                  color: AppColors.softBlueBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout_rounded, color: AppColors.darkNavy, size: 32.sp),
              ),
              14.szH,
              Text(S.of(context).logoutConfirmTitle, style: getTextStyle().darkNavy.w700.s18),
              8.szH,
              Text(
                S.of(context).logoutConfirmMsg,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
              ),
              24.szH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderGrey),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(S.of(context).cancel, style: getTextStyle().darkNavy.w700.s14),
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Go.offAllNamed(NamedRoutes.userTypeSelection);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.darkNavy,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(S.of(context).logout, style: getTextStyle().whiteColor.w700.s14),
                    ),
                  ),
                ],
              ),
              10.szH,
            ],
          ),
        );
      },
    );
  }

  void _showDeleteAccountWarningSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (_) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              16.szH,
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: const BoxDecoration(
                  color: AppColors.errorBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.warning_amber_rounded, color: AppColors.errorRed, size: 32.sp),
              ),
              14.szH,
              Text(S.of(context).deleteAccountConfirmTitle, style: getTextStyle().darkNavy.w700.s18),
              8.szH,
              Text(
                S.of(context).deleteAccountConfirmMsg,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.5),
              ),
              24.szH,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.borderGrey),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(S.of(context).cancel, style: getTextStyle().darkNavy.w700.s14),
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Go.offAllNamed(NamedRoutes.userTypeSelection);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.errorRed,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      ),
                      child: Text(S.of(context).confirmDeleteAction, style: getTextStyle().whiteColor.w700.s13),
                    ),
                  ),
                ],
              ),
              10.szH,
            ],
          ),
        );
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
                    color: AppColors.softBlueBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(Icons.notifications_active_outlined, color: AppColors.darkNavy, size: 24.sp),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(S.of(context).notificationsToggleTitle, style: getTextStyle().darkNavy.w700.s15),
                      4.szH,
                      Text(S.of(context).notificationsToggleSub, style: getTextStyle().greyColor.w400.s12),
                    ],
                  ),
                ),
                Switch(
                  value: _notificationsEnabled,
                  activeTrackColor: AppColors.switchActiveTrack,
                  activeThumbColor: AppColors.darkNavy,
                  inactiveTrackColor: AppColors.switchInactiveTrack,
                  inactiveThumbColor: AppColors.switchInactiveThumb,
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
              ],
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

          // 3. Notifications History
          SettingActionTile(
            icon: Icons.notifications_none_rounded,
            iconBgColor: AppColors.successBg,
            iconColor: AppColors.successGreen,
            title: S.of(context).notificationsHistoryTitle,
            subtitle: S.of(context).notificationsHistorySub,
            onTap: () => Go.toNamed(NamedRoutes.notificationsHistory),
          ),

          14.szH,

          // 4. Language Switcher
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

          20.szH,
        ],
      ),
    );
  }
}
