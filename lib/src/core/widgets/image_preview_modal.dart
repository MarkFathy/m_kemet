import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class ImagePreviewModal extends StatelessWidget {
  final File? file;
  final String? imageUrl;
  final String title;
  final VoidCallback? onChange;

  const ImagePreviewModal({
    super.key,
    this.file,
    this.imageUrl,
    required this.title,
    this.onChange,
  });

  static Future<void> show(
    BuildContext context, {
    File? file,
    String? imageUrl,
    required String title,
    VoidCallback? onChange,
  }) {
    return showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.85),
      builder: (ctx) => ImagePreviewModal(
        file: file,
        imageUrl: imageUrl,
        title: title,
        onChange: onChange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Top Header ──────────────────────────────────────────
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: AppColors.midnightNavy,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.close_rounded,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    title,
                    style: getTextStyle().whiteColor.w700.s16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (onChange != null)
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onChange!();
                    },
                    icon: Icon(
                      Icons.refresh_rounded,
                      color: AppColors.skyBlue,
                      size: 18.sp,
                    ),
                    label: Text(
                      S.of(context).changeImageAction,
                      style: getTextStyle().w600.s14.copyWith(
                        color: AppColors.skyBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ── Image Viewer Body ───────────────────────────────────
          Flexible(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxHeight: 0.65.sh),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(16.r),
                ),
                child: InteractiveViewer(
                  minScale: 0.8,
                  maxScale: 4.0,
                  child: Center(child: _buildImage(context)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    if (file != null && file!.existsSync()) {
      return Image.file(file!, fit: BoxFit.contain);
    }
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.contain,
        placeholder: (context, url) => const Center(
          child: CircularProgressIndicator(color: AppColors.skyBlue),
        ),
        errorWidget: (context, url, error) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image_rounded,
              color: Colors.white54,
              size: 48.sp,
            ),
            SizedBox(height: 8.h),
            Text(
              S.of(context).failedToLoadImage,
              style: getTextStyle().whiteColor.w500.s14,
            ),
          ],
        ),
      );
    }
    return Center(
      child: Text(
        S.of(context).noImageToDisplay,
        style: getTextStyle().whiteColor.w500.s14,
      ),
    );
  }
}
