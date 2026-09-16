import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/domain/repositories/notifications_repository.dart';

class DeleteAllNotificationsUseCase {
  final NotificationsRepository repository;

  DeleteAllNotificationsUseCase(this.repository);

  Future<Either<Failure, void>> call() {
    return repository.deleteAllNotifications();
  }
}
