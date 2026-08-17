import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class IntroVideoUploadCard extends StatelessWidget {
  final VoidCallback? onUploadTap;

  const IntroVideoUploadCard({
    super.key,
    this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.5), width: 1.5.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.warningBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.videocam_rounded,
                  color: AppColors.warningAmber,
                  size: 22.sp,
                ),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).introVideoTitle,
                      style: getTextStyle().darkNavy.w700.s16,
                    ),
                    4.szH,
                    Text(
                      'فيديو مدته 1 دقيقة لتعريف بالكفاءة',
                      style: getTextStyle().greyColor.w600.s12,
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.errorBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  S.of(context).requiredBadge,
                  style: getTextStyle().w600.s11.copyWith(color: AppColors.errorRed),
                ),
              ),
            ],
          ),

          12.szH,

          // Instructions Callout
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.pageBg,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.warningAmber.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline_rounded, color: AppColors.warningAmber, size: 20.sp),
                8.szW,
                Expanded(
                  child: Text(
                    S.of(context).introVideoDesc,
                    style: getTextStyle().darkNavy.w500.s13.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),

          14.szH,

          // Dropzone
          InkWell(
            onTap: onUploadTap ?? () {},
            borderRadius: BorderRadius.circular(12.r),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.warningAmber,
                  width: 1.5.w,
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.video_call_rounded, size: 36.sp, color: AppColors.warningAmber),
                  8.szH,
                  Text(
                    S.of(context).recordVideoHint,
                    textAlign: TextAlign.center,
                    style: getTextStyle().darkNavy.w700.s14,
                  ),
                  6.szH,
                  Text(
                    'الحد الأقصى للمدة: 01:00 دقيقة | MP4 / MOV',
                    style: getTextStyle().greyColor.w400.s12,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
