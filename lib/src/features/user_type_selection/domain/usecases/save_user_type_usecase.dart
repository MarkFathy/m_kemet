import 'package:dartz/dartz.dart';
import 'package:m_kemet/src/core/error/failure.dart';
import 'package:m_kemet/src/core/usecases/usecase.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/repositories/user_type_repository.dart';

class SaveUserTypeUseCase extends BaseUseCase<void, UserType> {
  final UserTypeRepository repository;

  SaveUserTypeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UserType params) async {
    return await repository.saveSelectedUserType(params);
  }
}
