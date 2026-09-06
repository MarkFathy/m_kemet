import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class UserTypeOptionCard extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final Widget iconWidget;
  final Color iconContainerColor;
  final String title;
  final String description;
  final List<String> features;
  final List<IconData> featureIcons;

  const UserTypeOptionCard({
    required this.isSelected,
    required this.onTap,
    required this.iconWidget,
    required this.iconContainerColor,
    required this.title,
    required this.description,
    required this.features,
    required this.featureIcons,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(AppCircular.r16),
          border: Border.all(
            color: isSelected ? AppColors.darkNavy : AppColors.lightGrey.withValues(alpha: 0.6),
            width: isSelected ? 2.w : 1.w,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.darkNavy.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.03),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppColors.darkNavy : AppColors.lightGrey,
                      width: isSelected ? 5.5.w : 1.5.w,
                    ),
                  ),
                ),

                // Icon Box
                Container(
                  width: 48.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                    color: iconContainerColor,
                    borderRadius: BorderRadius.circular(AppCircular.r12),
                  ),
                  child: Center(child: iconWidget),
                ),

                20.szW,
              ],
            ),

            10.szH,

            // Title
            Text(
              title,
              textAlign: TextAlign.center,
              style: getTextStyle().darkNavy.w700.s18,
            ),

            6.szH,

            // Description
            Text(
              description,
              textAlign: TextAlign.center,
              style: getTextStyle().greyColor.w400.s13.copyWith(height: 1.4),
            ),

            12.szH,

            const Divider(color: AppColors.dividerGrey, thickness: 1),

            8.szH,

            // Features List
            Column(
              children: List.generate(features.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: index == features.length - 1 ? 0 : AppPadding.pH6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        features[index],
                        style: getTextStyle().darkNavy.w400.s12,
                      ),
                      6.szW,
                      Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          color: iconContainerColor.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Icon(
                          featureIcons[index],
                          size: 13.sp,
                          color: AppColors.darkNavy,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
