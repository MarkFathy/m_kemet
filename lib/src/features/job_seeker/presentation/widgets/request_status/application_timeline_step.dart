import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class ApplicationTimelineStep extends StatelessWidget {
  final String stepNum;
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;

  const ApplicationTimelineStep({
    super.key,
    required this.stepNum,
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final Color circleBg = isCompleted
        ? AppColors.successGreen
        : isActive
            ? AppColors.warningAmber
            : AppColors.borderGrey;

    final Widget innerWidget = isCompleted
        ? Icon(Icons.check_rounded, color: AppColors.whiteColor, size: 14.sp)
        : Text(
            stepNum,
            style: TextStyle(color: AppColors.whiteColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
          );

    return Row(
      children: [
        Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            color: circleBg,
            shape: BoxShape.circle,
          ),
          child: Center(child: innerWidget),
        ),
        12.szW,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: isActive
                    ? getTextStyle().darkNavy.w700.s14
                    : isCompleted
                        ? getTextStyle().darkNavy.w600.s14
                        : getTextStyle().greyColor.w500.s14,
              ),
              2.szH,
              Text(
                subtitle,
                style: getTextStyle().greyColor.w400.s12,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ApplicationTimelineDivider extends StatelessWidget {
  final bool isCompleted;

  const ApplicationTimelineDivider({
    super.key,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 12.w, right: 12.w, top: 4.h, bottom: 4.h),
      alignment: Alignment.centerRight,
      height: 20.h,
      child: VerticalDivider(
        thickness: 2.w,
        color: isCompleted ? AppColors.successGreen : AppColors.borderGrey,
      ),
    );
  }
}
