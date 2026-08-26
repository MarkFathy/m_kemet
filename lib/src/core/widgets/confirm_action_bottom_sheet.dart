import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

/// A standardized bottom sheet for destructive or important confirmation actions.
///
/// Displays: drag handle → icon badge → title → message → [Cancel | Confirm] buttons.
///
/// Usage:
/// ```dart
/// showConfirmActionBottomSheet(
///   context,
///   icon: Icons.logout_rounded,
///   iconBgColor: AppColors.softBlueBg,
///   iconColor: AppColors.darkNavy,
///   title: S.of(context).logoutConfirmTitle,
///   message: S.of(context).logoutConfirmMsg,
///   cancelLabel: S.of(context).cancel,
///   confirmLabel: S.of(context).logout,
///   confirmColor: AppColors.darkNavy,
///   onConfirm: () => Go.offAllNamed(NamedRoutes.userTypeSelection),
/// );
/// ```
void showConfirmActionBottomSheet(
  BuildContext context, {
  required IconData icon,
  required Color iconBgColor,
  required Color iconColor,
  required String title,
  required String message,
  required String cancelLabel,
  required String confirmLabel,
  required Color confirmColor,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (_) => _ConfirmActionBottomSheet(
      icon: icon,
      iconBgColor: iconBgColor,
      iconColor: iconColor,
      title: title,
      message: message,
      cancelLabel: cancelLabel,
      confirmLabel: confirmLabel,
      confirmColor: confirmColor,
      onConfirm: onConfirm,
    ),
  );
}

class _ConfirmActionBottomSheet extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final String title;
  final String message;
  final String cancelLabel;
  final String confirmLabel;
  final Color confirmColor;
  final VoidCallback onConfirm;

  const _ConfirmActionBottomSheet({
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.title,
    required this.message,
    required this.cancelLabel,
    required this.confirmLabel,
    required this.confirmColor,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 44.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          16.szH,

          // Icon Badge
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(color: iconBgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 32.sp),
          ),

          14.szH,

          Text(title, style: getTextStyle().darkNavy.w700.s18),

          8.szH,

          Text(
            message,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
          ),

          24.szH,

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.borderGrey),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(cancelLabel, style: getTextStyle().darkNavy.w700.s14),
                ),
              ),
              12.szW,
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: confirmColor,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(confirmLabel, style: getTextStyle().whiteColor.w700.s14),
                ),
              ),
            ],
          ),

          10.szH,
        ],
      ),
    );
  }
}
