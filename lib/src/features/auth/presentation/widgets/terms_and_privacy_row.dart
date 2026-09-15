import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';

class TermsAndPrivacyRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsAndPrivacyRow({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          activeColor: AppColors.darkNavy,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
          onChanged: onChanged,
        ),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final result = await Go.toNamed(NamedRoutes.termsAndConditions);
              if (result == true) {
                onChanged(true);
              }
            },
            child: Text.rich(
              TextSpan(
                text: S.of(context).agreeToTermsPrefix,
                style: getTextStyle().greyColor.w400.s13,
                children: [
                  TextSpan(
                    text: S.of(context).termsAndConditions,
                    style: getTextStyle().darkNavy.w700.s13,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
