import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class JobSeekerProfileHeader extends StatelessWidget {
  const JobSeekerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        S.of(context).candidateProfileTitle,
        style: getTextStyle().darkNavy.w700.s22,
      ),
    );
  }
}
