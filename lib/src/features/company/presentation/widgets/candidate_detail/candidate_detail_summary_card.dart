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
          CircleAvatar(
            radius: 36.r,
            backgroundColor: AppColors.softBlueBg,
            backgroundImage: candidate.photoUrl.isNotEmpty
                ? NetworkImage(candidate.photoUrl)
                : null,
            child: candidate.photoUrl.isEmpty
                ? Icon(Icons.person_rounded, size: 36.sp, color: AppColors.darkNavy)
                : null,
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
                      ),
                    ),
                    6.szW,
                    if (candidate.isVerified)
                      Icon(Icons.verified_rounded, size: 16.sp, color: AppColors.successGreen),
                  ],
                ),
                4.szH,
                Text(
                  candidate.profession,
                  style: getTextStyle().steelBlue.w600.s14,
                ),
                6.szH,
                Text(
                  '${S.of(context).experienceLabel}: ${candidate.experienceYears}',
                  style: getTextStyle().greyColor.w500.s13,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
