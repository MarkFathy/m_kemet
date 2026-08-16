import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/features/user_type_selection/data/datasources/user_type_local_data_source.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/repositories/user_type_repository.dart';

class UserTypeRepositoryImpl implements UserTypeRepository {
  final UserTypeLocalDataSource localDataSource;

  UserTypeRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, void>> saveSelectedUserType(UserType userType) async {
    try {
      await localDataSource.saveUserType(userType);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }

  @override
  Future<Either<Failure, UserType?>> getSelectedUserType() async {
    try {
      final result = await localDataSource.getUserType();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(ServerException(500, e.toString(), null)));
    }
  }
}
