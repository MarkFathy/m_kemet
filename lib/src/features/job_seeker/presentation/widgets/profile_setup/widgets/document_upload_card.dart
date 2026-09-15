import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class DocumentUploadCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBgColor;
  final bool isUploaded;
  final bool isUploading;
  final String? fileName;
  final VoidCallback onUploadTap;
  final VoidCallback? onPreviewTap;

  const DocumentUploadCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    required this.iconBgColor,
    required this.isUploaded,
    required this.isUploading,
    this.fileName,
    required this.onUploadTap,
    this.onPreviewTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isUploaded ? onPreviewTap : onUploadTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isUploaded ? AppColors.successGreen : AppColors.borderGrey,
            width: isUploaded ? 1.5.w : 1.w,
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
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22.r,
                  backgroundColor:
                      isUploaded ? AppColors.successBg : iconBgColor,
                  child: Icon(
                    isUploaded ? Icons.check_circle_outline_rounded : icon,
                    color:
                        isUploaded ? AppColors.successGreen : AppColors.darkNavy,
                    size: 20.sp,
                  ),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: getTextStyle().darkNavy.w700.s16,
                      ),
                      if (subtitle != null && subtitle!.isNotEmpty) ...[
                        4.szH,
                        Text(
                          subtitle!,
                          style: getTextStyle().greyColor.w400.s12,
                        ),
                      ],
                    ],
                  ),
                ),
                if (isUploading)
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                else if (isUploaded)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (onPreviewTap != null)
                        InkWell(
                          onTap: onPreviewTap,
                          borderRadius: BorderRadius.circular(8.r),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.softBlueBg,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color:
                                    AppColors.darkNavy.withValues(alpha: 0.2),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.visibility_outlined,
                                  color: AppColors.darkNavy,
                                  size: 16.sp,
                                ),
                                4.szW,
                                Text(
                                  S.of(context).viewPhoto,
                                  style: getTextStyle().darkNavy.w600.s12,
                                ),
                              ],
                            ),
                          ),
                        ),
                      6.szW,
                      InkWell(
                        onTap: onUploadTap,
                        borderRadius: BorderRadius.circular(8.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 5.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.refresh_rounded,
                                color: AppColors.greyColor,
                                size: 16.sp,
                              ),
                              4.szW,
                              Text(
                                S.of(context).changeMedia,
                                style: getTextStyle().greyColor.w600.s12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  OutlinedButton(
                    onPressed: onUploadTap,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.darkNavy,
                      side: const BorderSide(color: AppColors.darkNavy),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                    child: Text(
                      S.of(context).uploadAction,
                      style: getTextStyle().darkNavy.w600.s13,
                    ),
                  ),
              ],
            ),
            if (isUploaded && fileName != null) ...[
              8.szH,
              Row(
                children: [
                  Icon(
                    Icons.attachment_rounded,
                    size: 14.sp,
                    color: AppColors.greyColor,
                  ),
                  4.szW,
                  Expanded(
                    child: Text(
                      fileName!,
                      style: getTextStyle().greyColor.w500.s12,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
