import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:pinput/pinput.dart';

/// A customizable and styled 6-digit (or N-digit) PIN / OTP input widget
class CustomPinInput extends StatelessWidget {
  final int length;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String)? onCompleted;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool autofocus;
  final bool readOnly;
  final MainAxisAlignment mainAxisAlignment;

  const CustomPinInput({
    super.key,
    this.length = 6,
    this.controller,
    this.focusNode,
    this.onCompleted,
    this.onChanged,
    this.validator,
    this.errorText,
    this.autofocus = true,
    this.readOnly = false,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  });

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: AppColors.darkNavy),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5.w),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6.r, offset: const Offset(0, 2)),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: AppColors.darkNavy, width: 2.w),
        boxShadow: [
          BoxShadow(color: AppColors.darkNavy.withValues(alpha: 0.15), blurRadius: 8.r, spreadRadius: 1.r),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Colors.white,
        border: Border.all(color: AppColors.darkNavy, width: 1.5.w),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        border: Border.all(color: Colors.red, width: 2.w),
        boxShadow: [BoxShadow(color: Colors.red.withValues(alpha: 0.15), blurRadius: 8.r)],
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        length: length,
        controller: controller,
        focusNode: focusNode,
        autofocus: autofocus,
        readOnly: readOnly,
        mainAxisAlignment: mainAxisAlignment,
        defaultPinTheme: defaultPinTheme,
        focusedPinTheme: focusedPinTheme,
        submittedPinTheme: submittedPinTheme,
        errorPinTheme: errorPinTheme,
        validator: validator,
        errorText: errorText,
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 12.h),
              width: 2.w,
              height: 22.h,
              color: AppColors.darkNavy,
            ),
          ],
        ),
        onChanged: onChanged,
        onCompleted: onCompleted,
      ),
    );
  }
}
