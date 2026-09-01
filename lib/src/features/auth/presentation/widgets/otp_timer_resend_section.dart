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
          ? AppProgressIndicator.small(
              size: 24.r,
              strokeWidth: 2.5,
              color: AppColors.darkNavy,
            )
          : secondsRemaining > 0
              ? Text(
                  '${S.of(context).resendIn}${_formatTimer(secondsRemaining)}',
                  style: getTextStyle().greyColor.w500.s14,
                )
              : TextButton(
                  onPressed: onResend,
                  child: Text(
                    S.of(context).resendCode,
                    style: getTextStyle().darkNavy.w700.s14,
                  ),
                ),
    );
  }
}
