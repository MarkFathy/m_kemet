import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/network/dio_client.dart';
import 'package:m_kemet/src/features/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
  Future<bool> getNotificationStatus();
  Future<bool> turnOnNotifications();
  Future<bool> turnOffNotifications();
}

class NotificationsRemoteDataSourceImpl implements NotificationsRemoteDataSource {
  final DioClient _dioClient;

  NotificationsRemoteDataSourceImpl(this._dioClient);

  @override
  Future<List<NotificationModel>> getNotifications() async {
    final response = await _dioClient.dio.get(ApiEndpoints.notifications);
    final data = response.data;

    List<dynamic>? list;
    if (data is Map<String, dynamic>) {
      if (data['data'] is List) {
        list = data['data'] as List<dynamic>;
      } else if (data['data'] is Map<String, dynamic>) {
        final innerMap = data['data'] as Map<String, dynamic>;
        if (innerMap['notifications'] is List) {
          list = innerMap['notifications'] as List<dynamic>;
        } else if (innerMap['data'] is List) {
          list = innerMap['data'] as List<dynamic>;
        }
      } else if (data['notifications'] is List) {
        list = data['notifications'] as List<dynamic>;
      }
    } else if (data is List) {
      list = data;
    }

    if (list != null) {
      return list
          .whereType<Map<String, dynamic>>()
          .map(NotificationModel.fromJson)
          .toList();
    }

    return [];
  }

  @override
  Future<void> markAsRead(String id) async {
    final url = ApiEndpoints.notificationRead(id);
    try {
      await _dioClient.dio.get(url);
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.post(url);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> markAllAsRead() async {
    final url = ApiEndpoints.notificationsReadAll;
    try {
      await _dioClient.dio.get(url);
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.post(url);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteNotification(String id) async {
    try {
      await _dioClient.dio.delete(ApiEndpoints.notificationDelete(id));
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.post(ApiEndpoints.notificationDelete(id));
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<void> deleteAllNotifications() async {
    try {
      await _dioClient.dio.delete(ApiEndpoints.notificationsDeleteAll);
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.post(ApiEndpoints.notificationsDeleteAll);
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<bool> getNotificationStatus() async {
    try {
      final response = await _dioClient.dio.get(ApiEndpoints.notificationStatus);
      final data = response.data;
      if (data == null) return true;

      // Helper to parse any dynamic value into a boolean
      bool? parseBool(dynamic val) {
        if (val == null) return null;
        if (val is bool) return val;
        if (val is num) return val == 1;
        if (val is String) {
          final s = val.toLowerCase().trim();
          if (s == '1' || s == 'true' || s == 'on' || s == 'active' || s == 'enabled') return true;
          if (s == '0' || s == 'false' || s == 'off' || s == 'inactive' || s == 'disabled') return false;
        }
        return null;
      }

      if (data is Map<String, dynamic>) {
        final payload = data['data'];
        if (payload is Map<String, dynamic>) {
          for (final key in [
            'status',
            'enabled',
            'notification',
            'notifications',
            'notification_status',
            'is_notify',
            'is_active',
            'state',
          ]) {
            final parsed = parseBool(payload[key]);
            if (parsed != null) return parsed;
          }
        }

        final parsedData = parseBool(payload);
        if (parsedData != null) return parsedData;

        for (final key in [
          'notification_status',
          'notifications_enabled',
          'is_notify',
          'enabled',
        ]) {
          final parsed = parseBool(data[key]);
          if (parsed != null) return parsed;
        }
      } else {
        final parsed = parseBool(data);
        if (parsed != null) return parsed;
      }

      // Default in normal state is true
      return true;
    } catch (_) {
      // In normal state, default to enabled
      return true;
    }
  }

  @override
  Future<bool> turnOnNotifications() async {
    try {
      await _dioClient.dio.post(ApiEndpoints.notificationTurnOn);
      return true;
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.get(ApiEndpoints.notificationTurnOn);
        return true;
      }
      rethrow;
    }
  }

  @override
  Future<bool> turnOffNotifications() async {
    try {
      await _dioClient.dio.post(ApiEndpoints.notificationTurnOff);
      return false;
    } on DioException catch (e) {
      if (e.response?.statusCode == 405) {
        await _dioClient.dio.get(ApiEndpoints.notificationTurnOff);
        return false;
      }
      rethrow;
    }
  }
}
