import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

/// Defines the contract for notification data operations.
/// Implemented in the data layer.
abstract class NotificationsRepository {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> markAsRead(String notificationId);
  Future<void> markAllAsRead();
  Future<void> clearAll();
}
