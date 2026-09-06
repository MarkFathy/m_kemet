import 'dart:io';
import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';

/// Maps [DioException] types to the app's typed [ServerException] hierarchy.
/// Attach this interceptor AFTER [AuthInterceptor] in the Dio interceptors list.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ── Step 1: Check for connection-level errors FIRST ─────────────────────
    // These happen when the device has WiFi but the server is unreachable
    // (DNS failure, SSL error, connection refused) — connectivity_plus cannot
    // detect these since the device still has a network interface.
    final networkException = _toNetworkException(err);
    if (networkException != null) {
      handler.reject(err.copyWith(error: networkException), true);
      return;
    }

    // ── Step 2: Map HTTP status codes to typed exceptions ───────────────────
    final response = err.response;
    final statusCode = response?.statusCode ?? 0;
    final message = _extractMessage(response) ?? err.message ?? 'Unknown error';
    final validationIssues = _extractValidationIssues(response);

    final appException = switch (statusCode) {
      400 => BadRequestException(statusCode, message, validationIssues),
      401 => UnauthorizedException(statusCode, message, validationIssues),
      404 => NotFoundException(statusCode, message, validationIssues),
      409 => ConflictException(statusCode, message, validationIssues),
      _ => FetchDataException(statusCode, message, validationIssues),
    };

    handler.reject(err.copyWith(error: appException), true);
  }

  /// Converts connection-level [DioException]s to [NetworkException].
  /// Returns null for HTTP errors that should follow the normal path.
  NetworkException? _toNetworkException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionError:
        // SocketException "Failed host lookup" falls here
        final inner = err.error;
        final isHostLookup =
            inner is SocketException &&
            (inner.message.toLowerCase().contains('failed host lookup') ||
                inner.message.toLowerCase().contains('network is unreachable') ||
                inner.message.toLowerCase().contains('connection refused') ||
                inner.osError?.errorCode == 7 || // ENOENT / host not found
                inner.osError?.errorCode == 101); // ENETUNREACH
        return NetworkException(
          isHostLookup ? NetworkErrorKind.hostUnreachable : NetworkErrorKind.unknown,
          message: 'لا يوجد اتصال بالإنترنت',
        );
      case DioExceptionType.connectionTimeout:
        return const NetworkException(NetworkErrorKind.connectionTimeout, message: 'انتهت مهلة الاتصال');
      case DioExceptionType.receiveTimeout:
        return const NetworkException(NetworkErrorKind.receiveTimeout, message: 'انتهت مهلة استجابة الخادم');
      case DioExceptionType.sendTimeout:
        return const NetworkException(NetworkErrorKind.sendTimeout, message: 'انتهت مهلة إرسال البيانات');
      default:
        return null;
    }
  }

  /// Extracts a human-readable message from the response body.
  String? _extractMessage(Response<dynamic>? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        return data['message'] as String? ??
            data['error'] as String? ??
            data['title'] as String?;
      }
    } catch (_) {}
    return null;
  }

  /// Extracts field-level validation issues when the API returns them.
  List<String>? _extractValidationIssues(Response<dynamic>? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        final issues = data['errors'] ?? data['validationErrors'];
        if (issues is List) {
          return issues.map((e) => e.toString()).toList();
        }
        if (issues is Map<String, dynamic>) {
          return issues.values
              .expand<String>(
                (v) => v is List ? v.map((e) => e.toString()) : [v.toString()],
              )
              .toList();
        }
      }
    } catch (_) {}
    return null;
  }
}
