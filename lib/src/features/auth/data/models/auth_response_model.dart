import 'package:m_kemet/src/features/auth/data/models/user_model.dart';
import 'package:m_kemet/src/features/auth/domain/entities/auth_entity.dart';

class AuthResponseModel extends AuthEntity {
  const AuthResponseModel({
    super.accessToken,
    super.refreshToken,
    super.tokenType,
    super.user,
    super.message,
  });

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) {
    // Nested data extraction if response is wrapped in 'data'
    final data = json['data'] is Map<String, dynamic> ? json['data'] as Map<String, dynamic> : json;

    final token = data['token']?.toString() ??
        data['access_token']?.toString() ??
        json['token']?.toString() ??
        json['access_token']?.toString();

    final refreshToken = data['refresh_token']?.toString() ?? json['refresh_token']?.toString();

    final tokenType = data['token_type']?.toString() ?? json['token_type']?.toString() ?? 'Bearer';

    final message = json['message']?.toString() ?? data['message']?.toString();

    UserModel? user;
    if (data['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(data['user'] as Map<String, dynamic>);
    } else if (json['user'] is Map<String, dynamic>) {
      user = UserModel.fromJson(json['user'] as Map<String, dynamic>);
    } else if (data['candidate'] is Map<String, dynamic>) {
      user = UserModel.fromJson(data['candidate'] as Map<String, dynamic>);
    } else if (data['company'] is Map<String, dynamic>) {
      user = UserModel.fromJson(data['company'] as Map<String, dynamic>);
    }

    return AuthResponseModel(
      accessToken: token,
      refreshToken: refreshToken,
      tokenType: tokenType,
      user: user,
      message: message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'user': (user as UserModel?)?.toJson(),
      'message': message,
    };
  }
}
