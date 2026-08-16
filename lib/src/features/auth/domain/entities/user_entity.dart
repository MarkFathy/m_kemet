import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final UserType userType;

  const UserEntity({
    required this.id,
    required this.email,
    required this.name,
    required this.userType,
    this.phone,
  });

  @override
  List<Object?> get props => [id, email, name, phone, userType];
}
