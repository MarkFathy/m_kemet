import 'dart:async';

import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String channelKey = 'basic_channel';

  /// Initialize Awesome Notifications
  Future<void> initialize() async {
    // 1. Initialize Awesome Notifications Channels
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelKey: channelKey,
          channelName: 'General Notifications',
          channelDescription: 'Notification channel for app updates and alerts',
          defaultColor: const Color(0xFFF9A825),
          ledColor: Colors.white,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          playSound: true,
          enableVibration: true,
        ),
      ],
      debug: kDebugMode,
    );

    // 2. Request Notification Permissions
    await requestPermission();

    // 3. Register Action Received Listener
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
    );
  }

  /// Request permissions for local notifications
  Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  static const String notificationSettingKey = 'user_notifications_enabled';

  /// Check if notifications are enabled by user preference
  bool isNotificationsEnabled() {
    final val = CacheStorage.read(notificationSettingKey);
    if (val is bool) return val;
    return true;
  }

  /// Enable or disable notifications
  Future<void> setNotificationsEnabled({required bool enable}) async {
    await CacheStorage.write(notificationSettingKey, enable);
    if (enable) {
      await requestPermission();
    }
  }

  /// Trigger a local custom notification programmatically
  Future<void> showLocalNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    if (!isNotificationsEnabled()) return;
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: DateTime.now().millisecondsSinceEpoch.remainder(100000),
        channelKey: channelKey,
        title: title,
        body: body,
        payload: payload,
      ),
    );
  }

  bool isSplashActive = false;
  NamedRoutes? _pendingNotificationRoute;

  @pragma('vm:entry-point')
  static Future<void> _onActionReceivedMethod(ReceivedAction receivedAction) async {
    final payload = receivedAction.payload;
    if (payload != null) {
      _instance._handleNotificationClick(payload);
    }
  }

  /// Handle notification tap action based on payload 'type'
  void _handleNotificationClick(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    debugPrint('[NotificationService] Notification tapped with type: $type, data: $data');

    if (type == 'complaint_reply' || type == 'complaint' || type == 'complaints') {
      _pendingNotificationRoute = NamedRoutes.complaints;
      consumePendingNotificationRoute();
    }
  }

  /// Consume pending notification route after splash animation
  void consumePendingNotificationRoute() {
    final route = _pendingNotificationRoute;
    if (route == null || isSplashActive) return;

    final navState = Go.navigatorKey.currentState;
    if (navState != null) {
      _pendingNotificationRoute = null;
      unawaited(Go.toNamed(route));
    }
  }
}
