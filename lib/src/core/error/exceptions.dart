import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception {
  final int statusCode;
  final bool success;
  final String message;
  final List<String>? validationIssues;

  const ServerException(this.statusCode, this.message, this.validationIssues, {this.success = false});

  @override
  List<Object?> get props => [statusCode, success, message, validationIssues];
}

class FetchDataException extends ServerException {
  const FetchDataException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class BadRequestException extends ServerException {
  const BadRequestException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class UnauthorizedException extends ServerException {
  const UnauthorizedException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class NotFoundException extends ServerException {
  const NotFoundException(super.statusCode, super.message, super.validationIssues, {super.success});
}

class ConflictException extends ServerException {
  const ConflictException(super.statusCode, super.message, super.validationIssues, {super.success});
}

/// Thrown when the device has a network interface but cannot reach the server.
/// Causes: Failed host lookup (DNS), connection refused, SSL error, send/receive timeout.
/// NOTE: This is different from [NoInternetException] — the user may have WiFi
/// but the server is unreachable.
class NetworkException extends ServerException {
  final NetworkErrorKind kind;

  const NetworkException(
    this.kind, {
    String message = '',
  }) : super(0, message, null);

  @override
  List<Object?> get props => [statusCode, kind, message];
}

enum NetworkErrorKind {
  /// Device has no network interface at all.
  noInternet,
  /// DNS / host-lookup failure ("Failed host lookup").
  hostUnreachable,
  /// Request timed out before connecting.
  connectionTimeout,
  /// Request was sent but response never arrived in time.
  receiveTimeout,
  /// Data timed out while sending (large upload).
  sendTimeout,
  /// Any other lower-level connection error.
  unknown,
}

class CacheException implements Exception {}
