import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class FilterOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isExpanded;

  const FilterOptionChip({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    final chip = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        alignment: isExpanded ? Alignment.center : null,
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 6.w : 14.w,
          vertical: isExpanded ? 10.h : 8.h,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.darkNavy : AppColors.chipBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.darkNavy : AppColors.borderGrey,
          ),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: getTextStyle().s13.copyWith(
                color: isSelected ? AppColors.whiteColor : AppColors.darkNavy,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
        ),
      ),
    );

    if (isExpanded) {
      return Expanded(child: chip);
    }
    return chip;
  }
}
