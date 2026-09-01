import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/helpers/validators.dart';
import 'package:m_kemet/src/core/widgets/text_fields/default_text_field.dart';

class CandidateRegisterFields extends StatelessWidget {
  final TextEditingController countryController;
  final TextEditingController dobController;
  final TextEditingController genderController;
  final VoidCallback onCountryTap;
  final VoidCallback onDobTap;
  final VoidCallback onGenderTap;

  const CandidateRegisterFields({
    super.key,
    required this.countryController,
    required this.dobController,
    required this.genderController,
    required this.onCountryTap,
    required this.onDobTap,
    required this.onGenderTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.szH,

        // Current Country
        DefaultTextField(
          controller: countryController,
          label: S.of(context).currentCountryLabel,
          hint: S.of(context).currentCountryHint,
          readOnly: true,
          onTap: onCountryTap,
          prefixIcon: Icon(Icons.public_rounded, color: AppColors.greyColor, size: 20.sp),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          validator: (value) => Validators.validateEmpty(
            value,
            message: S.of(context).currentCountryHint,
          ),
        ),

        16.szH,

        // Date of Birth
        DefaultTextField(
          controller: dobController,
          label: S.of(context).dateOfBirthLabel,
          hint: S.of(context).dateOfBirthHint,
          readOnly: true,
          onTap: onDobTap,
          prefixIcon: Icon(Icons.calendar_today_rounded, color: AppColors.greyColor, size: 20.sp),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          validator: (value) => Validators.validateEmpty(
            value,
            message: S.of(context).dateOfBirthHint,
          ),
        ),

        16.szH,

        // Gender Selection
        DefaultTextField(
          controller: genderController,
          label: S.of(context).genderLabel,
          hint: S.of(context).genderHint,
          readOnly: true,
          onTap: onGenderTap,
          prefixIcon: Icon(Icons.wc_rounded, color: AppColors.greyColor, size: 20.sp),
          suffixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.darkNavy, size: 24.sp),
          validator: (value) => Validators.validateEmpty(
            value,
            message: S.of(context).genderHint,
          ),
        ),
      ],
    );
  }
}
