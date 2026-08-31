import 'package:equatable/equatable.dart';
import 'package:m_kemet/src/features/auth/domain/entities/user_entity.dart';

class AuthEntity extends Equatable {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final UserEntity? user;
  final String? message;

  const AuthEntity({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.user,
    this.message,
  });

  @override
  List<Object?> get props => [
        accessToken,
        refreshToken,
        tokenType,
        user,
        message,
      ];
}
