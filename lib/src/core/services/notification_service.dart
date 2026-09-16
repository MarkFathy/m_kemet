import 'dart:async';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_kemet/firebase_options.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';

/// Top-level background message handler for FCM
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  debugPrint(
    '[NotificationService] Background message received: ${message.messageId}',
  );
}

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static const String channelKey = 'basic_channel';
  static const String notificationSettingKey = 'user_notifications_enabled';

  bool isSplashActive = false;
  NamedRoutes? _pendingNotificationRoute;

  /// Initialize Awesome Notifications & Firebase Cloud Messaging
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

    // 2. Request Local Notification Permissions
    await requestPermission();

    // 3. Register Action Received Listener
    await AwesomeNotifications().setListeners(
      onActionReceivedMethod: _onActionReceivedMethod,
    );

    // 4. Initialize Firebase Messaging
    await _initFirebaseMessaging();
  }

  /// Initialize Firebase Messaging handlers and listeners
  Future<void> _initFirebaseMessaging() async {
    try {
      final messaging = FirebaseMessaging.instance;

      // Request notification permissions for iOS / Android 13+
      final settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
      debugPrint(
        '[NotificationService] FCM AuthorizationStatus: ${settings.authorizationStatus}',
      );

      // Foreground notification presentation options (iOS)
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Set background handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Foreground message listener: display using AwesomeNotifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        debugPrint(
          '[NotificationService] Foreground message received: ${message.data}',
        );
        final notification = message.notification;
        if (notification != null) {
          showLocalNotification(
            title: notification.title ?? '',
            body: notification.body ?? '',
            payload: message.data.map(
              (key, value) => MapEntry(key, value.toString()),
            ),
          );
        }
      });

      // Handle message when app opened from background state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint(
          '[NotificationService] App opened from background via message: ${message.data}',
        );
        _handleNotificationClick(message.data);
      });

      // Handle message when app opened from terminated state
      final initialMessage = await messaging.getInitialMessage();
      if (initialMessage != null) {
        debugPrint(
          '[NotificationService] App launched from terminated state via message: ${initialMessage.data}',
        );
        _handleNotificationClick(initialMessage.data);
      }

      // Listen for token refresh
      messaging.onTokenRefresh.listen((newToken) {
        debugPrint('[NotificationService] FCM Token refreshed: $newToken');
      });

      // Fetch initial device token
      final token = await getDeviceToken();
      debugPrint('[NotificationService] Current FCM Token: $token');
    } catch (e) {
      debugPrint('[NotificationService] FCM init error: $e');
    }
  }

  /// Get the current FCM Device Token
  Future<String?> getDeviceToken() async {
    try {
      return await FirebaseMessaging.instance.getToken();
    } catch (e) {
      debugPrint('[NotificationService] Error getting FCM token: $e');
      return null;
    }
  }

  /// Request permissions for local notifications
  Future<bool> requestPermission() async {
    final isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      return await AwesomeNotifications()
          .requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

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

  @pragma('vm:entry-point')
  static Future<void> _onActionReceivedMethod(
    ReceivedAction receivedAction,
  ) async {
    final payload = receivedAction.payload;
    if (payload != null) {
      _instance._handleNotificationClick(payload);
    }
  }

  /// Handle notification tap action based on payload 'type'
  void _handleNotificationClick(Map<String, dynamic> data) {
    final type = data['type']?.toString();
    debugPrint(
      '[NotificationService] Notification tapped with type: $type, data: $data',
    );

    if (type == 'contact_request' || type == 'request') {
      _pendingNotificationRoute = NamedRoutes.myContactRequests;
    } else {
      _pendingNotificationRoute = NamedRoutes.notifications;
    }

    consumePendingNotificationRoute();
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
