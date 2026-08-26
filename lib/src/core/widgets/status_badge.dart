import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

/// A colored dot-indicator + label pill, used to show status across the app.
///
/// Usage:
/// ```dart
/// StatusBadge(
///   label: S.of(context).statusApproved,
///   color: AppColors.successGreen,
///   bgColor: AppColors.successBg,
/// )
/// ```
class StatusBadge extends StatelessWidget {
  final String label;

  /// Text and dot color.
  final Color color;

  /// Pill background color.
  final Color bgColor;

  final TextStyle? textStyle;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          8.szW,
          Text(
            label,
            style: (textStyle ?? const TextStyle()).copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13.sp,
            ),
          ),
        ],
      ),
    );
  }
}
