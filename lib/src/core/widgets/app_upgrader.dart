import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:upgrader/upgrader.dart';

class CustomUpgraderMessages extends UpgraderMessages {
  final String langCode;

  CustomUpgraderMessages({required this.langCode}) : super(code: langCode);

  @override
  String? message(UpgraderMessage messageKey) {
    if (langCode == 'ar') {
      switch (messageKey) {
        case UpgraderMessage.title:
          return 'تحديث جديد متوفر 🚀';
        case UpgraderMessage.body:
          return 'يتوفر إصدار جديد من تطبيق أتوبيس كومبليت! يُرجى التحديث الآن للحصول على أحدث المميزات وأفضل تجربة لعب.';
        case UpgraderMessage.prompt:
          return 'هل ترغب في التحديث الآن؟';
        case UpgraderMessage.buttonTitleUpdate:
          return 'تحديث الآن';
        case UpgraderMessage.buttonTitleLater:
          return 'لاحقاً';
        case UpgraderMessage.buttonTitleIgnore:
          return 'تجاهل';
        case UpgraderMessage.releaseNotes:
          return 'ما الجديد:';
      }
    } else {
      switch (messageKey) {
        case UpgraderMessage.title:
          return 'New Update Available 🚀';
        case UpgraderMessage.body:
          return 'A new version of Autobus Complete is available! Please update now for the latest features and best gaming experience.';
        case UpgraderMessage.prompt:
          return 'Would you like to update now?';
        case UpgraderMessage.buttonTitleUpdate:
          return 'Update Now';
        case UpgraderMessage.buttonTitleLater:
          return 'Later';
        case UpgraderMessage.buttonTitleIgnore:
          return 'Ignore';
        case UpgraderMessage.releaseNotes:
          return 'What\'s New:';
      }
    }
  }
}

class AppUpgrader extends StatelessWidget {
  final Widget child;
  final String languageCode;
  final bool debugAlways;

  const AppUpgrader({
    required this.child,
    required this.languageCode,
    this.debugAlways = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) => UpgradeAlert(
        upgrader: Upgrader(
          messages: CustomUpgraderMessages(langCode: languageCode),
          debugLogging: kDebugMode,
          minAppVersion: '2.0.0', 
          debugDisplayAlways: debugAlways,
          durationUntilAlertAgain: const Duration(days: 1),
        ),
        child: child,
      );
}
