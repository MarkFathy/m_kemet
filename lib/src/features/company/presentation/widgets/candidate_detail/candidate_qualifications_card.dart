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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 130.w),
                child: Text(
                  title,
                  style: getTextStyle().greyColor.w500.s14,
                ),
              ),
              12.szW,
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: getTextStyle().darkNavy.w700.s14,
                ),
              ),
            ],
          ),
        ),
        if (!isLast) Divider(height: 1.h, color: AppColors.dividerGrey),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <MapEntry<String, String>>[
      if (candidate.currentCountry.isNotEmpty)
        MapEntry(
          S.of(context).currentLocation,
          candidate.currentCountryFlag.isNotEmpty
              ? '${candidate.currentCountryFlag} ${candidate.currentCountry}'
              : candidate.currentCountry,
        ),
      if (candidate.targetCountries.isNotEmpty)
        MapEntry(S.of(context).requestedDestination, candidate.targetCountries),
      if (candidate.passportStatusLabel.isNotEmpty || candidate.isValidPassport)
        MapEntry(
          S.of(context).passportStatusLabel,
          candidate.passportStatusLabel.isNotEmpty
              ? candidate.passportStatusLabel
              : (candidate.isValidPassport
                  ? S.of(context).validPassport
                  : S.of(context).invalidPassport),
        ),
      if (candidate.gender.isNotEmpty)
        MapEntry(S.of(context).genderLabel, candidate.gender),
      if (candidate.age > 0)
        MapEntry(S.of(context).ageLabel, '${candidate.age} سنة'),
      if (candidate.expectedSalary.isNotEmpty)
        MapEntry(S.of(context).expectedSalaryLabel, candidate.expectedSalary),
    ];

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
        if (rows.isNotEmpty) ...[
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
              children: List.generate(rows.length, (index) {
                final row = rows[index];
                return _buildDetailRow(
                  row.key,
                  row.value,
                  isLast: index == rows.length - 1,
                );
              }),
            ),
          ),
        ],
      ],
    );
  }
}
