import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/features/job_seeker/presentation/cubit/job_seeker_profile_state.dart';

class IdentityDocumentTypeSelector extends StatelessWidget {
  final IdentityDocumentChoice selectedChoice;
  final ValueChanged<IdentityDocumentChoice> onChoiceChanged;

  const IdentityDocumentTypeSelector({
    super.key,
    required this.selectedChoice,
    required this.onChoiceChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: AppColors.borderGrey,
          width: 1.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: AppColors.softBlueBg,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.verified_user_outlined,
                  size: 18.sp,
                  color: AppColors.darkNavy,
                ),
              ),
              8.szW,
              Expanded(
                child: Text(
                  S.of(context).identityDocumentSectionTitle,
                  style: getTextStyle().darkNavy.w700.s14,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              8.szW,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: AppColors.softBlueBg,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Text(
                  S.of(context).atLeastOneRequired,
                  style: getTextStyle().darkNavy.w600.s11,
                ),
              ),
            ],
          ),
          12.szH,
          // Segmented Choice Buttons
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppColors.pageBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                _buildOption(
                  context,
                  title: S.of(context).choiceNationalId,
                  icon: Icons.credit_card_rounded,
                  choice: IdentityDocumentChoice.nationalId,
                ),
                4.szW,
                _buildOption(
                  context,
                  title: S.of(context).choicePassport,
                  icon: Icons.badge_outlined,
                  choice: IdentityDocumentChoice.passport,
                ),
                4.szW,
                _buildOption(
                  context,
                  title: S.of(context).choiceBoth,
                  icon: Icons.done_all_rounded,
                  choice: IdentityDocumentChoice.both,
                ),
              ],
            ),
          ),
          8.szH,
          // Contextual helper hint text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              _getHelperMessage(context),
              key: ValueKey(selectedChoice),
              style: getTextStyle().greyColor.w400.s11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required IdentityDocumentChoice choice,
  }) {
    final isSelected = selectedChoice == choice;

    return Expanded(
      child: GestureDetector(
        onTap: () => onChoiceChanged(choice),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.darkNavy : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.darkNavy.withValues(alpha: 0.15),
                      blurRadius: 8.r,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14.sp,
                color: isSelected ? AppColors.skyBlue : AppColors.greyColor,
              ),
              4.szW,
              Flexible(
                child: Text(
                  title,
                  style: isSelected
                      ? getTextStyle().whiteColor.w700.s11
                      : getTextStyle().darkNavy.w600.s11,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getHelperMessage(BuildContext context) {
    switch (selectedChoice) {
      case IdentityDocumentChoice.nationalId:
        return S.of(context).nationalIdHelperMsg;
      case IdentityDocumentChoice.passport:
        return S.of(context).passportHelperMsg;
      case IdentityDocumentChoice.both:
        return S.of(context).bothIdentityHelperMsg;
    }
  }
}
