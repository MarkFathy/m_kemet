import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class ImageSourceSelectionBottomSheet extends StatelessWidget {
  final ValueChanged<ImageSource> onSourceSelected;
  final String? title;
  final String? cameraLabel;
  final String? galleryLabel;
  final IconData? cameraIcon;
  final IconData? galleryIcon;

  const ImageSourceSelectionBottomSheet({
    required this.onSourceSelected,
    this.title,
    this.cameraLabel,
    this.galleryLabel,
    this.cameraIcon,
    this.galleryIcon,
    super.key,
  });

  static Future<void> show(
    BuildContext context, {
    required ValueChanged<ImageSource> onSourceSelected,
    String? title,
    String? cameraLabel,
    String? galleryLabel,
    IconData? cameraIcon,
    IconData? galleryIcon,
  }) =>
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (_) => ImageSourceSelectionBottomSheet(
          onSourceSelected: onSourceSelected,
          title: title,
          cameraLabel: cameraLabel,
          galleryLabel: galleryLabel,
          cameraIcon: cameraIcon,
          galleryIcon: galleryIcon,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle Pill ─────────────────────────────────────
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          16.szH,

          // ── Title ────────────────────────────────────────────────
          Text(
            title ?? 'اختيار مصدر الصورة',
            style: getTextStyle().darkNavy.w700.s18,
          ),
          20.szH,

          // ── Options Row (Camera & Gallery) ───────────────────────
          Row(
            children: [
              // ── Camera Option ─────────────────────────────────────
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onSourceSelected(ImageSource.camera);
                  },
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFFD0E8FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            cameraIcon ?? Icons.camera_alt_rounded,
                            size: 26.sp,
                            color: AppColors.darkNavy,
                          ),
                        ),
                        10.szH,
                        Text(
                          cameraLabel ?? 'الكاميرا',
                          textAlign: TextAlign.center,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),

              // ── Gallery Option ────────────────────────────────────
              Expanded(
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    onSourceSelected(ImageSource.gallery);
                  },
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 18.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5.w,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52.r,
                          height: 52.r,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE0E7FF),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            galleryIcon ?? Icons.photo_library_rounded,
                            size: 26.sp,
                            color: AppColors.steelBlue,
                          ),
                        ),
                        10.szH,
                        Text(
                          galleryLabel ?? 'المعرض',
                          textAlign: TextAlign.center,
                          style: getTextStyle().darkNavy.w700.s16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          20.szH,
        ],
      ),
    );
  }
}
