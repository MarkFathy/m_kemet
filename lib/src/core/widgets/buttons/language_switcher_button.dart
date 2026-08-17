import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/app_cubit/app_cubit.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class LanguageSwitcherButton extends StatelessWidget {
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;

  const LanguageSwitcherButton({
    super.key,
    this.padding,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<AppCubit>().state.locale.languageCode == 'ar';

    return InkWell(
      onTap: () {
        context.read<AppCubit>().toggleLanguage();
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: padding ?? EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: backgroundColor ?? const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.language_rounded,
              color: AppColors.darkNavy,
              size: 18.sp,
            ),
            6.szW,
            Text(
              isArabic ? 'EN' : 'عربي',
              style: getTextStyle().darkNavy.bold.s14,
            ),
          ],
        ),
      ),
    );
  }
}
