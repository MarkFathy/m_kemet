import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class DocumentsUploadSection extends StatelessWidget {
  const DocumentsUploadSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).documentsSectionTitle,
          style: getTextStyle().darkNavy.w700.s20,
        ),

        12.szH,

        // Item 1: Personal Photo
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.softBlueBg,
                child: Icon(Icons.add_a_photo_outlined, color: AppColors.darkNavy, size: 20.sp),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).personalPhotoTitle,
                      style: getTextStyle().darkNavy.w700.s16,
                    ),
                    4.szH,
                    Text(
                      'صورة شخصية حديثة بخلفية بيضاء',
                      style: getTextStyle().greyColor.w400.s12,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkNavy,
                  side: const BorderSide(color: AppColors.darkNavy),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text(
                  'رفع',
                  style: getTextStyle().darkNavy.w600.s13,
                ),
              ),
            ],
          ),
        ),

        12.szH,

        // Item 2: National ID / Passport Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
                  color: AppColors.successBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(Icons.credit_card_rounded, color: AppColors.successGreen, size: 22.sp),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      S.of(context).idCardTitle,
                      style: getTextStyle().darkNavy.w700.s16,
                    ),
                    4.szH,
                    Text(
                      'صورة وجهي البطاقة الشخصية',
                      style: getTextStyle().greyColor.w400.s12,
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.darkNavy,
                  side: const BorderSide(color: AppColors.darkNavy),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                ),
                child: Text(
                  'رفع',
                  style: getTextStyle().darkNavy.w600.s13,
                ),
              ),
            ],
          ),
        ),

        12.szH,

        // Item 3: Passport Copy Card
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.softBlueBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.badge_outlined,
                      color: AppColors.darkNavy,
                      size: 22.sp,
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).passportCopyTitle,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                        4.szH,
                        Text(
                          S.of(context).passportCopyDesc,
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.successBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      S.of(context).uploadedBadge,
                      style: getTextStyle().w600.s11.copyWith(
                            color: AppColors.successGreen,
                          ),
                    ),
                  ),
                ],
              ),

              12.szH,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('100%', style: getTextStyle().greyColor.w600.s12),
                  Row(
                    children: [
                      Text('passport_scan_v2.pdf', style: getTextStyle().darkNavy.w600.s13),
                      6.szW,
                      Icon(Icons.check_circle_rounded, color: AppColors.successGreen, size: 16.sp),
                    ],
                  ),
                ],
              ),
              6.szH,
              ClipRRect(
                borderRadius: BorderRadius.circular(4.r),
                child: LinearProgressIndicator(
                  value: 1.0,
                  minHeight: 6.h,
                  backgroundColor: AppColors.borderGrey,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.successGreen),
                ),
              ),
            ],
          ),
        ),

        12.szH,

        // Item 4: CV Upload Dropzone
        Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(Icons.description_outlined, color: AppColors.darkNavy, size: 22.sp),
                  ),
                  12.szW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          S.of(context).cvTitle,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                        4.szH,
                        Text(
                          S.of(context).cvDesc,
                          style: getTextStyle().greyColor.w400.s12,
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

              14.szH,

              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(12.r),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
                  decoration: BoxDecoration(
                    color: AppColors.pageBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.darkNavy.withValues(alpha: 0.3),
                      width: 1.5.w,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.cloud_upload_outlined, size: 28.sp, color: AppColors.darkNavy),
                      8.szH,
                      Text(
                        S.of(context).dragAndDropHint,
                        textAlign: TextAlign.center,
                        style: getTextStyle().darkNavy.w600.s13,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
