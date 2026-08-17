import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateDetailScreen extends StatelessWidget {
  final CandidateEntity candidate;

  const CandidateDetailScreen({
    super.key,
    required this.candidate,
  });

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: AppColors.pageBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW12,
          vertical: AppPadding.pH12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Back Button
            Row(
              children: [
                const CustomBackButton(),
                12.szW,
                Text(
                  S.of(context).candidateProfileTitle,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
              ],
            ),

            20.szH,

            // Candidate Summary Card
            Container(
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
            ),

            16.szH,

            // Video Container Mockup
            if (candidate.introVideoUrl.isNotEmpty) ...[
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
                  image: candidate.photoUrl.isNotEmpty
                      ? DecorationImage(
                          image: NetworkImage(candidate.photoUrl),
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
                  _buildDetailRow(S.of(context).passportStatusLabel, candidate.isValidPassport ? S.of(context).validPassport : S.of(context).invalidPassport),
                  _buildDetailRow(S.of(context).genderLabel, candidate.gender),
                  _buildDetailRow(S.of(context).ageLabel, '${candidate.age} سنة'),
                  _buildDetailRow(S.of(context).expectedSalaryLabel, candidate.expectedSalary, isLast: true),
                ],
              ),
            ),

            24.szH,

            // Primary Action Buttons Row
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      CustomSnackBar.showSuccess(
                        context,
                        message: S.of(context).contactRequestSuccess,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkNavy,
                      foregroundColor: AppColors.whiteColor,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      S.of(context).requestContact,
                      style: getTextStyle().whiteColor.w700.s14,
                    ),
                  ),
                ),
                12.szW,
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      CustomSnackBar.showInfo(
                        context,
                        message: S.of(context).cvDownloadInfo,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.darkNavy, width: 1.5.w),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Icon(
                      Icons.download_rounded,
                      color: AppColors.darkNavy,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),

            20.szH,
          ],
        ),
      ),
    );
  }

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
}
