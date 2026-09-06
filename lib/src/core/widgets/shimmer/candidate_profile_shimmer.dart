import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/shimmer/custom_shimmer.dart';

/// A rich, highly realistic shimmer skeleton widget that mirrors the candidate
/// and job-seeker profile screens with detailed containers, dividers, and card shapes.
class CandidateProfileShimmer extends StatelessWidget {
  final bool showHeader;
  final EdgeInsetsGeometry? padding;

  const CandidateProfileShimmer({
    super.key,
    this.showHeader = false,
    this.padding,
  });

  Widget _buildSectionHeader({required double titleWidth}) {
    return Row(
      children: [
        Container(
          width: 4.w,
          height: 16.h,
          decoration: BoxDecoration(
            color: AppColors.darkNavy.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        8.szW,
        ShimmerLine(width: titleWidth, height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: AppPadding.pW12,
            vertical: AppPadding.pH12,
          ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Optional Header Skeleton (Back Button + Title + Bookmark)
          if (showHeader) ...[
            CustomShimmer(
              child: Row(
                children: [
                  Container(
                    width: 38.w,
                    height: 38.w,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 16.sp,
                      color: AppColors.darkNavy.withValues(alpha: 0.4),
                    ),
                  ),
                  12.szW,
                  Expanded(
                    child: ShimmerLine(width: 140.w, height: 20),
                  ),
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.chipBg,
                    ),
                    child: Icon(
                      Icons.bookmark_border_rounded,
                      size: 22.sp,
                      color: AppColors.lightGrey,
                    ),
                  ),
                ],
              ),
            ),
            20.szH,
          ],

          // 1. Candidate Summary Card (Avatar 72.r, Verified Badge, Name, Profession, Experience)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomShimmer(
              child: Row(
                children: [
                  // Avatar with circular inner profile icon
                  Container(
                    width: 72.r,
                    height: 72.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.softBlueBg,
                      border: Border.all(
                        color: AppColors.borderGrey.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person_rounded,
                        size: 38.sp,
                        color: AppColors.skyBlue.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                  16.szW,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name + Verified Badge
                        Row(
                          children: [
                            ShimmerLine(width: 120.w, height: 18),
                            8.szW,
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.successBg.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 12.sp,
                                    color: AppColors.successGreen
                                        .withValues(alpha: 0.7),
                                  ),
                                  3.szW,
                                  ShimmerLine(
                                    width: 32.w,
                                    height: 8,
                                    color: AppColors.successGreen
                                        .withValues(alpha: 0.4),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        8.szH,
                        // Profession
                        ShimmerLine(width: 95.w, height: 14),
                        8.szH,
                        // Experience
                        Row(
                          children: [
                            Icon(
                              Icons.work_outline_rounded,
                              size: 13.sp,
                              color: AppColors.lightGrey,
                            ),
                            4.szW,
                            ShimmerLine(width: 70.w, height: 12),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          16.szH,

          // 2. Video Card Section (Title + Video Player Placeholder)
          CustomShimmer(
            child: _buildSectionHeader(titleWidth: 110.w),
          ),
          10.szH,
          Container(
            height: 150.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.softBlueBg.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
            ),
            child: CustomShimmer(
              child: Center(
                child: Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10.r,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.play_arrow_rounded,
                      size: 32.sp,
                      color: AppColors.darkNavy.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              ),
            ),
          ),

          16.szH,

          // 3. Bio Card Section
          CustomShimmer(
            child: _buildSectionHeader(titleWidth: 90.w),
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
            child: CustomShimmer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerLine(width: double.infinity, height: 12),
                  8.szH,
                  ShimmerLine(width: 250.w, height: 12),
                  8.szH,
                  ShimmerLine(width: 170.w, height: 12),
                ],
              ),
            ),
          ),

          16.szH,

          // 4. Qualifications / Details Table Card Section
          CustomShimmer(
            child: _buildSectionHeader(titleWidth: 120.w),
          ),
          10.szH,
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.borderGrey),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomShimmer(
              child: Column(
                children: [
                  for (int i = 0; i < 5; i++) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ShimmerCircle(
                                radius: 4.r,
                                color: AppColors.borderGrey,
                              ),
                              8.szW,
                              ShimmerLine(
                                width: 75.w + (i % 3) * 15.w,
                                height: 13,
                              ),
                            ],
                          ),
                          ShimmerLine(
                            width: 95.w - (i % 2) * 15.w,
                            height: 13,
                          ),
                        ],
                      ),
                    ),
                    if (i < 4)
                      Divider(height: 1.h, color: AppColors.dividerGrey),
                  ],
                ],
              ),
            ),
          ),

          24.szH,

          // 5. Action Button Placeholder (Request Contact)
          CustomShimmer(
            child: Container(
              width: double.infinity,
              height: 48.h,
              decoration: BoxDecoration(
                color: AppColors.darkNavy.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.darkNavy.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send_rounded,
                    size: 18.sp,
                    color: AppColors.darkNavy.withValues(alpha: 0.35),
                  ),
                  10.szW,
                  ShimmerLine(
                    width: 95.w,
                    height: 14,
                    color: AppColors.darkNavy.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ),

          20.szH,
        ],
      ),
    );
  }
}
