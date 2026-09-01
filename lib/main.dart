import 'package:flutter/material.dart';
import 'package:m_kemet/app.dart';
import 'package:m_kemet/src/config/themes/status_bar_and_orientations_theme.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStatusBarAndOrientationsTheme.setStyle();
  await init();
  runApp(const MyApp());
}


