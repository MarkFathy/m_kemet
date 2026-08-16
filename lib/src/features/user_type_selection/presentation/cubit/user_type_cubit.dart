import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/usecases/save_user_type_usecase.dart';
import 'package:m_kemet/src/features/user_type_selection/presentation/cubit/user_type_state.dart';

class UserTypeCubit extends Cubit<UserTypeState> {
  final SaveUserTypeUseCase saveUserTypeUseCase;

  UserTypeCubit({
    required this.saveUserTypeUseCase,
  }) : super(const UserTypeState());

  void selectUserType(UserType userType) {
    emit(state.copyWith(selectedUserType: userType));
  }

  Future<void> confirmSelection() async {
    if (state.selectedUserType == null) return;
    final result = await saveUserTypeUseCase(state.selectedUserType!);
    result.fold(
      (failure) {},
      (_) {
        emit(state.copyWith(isSaved: true));
      },
    );
  }
}
