import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

/// A compact icon + label chip with configurable colors.
///
/// Used in candidate cards, filter chips, and detail screens.
///
/// Usage:
/// ```dart
/// InfoChip(
///   icon: Icons.location_on_outlined,
///   label: 'مصر',
///   bgColor: AppColors.chipBg,
///   textColor: AppColors.darkNavy,
/// )
/// ```
class InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color bgColor;
  final Color textColor;

  const InfoChip({
    super.key,
    required this.icon,
    required this.label,
    required this.bgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13.sp, color: textColor),
          4.szW,
          Text(
            label,
            style: getTextStyle().w500.s11.copyWith(color: textColor),
          ),
        ],
      ),
    );
  }
}
