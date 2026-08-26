import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

/// A generic empty-state placeholder: large icon + bold title + optional subtitle.
///
/// Use this whenever a list, search result, or tab has no data to display.
///
/// Usage:
/// ```dart
/// EmptyState(
///   icon: Icons.search_off_rounded,
///   title: S.of(context).noSearchResultsTitle,
///   subtitle: S.of(context).noSearchResultsSub,
/// )
/// ```
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;

  /// Optional widget below the subtitle (e.g. a retry button).
  final Widget? action;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 54.sp, color: AppColors.greyColor),
            12.szH,
            Text(
              title,
              textAlign: TextAlign.center,
              style: getTextStyle().darkNavy.w700.s16,
            ),
            if (subtitle != null) ...[
              6.szH,
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: getTextStyle().greyColor.w400.s13,
              ),
            ],
            if (action != null) ...[
              20.szH,
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
