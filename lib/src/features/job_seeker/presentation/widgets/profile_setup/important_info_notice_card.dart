import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class ImportantInfoNoticeCard extends StatelessWidget {
  const ImportantInfoNoticeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.softBlueBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: AppColors.darkNavy, size: 20.sp),
              8.szW,
              Text(
                S.of(context).importantInfoTitle,
                style: getTextStyle().darkNavy.w700.s16,
              ),
            ],
          ),
          8.szH,
          Text(
            S.of(context).importantInfoDesc,
            style: getTextStyle().darkNavy.w400.s13.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }
}
