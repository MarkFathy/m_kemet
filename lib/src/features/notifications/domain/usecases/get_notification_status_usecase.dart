import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/domain/repositories/notifications_repository.dart';

class GetNotificationStatusUseCase {
  final NotificationsRepository repository;

  GetNotificationStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call() {
    return repository.getNotificationStatus();
  }
}
