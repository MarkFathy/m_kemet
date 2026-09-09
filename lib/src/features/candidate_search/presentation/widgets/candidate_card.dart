import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/info_chip.dart';
import 'package:m_kemet/src/features/company/domain/entities/candidate_entity.dart';

class CandidateCard extends StatelessWidget {
  final CandidateEntity candidate;
  final VoidCallback onViewProfile;
  final VoidCallback onToggleSave;

  const CandidateCard({
    super.key,
    required this.candidate,
    required this.onViewProfile,
    required this.onToggleSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
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
          // Row 1: Avatar, Name, Verification Badge & Save Toggle Button
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 52.r,
                  height: 52.r,
                  color: AppColors.softBlueBg,
                  child: candidate.photoUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: candidate.photoUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                            child: Icon(Icons.person_rounded, size: 28.sp, color: AppColors.darkNavy),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(Icons.person_rounded, size: 28.sp, color: AppColors.darkNavy),
                          ),
                        )
                      : Center(
                          child: Icon(Icons.person_rounded, size: 28.sp, color: AppColors.darkNavy),
                        ),
                ),
              ),
              12.szW,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            candidate.name,
                            style: getTextStyle().darkNavy.w700.s16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        6.szW,
                        if (candidate.isVerified)
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                            decoration: BoxDecoration(
                              color: AppColors.successBg,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.verified_rounded, size: 12.sp, color: AppColors.successGreen),
                                2.szW,
                                Text(
                                  candidate.verificationBadge.isNotEmpty
                                      ? candidate.verificationBadge
                                      : S.of(context).verifiedBadge,
                                  style: getTextStyle().w700.s10.copyWith(color: AppColors.successGreen),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    4.szH,
                    Text(
                      candidate.profession,
                      style: getTextStyle().steelBlue.w600.s14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (candidate.experienceYears.isNotEmpty && candidate.experienceYears != '0') ...[
                      4.szH,
                      Text(
                        '${S.of(context).experienceLabel}: ${candidate.experienceYears}',
                        style: getTextStyle().greyColor.w500.s12,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                onPressed: onToggleSave,
                icon: Icon(
                  candidate.isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
                  color: candidate.isSaved ? AppColors.warningAmber : AppColors.greyColor,
                  size: 24.sp,
                ),
              ),
            ],
          ),

          14.szH,
          Divider(height: 1.h, color: AppColors.dividerGrey),
          12.szH,

          // Row 2: Passport Validity & Location Info Chips
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              if (candidate.currentCountry.isNotEmpty)
                InfoChip(
                  icon: Icons.location_on_outlined,
                  label: '${S.of(context).currentLocation}: ${candidate.currentCountryFlag.isNotEmpty ? "${candidate.currentCountryFlag} " : ""}${candidate.currentCountry}',
                  bgColor: AppColors.chipBg,
                  textColor: AppColors.darkNavy,
                ),
              if (candidate.targetCountries.isNotEmpty)
                InfoChip(
                  icon: Icons.flight_takeoff_rounded,
                  label: '${S.of(context).requestedDestination}: ${candidate.targetCountries}',
                  bgColor: AppColors.softBlueBg,
                  textColor: AppColors.darkNavy,
                ),
              InfoChip(
                icon: Icons.badge_outlined,
                label: candidate.passportStatusLabel.isNotEmpty
                    ? candidate.passportStatusLabel
                    : (candidate.isValidPassport
                        ? S.of(context).validPassport
                        : S.of(context).invalidPassport),
                bgColor: candidate.isValidPassport ? AppColors.successBg : AppColors.errorBg,
                textColor: candidate.isValidPassport ? AppColors.successGreen : AppColors.errorRed,
              ),
            ],
          ),

          16.szH,

          // Row 3: Action Button - View Profile
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onViewProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkNavy,
                foregroundColor: AppColors.whiteColor,
                elevation: 0,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.of(context).viewCandidateProfile,
                    style: getTextStyle().whiteColor.w700.s14,
                  ),
                  6.szW,
                  Icon(Icons.arrow_forward_rounded, size: 16.sp, color: AppColors.whiteColor),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
