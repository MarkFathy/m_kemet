import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

import 'package:m_kemet/src/config/res/color_manager.dart';

class FloatingNavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;

  const FloatingNavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
  });
}

class FloatingBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<FloatingNavItem> items;
  final bool isDarkTheme;

  const FloatingBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    this.isDarkTheme = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isDarkTheme ? AppColors.darkNavy : Colors.white;
    final borderColor = isDarkTheme ? Colors.white.withValues(alpha: 0.15) : const Color(0xFFE2E8F0);
    final selectedPillColor = isDarkTheme ? const Color(0xFF134E7B) : const Color(0xFFEFF6FF);
    final selectedTextColor = isDarkTheme ? AppColors.skyBlue : AppColors.darkNavy;
    final unselectedIconColor = isDarkTheme ? const Color(0xFF94A3B8) : AppColors.greyColor;

    return Container(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: [
            BoxShadow(
              color: isDarkTheme
                  ? AppColors.darkNavy.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.08),
              blurRadius: 18.r,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: borderColor,
            width: 1.w,
          ),
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(items.length, (index) {
          final isSelected = currentIndex == index;
          final item = items[index];

          return GestureDetector(
            onTap: () => onTap(index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.fastOutSlowIn,
              padding: EdgeInsets.symmetric(
                horizontal: isSelected ? 16.w : 12.w,
                vertical: 10.h,
              ),
              decoration: BoxDecoration(
                color: isSelected ? selectedPillColor : Colors.transparent,
                borderRadius: BorderRadius.circular(20.r),
                border: isSelected
                    ? Border.all(
                        color: selectedTextColor.withValues(alpha: 0.25),
                        width: 1.w,
                      )
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                    size: 20.sp,
                    color: isSelected ? selectedTextColor : unselectedIconColor,
                  ),
                  if (isSelected) ...[
                    8.szW,
                    Text(
                      item.label,
                      style: getTextStyle().w700.s13.copyWith(
                            color: selectedTextColor,
                          ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }),
      ),
    ),
  );
}
}
