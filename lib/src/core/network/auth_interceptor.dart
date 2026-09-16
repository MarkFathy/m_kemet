import 'dart:async';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';
import 'package:m_kemet/src/core/navigation/named_routes.dart';
import 'package:m_kemet/src/core/navigation/navigator.dart';
import 'package:m_kemet/src/core/network/api_endpoints.dart';
import 'package:m_kemet/src/core/services/session_manager.dart';
import 'package:m_kemet/src/features/auth/data/models/auth_response_model.dart';

/// Adds Authorization Bearer token to every request and automatically refreshes
/// the access token when receiving a 401 Unauthorized using a queued interceptor.
class AuthInterceptor extends QueuedInterceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorage.read('access_token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    final lang = (CacheStorage.read('app_language') as String?) ?? 'ar';
    options.headers['Accept-Language'] = lang;
    options.headers['Accept'] = 'application/json';

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // Only intercept 401 Unauthorized responses
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    final path = err.requestOptions.path;

    // Do NOT refresh token for auth/public endpoints
    final isAuthEndpoint = path.contains(ApiEndpoints.login) ||
        path.contains(ApiEndpoints.registerCandidate) ||
        path.contains(ApiEndpoints.registerCompany) ||
        path.contains(ApiEndpoints.forgotPassword) ||
        path.contains(ApiEndpoints.verifyOtp) ||
        path.contains(ApiEndpoints.resetPassword) ||
        path.contains(ApiEndpoints.fcmToken);

    if (isAuthEndpoint) {
      return handler.next(err);
    }

    // If the failed request was the refresh-token endpoint itself, the refresh token has expired.
    if (path.contains(ApiEndpoints.refreshToken)) {
      await _handleForceLogout();
      return handler.next(err);
    }

    try {
      final currentAccessToken = await SecureStorage.read('access_token');
      final requestAuthHeader =
          err.requestOptions.headers['Authorization']?.toString();
      final requestToken = requestAuthHeader?.replaceFirst('Bearer ', '');

      // Check if another queued request already refreshed the token
      if (currentAccessToken != null &&
          currentAccessToken.isNotEmpty &&
          requestToken != null &&
          currentAccessToken != requestToken) {
        // Token was already refreshed! Retry the request with the new access token
        err.requestOptions.headers['Authorization'] =
            'Bearer $currentAccessToken';
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      }

      // Read stored refresh token
      final refreshToken = await SecureStorage.read('refresh_token');
      if (refreshToken == null || refreshToken.isEmpty) {
        await _handleForceLogout();
        return handler.next(err);
      }

      // Make refresh token call using an isolated Dio instance without interceptors
      final baseUrl = err.requestOptions.baseUrl.isNotEmpty
          ? err.requestOptions.baseUrl
          : 'https://m-kemet.aqarmousa.com';

      final refreshDio = Dio(
        BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final refreshResponse = await refreshDio.post<dynamic>(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken},
      );

      if (refreshResponse.statusCode == 200 ||
          refreshResponse.statusCode == 201) {
        final data = refreshResponse.data;
        if (data is Map<String, dynamic>) {
          final authModel = AuthResponseModel.fromJson(data);
          final newAccessToken = authModel.accessToken;
          final newRefreshToken = authModel.refreshToken;

          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await SecureStorage.write('access_token', newAccessToken);
            if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
              await SecureStorage.write('refresh_token', newRefreshToken);
            }

            // Retry the original request with the new token
            err.requestOptions.headers['Authorization'] =
                'Bearer $newAccessToken';
            final retryResponse = await _retryRequest(err.requestOptions);
            return handler.resolve(retryResponse);
          }
        }
      }

      // If refresh response didn't return a valid token, log out
      await _handleForceLogout();
      return handler.next(err);
    } catch (_) {
      // If refresh failed (network/server/token expired), log out and reject
      await _handleForceLogout();
      return handler.next(err);
    }
  }

  Future<void> _handleForceLogout() async {
    await SessionManager.clearSession();
    unawaited(Go.offAllNamed(NamedRoutes.login));
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) {
    final dio = Dio(
      BaseOptions(
        baseUrl: requestOptions.baseUrl,
        connectTimeout: requestOptions.connectTimeout,
        receiveTimeout: requestOptions.receiveTimeout,
        sendTimeout: requestOptions.sendTimeout,
      ),
    );

    dynamic data = requestOptions.data;
    if (data is FormData) {
      data = data.clone();
    }

    return dio.request<dynamic>(
      requestOptions.path,
      data: data,
      queryParameters: requestOptions.queryParameters,
      options: Options(
        method: requestOptions.method,
        headers: requestOptions.headers,
        contentType: requestOptions.contentType,
        responseType: requestOptions.responseType,
      ),
    );
  }
}
