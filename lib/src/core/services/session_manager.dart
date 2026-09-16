import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/services/service_locator/service_locator.dart';
import 'package:m_kemet/src/features/job_seeker/domain/usecases/get_candidate_profile_usecase.dart';

class SessionManager {
  SessionManager._();

  static const String _kAccessToken = 'access_token';
  static const String _kRefreshToken = 'refresh_token';
  static const String _kUserId = 'user_id';
  static const String _kUserEmail = 'user_email';
  static const String _kUserType = 'user_type';
  static const String _kJobSeekerProfileCompleted = 'job_seeker_profile_completed';

  static Future<void> saveSession({
    required String token,
    String? refreshToken,
    String? userId,
    String? email,
    String? userType,
  }) async {
    await SecureStorage.write(_kAccessToken, token);
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await SecureStorage.write(_kRefreshToken, refreshToken);
    }
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

  static Future<String?> getRefreshToken() async => SecureStorage.read(_kRefreshToken);

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

  /// Checks backend status and returns the correct [NamedRoutes] the job seeker should land on:
  /// - `approved`  → [NamedRoutes.jobSeekerMain]       (can see profile)
  /// - `pending`   → [NamedRoutes.requestStatus]       (waiting for admin review)
  /// - `rejected` / empty → [NamedRoutes.jobSeekerProfileSetup] (must resubmit)
  static Future<NamedRoutes> getJobSeekerRouteDestination() async {
    try {
      final result = await sl<GetCandidateProfileUseCase>()();
      return await result.fold(
        // On network error: fallback to cached bool
        (_) async {
          final completed = await isJobSeekerProfileCompleted();
          return completed
              ? NamedRoutes.requestStatus
              : NamedRoutes.jobSeekerProfileSetup;
        },
        (profile) async {
          final status = profile.status?.toLowerCase().trim();
          if (status == 'approved') {
            await setJobSeekerProfileCompleted(true);
            return NamedRoutes.jobSeekerMain;
          } else if (profile.isRejected) {
            await setJobSeekerProfileCompleted(false);
            return NamedRoutes.jobSeekerProfileSetup;
          } else if (profile.hasCompletedOrSubmittedProfile) {
            // Submitted / pending review
            await setJobSeekerProfileCompleted(true);
            return NamedRoutes.requestStatus;
          } else {
            await setJobSeekerProfileCompleted(false);
            return NamedRoutes.jobSeekerProfileSetup;
          }
        },
      );
    } catch (_) {
      final completed = await isJobSeekerProfileCompleted();
      return completed
          ? NamedRoutes.requestStatus
          : NamedRoutes.jobSeekerProfileSetup;
    }
  }

  /// Checks both local cache and backend server to see if the candidate has
  /// already submitted their documents, video, or request.
  /// Returns false for rejected candidates so they are redirected to refill the form.
  static Future<bool> checkAndSyncJobSeekerProfileCompleted() async {
    try {
      final result = await sl<GetCandidateProfileUseCase>()();
      return await result.fold(
        (_) async => isJobSeekerProfileCompleted(),
        (profile) async {
          // Rejected candidates must refill the form
          if (profile.isRejected) {
            await setJobSeekerProfileCompleted(false);
            return false;
          }
          if (profile.hasCompletedOrSubmittedProfile) {
            await setJobSeekerProfileCompleted(true);
            return true;
          }
          await setJobSeekerProfileCompleted(false);
          return false;
        },
      );
    } catch (_) {
      return isJobSeekerProfileCompleted();
    }
  }

  static Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }

  static Future<void> clearSession() async {
    await SecureStorage.delete(_kAccessToken);
    await SecureStorage.delete(_kRefreshToken);
    await SecureStorage.delete(_kUserId);
    await SecureStorage.delete(_kUserEmail);
    await SecureStorage.delete(_kUserType);
    await SecureStorage.delete(_kJobSeekerProfileCompleted);
  }
}
