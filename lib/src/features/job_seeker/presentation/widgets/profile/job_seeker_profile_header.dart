import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/features/notifications/presentation/widgets/notification_bell_button.dart';

class JobSeekerProfileHeader extends StatelessWidget {
  const JobSeekerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          S.of(context).candidateProfileTitle,
          style: getTextStyle().darkNavy.w700.s22,
        ),
        const NotificationBellButton(),
      ],
    );
  }
}
