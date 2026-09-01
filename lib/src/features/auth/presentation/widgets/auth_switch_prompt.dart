import 'package:flutter/material.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';

class AuthSwitchPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onAction;

  const AuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          promptText,
          style: getTextStyle().greyColor.w400.s14,
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: getTextStyle().darkNavy.w700.s14,
          ),
        ),
      ],
    );
  }
}
