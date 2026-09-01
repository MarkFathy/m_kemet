import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateQualificationsCard extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateQualificationsCard({
    super.key,
    required this.candidate,
  });

  Widget _buildDetailRow(String title, String value, {bool isLast = false}) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: getTextStyle().greyColor.w500.s14),
              Text(value, style: getTextStyle().darkNavy.w700.s14),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1.h, color: AppColors.dividerGrey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bio Section Card
        if (candidate.bio.isNotEmpty) ...[
          Text(
            S.of(context).candidateBioTitle,
            style: getTextStyle().darkNavy.w700.s16,
          ),
          10.szH,
          Container(
            padding: EdgeInsets.all(16.w),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: Text(
              candidate.bio,
              style: getTextStyle().darkNavy.w400.s14.copyWith(height: 1.6),
            ),
          ),
          20.szH,
        ],

        // Detailed Qualifications Table
        Text(
          S.of(context).candidateDetailsTitle,
          style: getTextStyle().darkNavy.w700.s16,
        ),
        10.szH,
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderGrey),
          ),
          child: Column(
            children: [
              _buildDetailRow(S.of(context).currentLocation, candidate.currentCountry),
              _buildDetailRow(S.of(context).requestedDestination, candidate.targetCountries),
              _buildDetailRow(
                S.of(context).passportStatusLabel,
                candidate.isValidPassport ? S.of(context).validPassport : S.of(context).invalidPassport,
              ),
              _buildDetailRow(S.of(context).genderLabel, candidate.gender),
              _buildDetailRow(S.of(context).ageLabel, '${candidate.age} سنة'),
              _buildDetailRow(S.of(context).expectedSalaryLabel, candidate.expectedSalary, isLast: true),
            ],
          ),
        ),
      ],
    );
  }
}
