import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/data/datasources/notifications_remote_data_source.dart';
import 'package:m_kemet/src/features/notifications/domain/entities/notification_entity.dart';
import 'package:m_kemet/src/features/notifications/domain/repositories/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final list = await remoteDataSource.getNotifications();
      return Right(list);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب الإشعارات',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> markAsRead(String notificationId) async {
    try {
      await remoteDataSource.markAsRead(notificationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل تحديد الإشعار كمقروء',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> markAllAsRead() async {
    try {
      await remoteDataSource.markAllAsRead();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل تحديد جميع الإشعارات كمقروءة',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(String notificationId) async {
    try {
      await remoteDataSource.deleteNotification(notificationId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل حذف الإشعار',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAllNotifications() async {
    try {
      await remoteDataSource.deleteAllNotifications();
      return const Right(null);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل حذف جميع الإشعارات',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, bool>> getNotificationStatus() async {
    try {
      final status = await remoteDataSource.getNotificationStatus();
      return Right(status);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل جلب حالة الإشعارات',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, bool>> setNotificationStatus(bool enable) async {
    try {
      final status = enable
          ? await remoteDataSource.turnOnNotifications()
          : await remoteDataSource.turnOffNotifications();
      return Right(status);
    } on DioException catch (e) {
      return Left(
        ServerFailure(
          ServerException(
            e.response?.statusCode ?? 500,
            e.response?.data?['message']?.toString() ?? e.message ?? 'فشل تغيير حالة الإشعارات',
            null,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
