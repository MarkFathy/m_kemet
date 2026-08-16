import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class UserTypeState extends Equatable {
  final UserType? selectedUserType;
  final bool isSaved;

  const UserTypeState({
    this.selectedUserType,
    this.isSaved = false,
  });

  UserTypeState copyWith({
    UserType? selectedUserType,
    bool? isSaved,
  }) {
    return UserTypeState(
      selectedUserType: selectedUserType ?? this.selectedUserType,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object?> get props => [selectedUserType, isSaved];
}
