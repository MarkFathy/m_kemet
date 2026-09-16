import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/notifications/domain/repositories/notifications_repository.dart';

class SetNotificationStatusUseCase {
  final NotificationsRepository repository;

  SetNotificationStatusUseCase(this.repository);

  Future<Either<Failure, bool>> call(bool enable) {
    return repository.setNotificationStatus(enable);
  }
}
