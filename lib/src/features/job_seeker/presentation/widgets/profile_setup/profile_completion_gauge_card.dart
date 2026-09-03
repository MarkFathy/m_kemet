import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_button.dart';

class ProfileCompletionGaugeCard extends StatelessWidget {
  final double completionPercentage;
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onContinuePressed;

  const ProfileCompletionGaugeCard({
    super.key,
    this.completionPercentage = 0.40,
    this.isLoading = false,
    this.isEnabled = true,
    required this.onContinuePressed,
  });

  @override
  Widget build(BuildContext context) {
    final int percentInt = (completionPercentage * 100).toInt();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.softBlueBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('$percentInt%', style: getTextStyle().darkNavy.w700.s16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(S.of(context).profileStatusTitle, style: getTextStyle().darkNavy.w700.s18),
                  Text(S.of(context).documentsCompletion, style: getTextStyle().greyColor.w400.s12),
                ],
              ),
            ],
          ),
          10.szH,
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: completionPercentage,
              minHeight: 8.h,
              backgroundColor: AppColors.borderGrey,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.darkNavy),
            ),
          ),
          16.szH,
          CustomButton(
            text: S.of(context).continueAction,
            isLoading: isLoading,
            onPressed: (!isEnabled || isLoading) ? null : onContinuePressed,
            backgroundColor: isEnabled ? AppColors.darkNavy : const Color(0xFF94A3B8),
            textStyle: getTextStyle().whiteColor.w700.s16.copyWith(
              color: isEnabled ? Colors.white : Colors.white70,
            ),
          ),
          if (!isEnabled && !isLoading) ...[
            10.szH,
            Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14.sp,
                  color: AppColors.greyColor,
                ),
                6.szW,
                Expanded(
                  child: Text(
                    S.of(context).completeAllFieldsHint,
                    style: getTextStyle().greyColor.w500.s12,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
