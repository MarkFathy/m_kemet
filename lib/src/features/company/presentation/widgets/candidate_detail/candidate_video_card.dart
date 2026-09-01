import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class CandidateVideoCard extends StatelessWidget {
  final String videoUrl;
  final String photoUrl;

  const CandidateVideoCard({
    super.key,
    required this.videoUrl,
    required this.photoUrl,
  });

  @override
  Widget build(BuildContext context) {
    if (videoUrl.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          S.of(context).candidateVideoTitle,
          style: getTextStyle().darkNavy.w700.s16,
        ),
        10.szH,
        Container(
          height: 140.h,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.midnightNavy,
            borderRadius: BorderRadius.circular(16.r),
            image: photoUrl.isNotEmpty
                ? DecorationImage(
                    image: NetworkImage(photoUrl),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.5),
                      BlendMode.darken,
                    ),
                  )
                : null,
          ),
          child: Center(
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.darkNavy.withValues(alpha: 0.85),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.whiteColor,
                size: 36.sp,
              ),
            ),
          ),
        ),
        20.szH,
      ],
    );
  }
}
