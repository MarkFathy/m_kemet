import 'package:flutter/material.dart';
import 'package:m_kemet/app.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

