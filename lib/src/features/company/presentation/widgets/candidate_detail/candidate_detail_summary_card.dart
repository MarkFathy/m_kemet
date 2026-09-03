import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateDetailSummaryCard extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateDetailSummaryCard({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        children: [
          ClipOval(
            child: Container(
              width: 72.r,
              height: 72.r,
              color: AppColors.softBlueBg,
              child: candidate.photoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: candidate.photoUrl,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: Icon(Icons.person_rounded, size: 36.sp, color: AppColors.darkNavy),
                      ),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.person_rounded, size: 36.sp, color: AppColors.darkNavy),
                      ),
                    )
                  : Center(
                      child: Icon(Icons.person_rounded, size: 36.sp, color: AppColors.darkNavy),
                    ),
            ),
          ),
          16.szW,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        candidate.name,
                        style: getTextStyle().darkNavy.w700.s18,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (candidate.isVerified) ...[
                      6.szW,
                      Icon(Icons.verified_rounded, size: 16.sp, color: AppColors.successGreen),
                    ],
                  ],
                ),
                4.szH,
                Text(
                  candidate.profession,
                  style: getTextStyle().steelBlue.w600.s14,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (candidate.experienceYears.isNotEmpty) ...[
                  6.szH,
                  Text(
                    '${S.of(context).experienceLabel}: ${candidate.experienceYears}',
                    style: getTextStyle().greyColor.w500.s13,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
