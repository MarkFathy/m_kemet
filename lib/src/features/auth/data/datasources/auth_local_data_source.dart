import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/features/auth/data/models/user_model.dart';
import 'package:m_kemet/src/features/user_type_selection/domain/entities/user_type.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthSession({
    required String token,
    String? refreshToken,
    UserModel? user,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<UserModel?> getCachedUser();

  Future<void> clearAuthSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _kCachedUser = 'cached_user_profile';
  static const String _kRefreshToken = 'refresh_token';
  static const String _kUserType = 'selected_user_type';

  @override
  Future<void> saveAuthSession({
    required String token,
    String? refreshToken,
    UserModel? user,
  }) async {
    await SessionManager.saveSession(
      token: token,
      userId: user?.id,
      email: user?.email,
    );

    if (refreshToken != null && refreshToken.isNotEmpty) {
      await SecureStorage.write(_kRefreshToken, refreshToken);
    }

    if (user != null) {
      await CacheStorage.write(_kCachedUser, user.toJson());
      await CacheStorage.write(
        _kUserType,
        user.userType == UserType.employer ? 'employer' : 'job_seeker',
      );
    }
  }

  @override
  Future<String?> getAccessToken() async {
    return SessionManager.getToken();
  }

  @override
  Future<String?> getRefreshToken() async {
    return SecureStorage.read(_kRefreshToken);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final data = CacheStorage.read(_kCachedUser, isDecoded: true) as Map<String, dynamic>?;
    if (data != null) {
      return UserModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> clearAuthSession() async {
    await SessionManager.clearSession();
    await SecureStorage.delete(_kRefreshToken);
    await CacheStorage.delete(_kCachedUser);
  }
}
