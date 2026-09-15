import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class CvUploadCard extends StatelessWidget {
  final bool isUploaded;
  final bool isUploading;
  final String? fileName;
  final VoidCallback onUploadTap;

  const CvUploadCard({
    super.key,
    required this.isUploaded,
    required this.isUploading,
    this.fileName,
    required this.onUploadTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isUploaded ? AppColors.successGreen : AppColors.borderGrey,
        ),
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
                  color:
                      isUploaded ? AppColors.successBg : AppColors.borderGrey,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.description_outlined,
                  color:
                      isUploaded ? AppColors.successGreen : AppColors.darkNavy,
                  size: 22.sp,
                ),
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
              if (isUploaded)
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.successBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    S.of(context).uploadedBadge,
                    style: getTextStyle()
                        .w600
                        .s11
                        .copyWith(color: AppColors.successGreen),
                  ),
                )
              else
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.errorBg,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    S.of(context).requiredBadge,
                    style: getTextStyle()
                        .w600
                        .s11
                        .copyWith(color: AppColors.errorRed),
                  ),
                ),
            ],
          ),
          14.szH,
          if (isUploading)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: const CircularProgressIndicator(),
              ),
            )
          else
            InkWell(
              onTap: onUploadTap,
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                width: double.infinity,
                padding:
                    EdgeInsets.symmetric(vertical: 16.h, horizontal: 14.w),
                decoration: BoxDecoration(
                  color: isUploaded
                      ? AppColors.successBg.withValues(alpha: 0.3)
                      : AppColors.pageBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: isUploaded
                        ? AppColors.successGreen
                        : AppColors.darkNavy.withValues(alpha: 0.3),
                    width: 1.5.w,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      isUploaded
                          ? Icons.check_circle_outline_rounded
                          : Icons.cloud_upload_outlined,
                      size: 28.sp,
                      color: isUploaded
                          ? AppColors.successGreen
                          : AppColors.darkNavy,
                    ),
                    8.szH,
                    Text(
                      isUploaded && fileName != null
                          ? fileName!
                          : S.of(context).dragAndDropHint,
                      textAlign: TextAlign.center,
                      style: getTextStyle().darkNavy.w600.s13,
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
