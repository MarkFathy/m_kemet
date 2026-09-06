import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/core/widgets/image_source_selection_bottom_sheet.dart';
import 'package:m_kemet/src/core/widgets/video_preview_modal.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_cubit.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';
import 'package:video_player/video_player.dart';

class IntroVideoUploadCard extends StatelessWidget {
  const IntroVideoUploadCard({super.key});

  void _previewVideo(BuildContext context, JobSeekerProfileState state) {
    final file = state.localVideoPath != null && state.localVideoPath!.isNotEmpty
        ? File(state.localVideoPath!)
        : null;
    final url = state.uploadedVideo?.fileUrl ??
        state.uploadedVideo?.filePath ??
        state.profileDetail?.videoUrl;

    VideoPreviewModal.show(
      context,
      file: file,
      videoUrl: url,
      title: S.of(context).introVideoTitle,
      onChange: () => _pickAndUploadVideo(context),
    );
  }

  Future<void> _pickAndUploadVideo(BuildContext context) async {
    ImageSourceSelectionBottomSheet.show(
      context,
      title: 'اختيار الفيديو التعريفي',
      cameraLabel: 'تسجيل بالكاميرا',
      galleryLabel: 'المعرض',
      cameraIcon: Icons.videocam_rounded,
      galleryIcon: Icons.video_library_rounded,
      onSourceSelected: (source) async {
        final picker = ImagePicker();
        final picked = await picker.pickVideo(
          source: source,
          maxDuration: const Duration(seconds: 60),
        );
        if (picked == null) return;

        final file = File(picked.path);

        // Validate video duration: maximum 1 minute (60 seconds)
        VideoPlayerController? videoController;
        try {
          videoController = VideoPlayerController.file(file);
          await videoController.initialize();
          final duration = videoController.value.duration;

          if (duration.inSeconds > 60) {
            if (context.mounted) {
              CustomSnackBar.showError(
                context,
                message: 'يرجى رفع فيديو لا يتجاوز دقيقة واحدة (60 ثانية)',
              );
            }
            return;
          }
        } catch (_) {
          // If video controller initialization fails, allow flow to proceed
        } finally {
          await videoController?.dispose();
        }

        if (context.mounted) {
          await context.read<JobSeekerProfileCubit>().uploadIntroVideo(file);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JobSeekerProfileCubit, JobSeekerProfileState>(
      builder: (context, state) {
        final isUploaded = state.uploadedVideo != null ||
            state.videoStatus == DocumentUploadStatus.success ||
            (state.profileDetail?.videoUrl != null && state.profileDetail!.videoUrl!.isNotEmpty);
        final isUploading = state.videoStatus == DocumentUploadStatus.uploading;
        final fileName = state.uploadedVideo?.originalName ??
            state.localVideoPath?.split(Platform.pathSeparator).last;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isUploaded
                  ? AppColors.successGreen
                  : AppColors.warningAmber.withValues(alpha: 0.5),
              width: 1.5.w,
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
                      color: isUploaded ? AppColors.successBg : AppColors.warningBg,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      isUploaded ? Icons.check_circle_outline_rounded : Icons.videocam_rounded,
                      color: isUploaded ? AppColors.successGreen : AppColors.warningAmber,
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
                          'فيديو تعريفي لا يتجاوز دقيقة واحدة (60 ثانية)',
                          style: getTextStyle().greyColor.w600.s12,
                        ),
                      ],
                    ),
                  ),
                  if (isUploaded)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Text(
                        S.of(context).uploadedBadge,
                        style: getTextStyle().w600.s11.copyWith(color: AppColors.successGreen),
                      ),
                    )
                  else
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

              if (isUploading)
                Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      children: [
                        const CircularProgressIndicator(),
                        8.szH,
                        Text(
                          'جاري رفع الفيديو التعريفي...',
                          style: getTextStyle().darkNavy.w500.s13,
                        ),
                      ],
                    ),
                  ),
                )
              else if (isUploaded)
                Row(
                  children: [
                    // Play & Watch Video Button
                    Expanded(
                      flex: 3,
                      child: ElevatedButton.icon(
                        onPressed: () => _previewVideo(context, state),
                        icon: Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 20.sp),
                        label: Text(
                          S.of(context).watchVideo,
                          style: getTextStyle().whiteColor.w700.s14,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.darkNavy,
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                    10.szW,
                    // Change Button
                    Expanded(
                      flex: 2,
                      child: OutlinedButton.icon(
                        onPressed: () => _pickAndUploadVideo(context),
                        icon: Icon(Icons.refresh_rounded, color: AppColors.darkNavy, size: 18.sp),
                        label: Text(
                          S.of(context).changeMedia,
                          style: getTextStyle().darkNavy.w600.s13,
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.darkNavy),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                        ),
                      ),
                    ),
                  ],
                ),
              if (isUploaded && fileName != null) ...[
                8.szH,
                Row(
                  children: [
                    Icon(Icons.attachment_rounded, size: 14.sp, color: AppColors.greyColor),
                    4.szW,
                    Expanded(
                      child: Text(
                        fileName,
                        style: getTextStyle().greyColor.w500.s12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
              if (!isUploaded && !isUploading)
                InkWell(
                  onTap: () => _pickAndUploadVideo(context),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: AppColors.softBlueBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.darkNavy,
                        width: 1.w,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.video_call_rounded,
                          size: 22.sp,
                          color: AppColors.darkNavy,
                        ),
                        8.szW,
                        Text(
                          'اختر فيديو أو قم بالتسجيل',
                          style: getTextStyle().darkNavy.w700.s14,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
