import 'package:dio/dio.dart';
import 'package:m_kemet/src/core/error/exceptions.dart';

/// Maps [DioException] types to the app's typed [ServerException] hierarchy.
/// Attach this interceptor AFTER [AuthInterceptor] in the Dio interceptors list.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
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

    handler.reject(
      err.copyWith(error: appException),
      true,
    );
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
