import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/video_preview_modal.dart';

class CandidateVideoCard extends StatelessWidget {
  final String videoUrl;
  final String? thumbnailUrl;

  const CandidateVideoCard({
    super.key,
    required this.videoUrl,
    this.thumbnailUrl,
  });

  @override
  Widget build(BuildContext context) {
    // If candidate has no video, display the clear unavailable status
    if (videoUrl.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.softBlueBg,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.videocam_off_outlined,
                    color: AppColors.greyColor,
                    size: 22.sp,
                  ),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        S.of(context).candidateVideoTitle,
                        style: getTextStyle().darkNavy.w700.s14,
                      ),
                      3.szH,
                      Text(
                        'لا يتوفر فيديو تعريفي لهذا المرشح',
                        style: getTextStyle().greyColor.w500.s12,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          20.szH,
        ],
      );
    }

    // When candidate HAS video: show clickable video card that plays the video
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).candidateVideoTitle,
          style: getTextStyle().darkNavy.w700.s16,
        ),
        10.szH,
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              VideoPreviewModal.show(
                context,
                videoUrl: videoUrl,
                title: S.of(context).candidateVideoTitle,
              );
            },
            borderRadius: BorderRadius.circular(16.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: SizedBox(
                height: 150.h,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Video thumbnail if available, or dark cinematic video background
                    if (thumbnailUrl != null && thumbnailUrl!.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: thumbnailUrl!,
                        fit: BoxFit.cover,
                        color: Colors.black.withValues(alpha: 0.45),
                        colorBlendMode: BlendMode.darken,
                        placeholder: (context, url) => Container(color: AppColors.midnightNavy),
                        errorWidget: (context, url, error) => Container(color: AppColors.midnightNavy),
                      )
                    else
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.midnightNavy,
                              AppColors.darkNavy,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.video_library_rounded,
                            size: 64.sp,
                            color: AppColors.whiteColor.withValues(alpha: 0.08),
                          ),
                        ),
                      ),

                    // Play Button & "Click to watch" banner
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              color: AppColors.darkNavy.withValues(alpha: 0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.play_arrow_rounded,
                              color: AppColors.whiteColor,
                              size: 34.sp,
                            ),
                          ),
                          10.szH,
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.visibility_rounded, size: 14.sp, color: AppColors.whiteColor),
                                6.szW,
                                Text(
                                  'اضغط لمشاهدة الفيديو',
                                  style: getTextStyle().whiteColor.w600.s12,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        20.szH,
      ],
    );
  }
}
