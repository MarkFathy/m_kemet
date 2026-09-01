import 'package:m_kemet/src/core/helpers/cache_service.dart';

class SessionManager {
  SessionManager._();

  static const String _kAccessToken = 'access_token';
  static const String _kUserId = 'user_id';
  static const String _kUserEmail = 'user_email';
  static const String _kUserType = 'user_type';
  static const String _kJobSeekerProfileCompleted = 'job_seeker_profile_completed';

  static Future<void> saveSession({
    required String token,
    String? userId,
    String? email,
    String? userType,
  }) async {
    await SecureStorage.write(_kAccessToken, token);
    if (userId != null) {
      await SecureStorage.write(_kUserId, userId);
    }
    if (email != null) {
      await SecureStorage.write(_kUserEmail, email);
    }
    if (userType != null) {
      await SecureStorage.write(_kUserType, userType);
    }
  }

  static Future<String?> getToken() async => SecureStorage.read(_kAccessToken);

  static Future<String?> getUserId() async => SecureStorage.read(_kUserId);

  static Future<String?> getEmail() async => SecureStorage.read(_kUserEmail);

  static Future<String?> getUserType() async => SecureStorage.read(_kUserType);

  static Future<void> saveUserType(String userType) async {
    await SecureStorage.write(_kUserType, userType);
  }

  static Future<bool> isJobSeekerProfileCompleted() async {
    final status = await SecureStorage.read(_kJobSeekerProfileCompleted);
    return status == 'true';
  }

  static Future<void> setJobSeekerProfileCompleted(bool completed) async {
    await SecureStorage.write(_kJobSeekerProfileCompleted, completed ? 'true' : 'false');
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  static Future<void> clearSession() async {
    await SecureStorage.delete(_kAccessToken);
    await SecureStorage.delete(_kUserId);
    await SecureStorage.delete(_kUserEmail);
    await SecureStorage.delete(_kUserType);
    await SecureStorage.delete(_kJobSeekerProfileCompleted);
  }
}
