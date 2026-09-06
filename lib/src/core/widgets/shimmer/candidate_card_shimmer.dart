import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/shimmer/custom_shimmer.dart';

/// A rich, highly realistic shimmer skeleton card that precisely matches
/// the structure, styling, and container details of [CandidateCard].
class CandidateCardShimmer extends StatelessWidget {
  const CandidateCardShimmer({super.key});

  Widget _buildShimmerChip({
    required IconData icon,
    required double textWidth,
    required Color bgColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.borderGrey.withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: AppColors.steelBlue.withValues(alpha: 0.5),
          ),
          6.szW,
          ShimmerLine(
            width: textWidth,
            height: 10,
            borderRadius: 5.r,
            color: AppColors.borderGrey.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }

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
      child: CustomShimmer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Avatar, Name & Verification Badge, Profession & Bookmark
            Row(
              children: [
                // Avatar with soft inner tint & icon outline
                Container(
                  width: 52.r,
                  height: 52.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.softBlueBg,
                    border: Border.all(
                      color: AppColors.borderGrey.withValues(alpha: 0.6),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      size: 28.sp,
                      color: AppColors.skyBlue.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                12.szW,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name Line + Verification Badge Pill
                      Row(
                        children: [
                          ShimmerLine(width: 110.w, height: 16),
                          6.szW,
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
                                  borderRadius: 4.r,
                                  color: AppColors.successGreen
                                      .withValues(alpha: 0.4),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      6.szH,
                      // Profession Line
                      ShimmerLine(width: 85.w, height: 13),
                      6.szH,
                      // Experience Line with mini work icon
                      Row(
                        children: [
                          Icon(
                            Icons.work_outline_rounded,
                            size: 12.sp,
                            color: AppColors.lightGrey,
                          ),
                          4.szW,
                          ShimmerLine(width: 60.w, height: 10),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bookmark Action Button Placeholder
                Container(
                  padding: EdgeInsets.all(6.r),
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

            14.szH,
            Divider(height: 1.h, color: AppColors.dividerGrey),
            12.szH,

            // Row 2: Location, Destination & Passport Chips
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                _buildShimmerChip(
                  icon: Icons.location_on_outlined,
                  textWidth: 85.w,
                  bgColor: AppColors.chipBg,
                ),
                _buildShimmerChip(
                  icon: Icons.flight_takeoff_rounded,
                  textWidth: 80.w,
                  bgColor: AppColors.softBlueBg,
                ),
                _buildShimmerChip(
                  icon: Icons.badge_outlined,
                  textWidth: 70.w,
                  bgColor: AppColors.successBg.withValues(alpha: 0.5),
                ),
              ],
            ),

            16.szH,

            // Row 3: Action Button Placeholder (matching ElevatedButton layout)
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 10.h),
              decoration: BoxDecoration(
                color: AppColors.darkNavy.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(
                  color: AppColors.darkNavy.withValues(alpha: 0.12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerLine(
                    width: 85.w,
                    height: 13,
                    borderRadius: 6.r,
                    color: AppColors.darkNavy.withValues(alpha: 0.22),
                  ),
                  8.szW,
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 16.sp,
                    color: AppColors.darkNavy.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A list of shimmer candidate cards with configurable count.
class CandidateListShimmer extends StatelessWidget {
  final int itemCount;
  final bool shrinkWrap;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;

  const CandidateListShimmer({
    super.key,
    this.itemCount = 4,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding ?? EdgeInsets.zero,
      itemCount: itemCount,
      separatorBuilder: (context, index) => 14.szH,
      itemBuilder: (context, index) => const CandidateCardShimmer(),
    );
  }
}
