import 'dart:async';
import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m_kemet/firebase_options.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/features/notifications/presentation/cubit/notifications_cubit.dart';

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
        try {
          if (sl.isRegistered<NotificationsCubit>()) {
            sl<NotificationsCubit>().loadNotifications();
          }
        } catch (_) {}
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
        unawaited(syncFcmToken(newToken));
      });

      // Fetch initial device token
      final token = await getDeviceToken();
      debugPrint('[NotificationService] Current FCM Token: $token');
      if (token != null && token.isNotEmpty) {
        unawaited(syncFcmToken(token));
      }
    } catch (e) {
      debugPrint('[NotificationService] FCM init error: $e');
    }
  }

  String? _cachedDeviceId;

  /// Retrieve or generate a persistent unique Device ID that NEVER changes across restarts.
  Future<String> getDeviceId() async {
    // 1. In-memory cache
    if (_cachedDeviceId != null && _cachedDeviceId!.isNotEmpty) {
      return _cachedDeviceId!;
    }

    // 2. Persistent SharedPreferences (CacheStorage) - reliable across restarts
    try {
      final cachedPref = CacheStorage.read('device_unique_id');
      if (cachedPref is String && cachedPref.isNotEmpty) {
        _cachedDeviceId = cachedPref;
        return _cachedDeviceId!;
      }
    } catch (_) {}

    // 3. Persistent SecureStorage fallback
    try {
      final cachedSecure = await SecureStorage.read('device_unique_id');
      if (cachedSecure != null && cachedSecure.isNotEmpty) {
        _cachedDeviceId = cachedSecure;
        await CacheStorage.write('device_unique_id', cachedSecure);
        return _cachedDeviceId!;
      }
    } catch (_) {}

    // 4. Resolve hardware ID from platform
    String? hardwareId;
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (kIsWeb) {
        final webInfo = await deviceInfo.webBrowserInfo;
        hardwareId = 'web_${webInfo.vendor}_${webInfo.userAgent.hashCode.abs()}';
      } else if (defaultTargetPlatform == TargetPlatform.android) {
        final androidInfo = await deviceInfo.androidInfo;
        hardwareId = androidInfo.id.isNotEmpty ? 'android_${androidInfo.id}' : null;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final iosInfo = await deviceInfo.iosInfo;
        hardwareId = iosInfo.identifierForVendor != null
            ? 'ios_${iosInfo.identifierForVendor}'
            : null;
      } else if (defaultTargetPlatform == TargetPlatform.windows) {
        final winInfo = await deviceInfo.windowsInfo;
        hardwareId = 'win_${winInfo.deviceId.replaceAll(RegExp(r'[{}]'), '')}';
      }
    } catch (e) {
      debugPrint('[NotificationService] Error reading hardware info: $e');
    }

    // 5. If no hardware ID, generate a unique random ID ONCE
    final resolvedId = (hardwareId != null && hardwareId.isNotEmpty)
        ? hardwareId
        : 'dev_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';

    _cachedDeviceId = resolvedId;

    // 6. Save to BOTH storage systems so it NEVER changes again
    try {
      await CacheStorage.write('device_unique_id', resolvedId);
      await SecureStorage.write('device_unique_id', resolvedId);
    } catch (e) {
      debugPrint('[NotificationService] Warning saving device ID: $e');
    }

    debugPrint('[NotificationService] Persistent Device ID initialized: $resolvedId');
    return resolvedId;
  }

  /// Send guest FCM device token to backend: POST /api/fcm-token
  Future<bool> sendGuestFcmToken(String token, {String? deviceId}) async {
    try {
      final resolvedDeviceId = deviceId ?? await getDeviceId();
      debugPrint(
        '[NotificationService] Sending FCM token to guest endpoint: ${ApiEndpoints.fcmToken} (deviceId: $resolvedDeviceId)',
      );
      final response = await sl<DioClient>().dio.post(
        ApiEndpoints.fcmToken,
        data: {
          'token': token,
          'device_id': resolvedDeviceId,
        },
      );
      debugPrint(
        '[NotificationService] Guest FCM token stored successfully: ${response.statusCode} - ${response.data}',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[NotificationService] Error sending guest FCM token: $e');
      return false;
    }
  }

  /// Send authenticated user FCM device token to backend: POST /api/fcm-token-user
  Future<bool> sendUserFcmToken(String token, {String? deviceId}) async {
    try {
      final resolvedDeviceId = deviceId ?? await getDeviceId();
      debugPrint(
        '[NotificationService] Sending FCM token to user endpoint: ${ApiEndpoints.fcmTokenUser} (deviceId: $resolvedDeviceId)',
      );
      final response = await sl<DioClient>().dio.post(
        ApiEndpoints.fcmTokenUser,
        data: {
          'token': token,
          'device_id': resolvedDeviceId,
        },
      );
      debugPrint(
        '[NotificationService] User FCM token stored successfully: ${response.statusCode} - ${response.data}',
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint('[NotificationService] Error sending user FCM token: $e');
      return false;
    }
  }

  /// Synchronize FCM device token with the backend.
  /// Automatically decides between user and guest endpoints based on current auth state.
  Future<bool> syncFcmToken([String? token]) async {
    try {
      final fcmToken = token ?? await getDeviceToken();
      if (fcmToken == null || fcmToken.trim().isEmpty) {
        debugPrint('[NotificationService] FCM token is null or empty, skipping sync.');
        return false;
      }

      final deviceId = await getDeviceId();
      final isLoggedIn = await SessionManager.isLoggedIn();
      debugPrint(
        '[NotificationService] Syncing FCM token (isLoggedIn: $isLoggedIn, deviceId: $deviceId)...',
      );

      if (isLoggedIn) {
        final success = await sendUserFcmToken(fcmToken, deviceId: deviceId);
        if (success) return true;
        // If sending to user endpoint failed, fallback to guest endpoint
        return await sendGuestFcmToken(fcmToken, deviceId: deviceId);
      } else {
        return await sendGuestFcmToken(fcmToken, deviceId: deviceId);
      }
    } catch (e) {
      debugPrint('[NotificationService] Error in syncFcmToken: $e');
      return false;
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
