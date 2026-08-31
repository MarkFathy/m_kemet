import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/helpers/cache_service.dart';

/// Adds Authorization Bearer token to every request when a token is available.
class AuthInterceptor extends Interceptor {
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
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If we get a 401, we could trigger a token-refresh flow here in the future.
    handler.next(err);
  }
}
