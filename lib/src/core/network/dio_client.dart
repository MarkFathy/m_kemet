import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:m_kemet/src/core/network/auth_interceptor.dart';
import 'package:m_kemet/src/core/network/error_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

/// Central Dio HTTP client for the app.
///
/// Register as a [LazySingleton] via GetIt:
/// ```dart
/// sl.registerLazySingleton(DioClient.new);
/// ```
/// Then inject into any RemoteDataSource with `sl<DioClient>().dio`.
class DioClient {
  late final Dio dio;

  /// Base URL — swap this environment variable with your real API base URL.
  static const String _baseUrl = 'https://api.m-kemet.com/v1';

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _addInterceptors();
  }

  void _addInterceptors() {
    // 1. Auth — attaches Bearer token
    dio.interceptors.add(AuthInterceptor());

    // 2. Error — converts DioException → typed ServerException
    dio.interceptors.add(ErrorInterceptor());

    // 3. Pretty Logger — only in debug builds
    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }
  }
}
