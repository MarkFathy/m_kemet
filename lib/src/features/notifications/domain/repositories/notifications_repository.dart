import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> markAsRead(String notificationId);
  Future<Either<Failure, void>> markAllAsRead();
  Future<Either<Failure, void>> deleteNotification(String notificationId);
  Future<Either<Failure, void>> deleteAllNotifications();
  Future<Either<Failure, bool>> getNotificationStatus();
  Future<Either<Failure, bool>> setNotificationStatus(bool enable);
}
