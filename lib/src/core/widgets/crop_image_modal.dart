import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class CropImageModal extends StatefulWidget {
  final File imageFile;
  final String? title;
  final double? initialAspectRatio;

  const CropImageModal({
    super.key,
    required this.imageFile,
    this.title,
    this.initialAspectRatio,
  });

  static Future<File?> show(
    BuildContext context, {
    required File imageFile,
    String? title,
    double? initialAspectRatio,
  }) {
    return showDialog<File?>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.9),
      builder: (ctx) => CropImageModal(
        imageFile: imageFile,
        title: title,
        initialAspectRatio: initialAspectRatio,
      ),
    );
  }

  @override
  State<CropImageModal> createState() => _CropImageModalState();
}

class _CropImageModalState extends State<CropImageModal> {
  final _cropController = CropController();
  Uint8List? _imageBytes;
  bool _isCropping = false;
  double? _aspectRatio;

  @override
  void initState() {
    super.initState();
    _aspectRatio = widget.initialAspectRatio;
    _loadImageBytes();
  }

  Future<void> _loadImageBytes() async {
    final bytes = await widget.imageFile.readAsBytes();
    if (mounted) {
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _onCropSuccess(Uint8List croppedBytes) async {
    try {
      final tempDir = Directory.systemTemp;
      final tempPath =
          '${tempDir.path}/cropped_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final croppedFile = await File(tempPath).writeAsBytes(croppedBytes);
      if (mounted) {
        Navigator.pop(context, croppedFile);
      }
    } catch (_) {
      if (mounted) {
        Navigator.pop(context, widget.imageFile);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Header ──────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context, null),
                  icon: Icon(Icons.close_rounded, color: Colors.white, size: 22.sp),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    widget.title ?? S.of(context).cropPhoto,
                    style: getTextStyle().whiteColor.w700.s16,
                  ),
                ),
                // Skip Button (Use without crop)
                TextButton(
                  onPressed: () => Navigator.pop(context, widget.imageFile),
                  child: Text(
                    'تخطي',
                    style: getTextStyle().greyColor.w600.s14,
                  ),
                ),
              ],
            ),
          ),

          // ── Cropper Area ─────────────────────────────────────────
          Container(
            height: 0.52.sh,
            width: double.infinity,
            color: Colors.black,
            child: _imageBytes == null
                ? const Center(child: CircularProgressIndicator(color: AppColors.skyBlue))
                : Crop(
                    image: _imageBytes!,
                    controller: _cropController,
                    aspectRatio: _aspectRatio,
                    onCropped: (result) {
                      setState(() => _isCropping = false);
                      if (result is CropSuccess) {
                        _onCropSuccess(result.croppedImage);
                      } else {
                        // Fallback to original
                        Navigator.pop(context, widget.imageFile);
                      }
                    },
                    baseColor: Colors.black,
                    maskColor: Colors.black.withValues(alpha: 0.7),
                    progressIndicator: const Center(
                      child: CircularProgressIndicator(color: AppColors.skyBlue),
                    ),
                  ),
          ),

          // ── Aspect Ratio Bar ─────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRatioChip(label: 'حر', ratio: null),
                  SizedBox(width: 8.w),
                  _buildRatioChip(label: '1:1', ratio: 1.0),
                  SizedBox(width: 8.w),
                  _buildRatioChip(label: '4:3', ratio: 4 / 3),
                  SizedBox(width: 8.w),
                  _buildRatioChip(label: '16:9', ratio: 16 / 9),
                ],
              ),
            ),
          ),

          // ── Bottom Action Button ─────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isCropping
                    ? null
                    : () {
                        setState(() => _isCropping = true);
                        _cropController.crop();
                      },
                icon: _isCropping
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Icon(Icons.check_rounded, color: Colors.white, size: 20.sp),
                label: Text(
                  _isCropping ? 'جاري القص...' : S.of(context).confirmCrop,
                  style: getTextStyle().whiteColor.w700.s15,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkNavy,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.skyBlue, width: 1),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatioChip({required String label, required double? ratio}) {
    final isSelected = _aspectRatio == ratio;
    return InkWell(
      onTap: () {
        setState(() {
          _aspectRatio = ratio;
          _cropController.aspectRatio = ratio;
        });
      },
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavy : const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.skyBlue : const Color(0xFF334155),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: getTextStyle().w600.s13.copyWith(
                color: isSelected ? Colors.white : AppColors.lightGrey,
              ),
        ),
      ),
    );
  }
}
