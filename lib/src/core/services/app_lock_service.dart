import 'dart:async';

import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:flutter/material.dart';

class AppLockService {
  final StreamController<bool> _lockStatusController = StreamController<bool>.broadcast();

  bool _isLocked = false;
  String _lockTitle = '';
  String _lockMessage = '';

  AppLockService();

  bool get isLocked => _isLocked;
  Stream<bool> get lockStatusStream => _lockStatusController.stream;

  String get lockTitle => _lockTitle;
  String get lockMessage => _lockMessage;

  Future<void> initialize() async {
    await fetchAndActivate();
  }

  Future<bool> fetchAndActivate() async {
    // API backend app lock check can be implemented here
    return false;
  }

  void updateLockStatus({required bool locked, String title = '', String message = ''}) {
    _lockTitle = title;
    _lockMessage = message;
    
    final previousState = _isLocked;
    _isLocked = locked;

    if (previousState != locked) {
      _lockStatusController.add(locked);
    }

    final context = Go.navigatorKey.currentContext;
    if (context == null) return;

    final currentRouteName = ModalRoute.of(context)?.settings.name;

    if (_isLocked) {
      // App lock screen not implemented — navigate to splash as fallback
      unawaited(Go.offAllNamed(NamedRoutes.splash));
    } else {
      if (currentRouteName == NamedRoutes.splash.routeName) {
        unawaited(Go.offAllNamed(NamedRoutes.splash));
      }
    }
  }

  void dispose() {
    unawaited(_lockStatusController.close());
  }
}
