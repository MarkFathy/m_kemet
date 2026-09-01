import 'package:flutter/material.dart';
import 'package:m_kemet/generated/l10n.dart';
import 'package:m_kemet/src/config/res/app_sizes.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:m_kemet/src/core/extensions/sized_box_helper.dart';
import 'package:m_kemet/src/core/widgets/app_scaffold.dart';
import 'package:m_kemet/src/core/widgets/buttons/custom_back_button.dart';
import 'package:m_kemet/src/features/notifications/presentation/widgets/notifications_empty_card.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      safeTop: true,
      safeBottom: true,
      backgroundColor: AppColors.pageBg,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: AppPadding.pW12,
          vertical: AppPadding.pH12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CustomBackButton(),
                12.szW,
                Text(
                  S.of(context).notificationsTitle,
                  style: getTextStyle().darkNavy.w700.s20,
                ),
              ],
            ),

            20.szH,

            const NotificationsEmptyCard(),

            20.szH,
          ],
        ),
      ),
    );
  }
}
