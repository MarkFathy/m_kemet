import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class NotificationsEmptyCard extends StatelessWidget {
  const NotificationsEmptyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          Icon(Icons.notifications_none_rounded, size: 54.sp, color: AppColors.greyColor),
          16.szH,
          Text(
            S.of(context).noNotificationsTitle,
            style: getTextStyle().darkNavy.w700.s16,
          ),
          8.szH,
          Text(
            S.of(context).noNotificationsSub,
            textAlign: TextAlign.center,
            style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
