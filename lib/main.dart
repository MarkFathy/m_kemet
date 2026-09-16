import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:m_kemet/app.dart';
import 'package:m_kemet/firebase_options.dart';
import 'package:m_kemet/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:m_kemet/src/core/services/notification_service.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStatusBarAndOrientationsTheme.setStyle();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await init();
  await sl<NotificationService>().initialize();
  runApp(const MyApp());
}
