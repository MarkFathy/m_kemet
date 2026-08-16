import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

abstract class UserTypeRepository {
  Future<Either<Failure, void>> saveSelectedUserType(UserType userType);
  Future<Either<Failure, UserType?>> getSelectedUserType();
}
