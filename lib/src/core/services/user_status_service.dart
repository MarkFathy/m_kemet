import 'dart:async';

import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/core/widgets/custom_snack_bar.dart';

class UserStatusService {
  bool _isHandlingLogout = false;

  UserStatusService();

  void initialize() {
    // API backend user status check or websocket heartbeat can be initialized here
  }

  Future<void> handleUserDisabledOrDeleted({required bool isDeleted}) async {
    if (_isHandlingLogout) return;
    _isHandlingLogout = true;

    await SessionManager.clearSession();
    unawaited(Go.offAllNamed(NamedRoutes.login));

    final context = Go.navigatorKey.currentContext;
    if (context != null && context.mounted) {
      final message = isDeleted
          ? 'Account has been deleted'
          : 'User account is disabled';
      CustomSnackBar.showError(context, message: message);
    }
  }

  void dispose() {}
}
