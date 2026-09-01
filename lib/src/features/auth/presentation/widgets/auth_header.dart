import 'package:flutter/material.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (trailing != null) ...[
          trailing!,
          20.szH,
        ],
        Text(
          title,
          style: getTextStyle().darkNavy.w700.s28,
        ),
        8.szH,
        Text(
          subtitle,
          style: getTextStyle().greyColor.w400.s14.copyWith(height: 1.5),
        ),
      ],
    );
  }
}
