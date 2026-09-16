import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/domain/repositories/notifications_repository.dart';

class DeleteNotificationUseCase {
  final NotificationsRepository repository;

  DeleteNotificationUseCase(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteNotification(id);
  }
}
