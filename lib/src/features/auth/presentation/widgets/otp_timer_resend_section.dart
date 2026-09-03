import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/widgets/app_progress_indicator.dart';

class OtpTimerResendSection extends StatelessWidget {
  final bool isLoading;
  final int secondsRemaining;
  final VoidCallback onResend;

  const OtpTimerResendSection({
    super.key,
    required this.isLoading,
    required this.secondsRemaining,
    required this.onResend,
  });

  String _formatTimer(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 8.h),
              child: AppProgressIndicator.small(
                size: 22.r,
                strokeWidth: 2.5,
                color: AppColors.darkNavy,
              ),
            )
          : secondsRemaining > 0
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.of(context).resendIn,
                      style: getTextStyle().greyColor.w400.s14,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatTimer(secondsRemaining),
                      style: getTextStyle().darkNavy.w700.s14,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لم تصلك الرسالة؟',
                      style: getTextStyle().greyColor.w400.s14,
                    ),
                    TextButton(
                      onPressed: onResend,
                      child: Text(
                        S.of(context).resendCode,
                        style: getTextStyle().darkNavy.w700.s14,
                      ),
                    ),
                  ],
                ),
    );
  }
}
