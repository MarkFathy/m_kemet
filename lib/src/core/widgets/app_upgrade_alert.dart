import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:m_kemet/src/config/res/color_manager.dart';
import 'package:m_kemet/src/config/res/font_manager.dart';
import 'package:m_kemet/src/config/res/text_style_extensions.dart';
import 'package:upgrader/upgrader.dart';

class AppUpgradeAlert extends StatelessWidget {
  final Widget child;

  const AppUpgradeAlert({
    super.key,
    required this.child,
  });

  static final Upgrader _upgrader = Upgrader(
    debugDisplayAlways: false,
    debugDisplayOnce: kDebugMode,
    debugLogging: kDebugMode,
    durationUntilAlertAgain: const Duration(days: 1),
  );

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: DialogThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.steelBlue,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: FontManager.fontFamilyCairo,
            ),
          ),
        ),
      ),
      child: UpgradeAlert(
        upgrader: _upgrader,
        showIgnore: false,
        cupertinoButtonTextStyle: getTextStyle().steelBlue.w700,
        child: child,
      ),
    );
  }
}
