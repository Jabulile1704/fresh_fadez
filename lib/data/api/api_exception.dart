import 'package:dio/dio.dart';

/// Every error code the API can return, plus the ones only the client can
/// know about (no network, timeout).
///
/// The server's envelope is always `{ error: { code, message, details? } }`,
/// so one mapping here covers the whole surface.
enum ApiErrorCode {
  badRequest,
  validationFailed,
  unauthorized,
  forbidden,
  notFound,
  alreadyExists,

  /// Somebody else took the slot between the availability call and the
  /// booking. The one error the booking flow must handle gracefully rather
  /// than treat as a failure.
  slotTaken,

  tooManyRequests,
  malformedJson,
  internal,
  network,
  timeout,
  unknown;

  static ApiErrorCode fromWire(String? code) => switch (code) {
    'BAD_REQUEST' => ApiErrorCode.badRequest,
    'VALIDATION_FAILED' => ApiErrorCode.validationFailed,
    'UNAUTHORIZED' ||
    'INVALID_CREDENTIALS' ||
    'TOKEN_EXPIRED' => ApiErrorCode.unauthorized,
    'FORBIDDEN' => ApiErrorCode.forbidden,
    'NOT_FOUND' => ApiErrorCode.notFound,
    'ALREADY_EXISTS' => ApiErrorCode.alreadyExists,
    'SLOT_TAKEN' => ApiErrorCode.slotTaken,
    'TOO_MANY_REQUESTS' => ApiErrorCode.tooManyRequests,
    'MALFORMED_JSON' => ApiErrorCode.malformedJson,
    'INTERNAL' => ApiErrorCode.internal,
    _ => ApiErrorCode.unknown,
  };
}

/// A failed API call, already translated into something a screen can show.
///
/// Screens should never see a raw [DioException]: a socket error and a 500
/// need different words, and deciding that in the widget tree is how error
/// handling ends up inconsistent.
class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.fieldErrors = const {},
  });

  /// Builds an [ApiException] from whatever Dio threw.
  factory ApiException.from(Object error) {
    if (error is ApiException) {
      return error;
    }
    if (error is! DioException) {
      return const ApiException(
        code: ApiErrorCode.unknown,
        message: 'Something went wrong. Please try again.',
      );
    }

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiException(
          code: ApiErrorCode.timeout,
          message: 'That took too long. Check your signal and try again.',
        );
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        if (error.response == null) {
          return const ApiException(
            code: ApiErrorCode.network,
            message: "Can't reach Fresh Fadez. Are you online?",
          );
        }
      default:
        break;
    }

    final status = error.response?.statusCode;
    final data = error.response?.data;
    final envelope = data is Map<String, dynamic>
        ? data['error'] as Map<String, dynamic>?
        : null;

    final code = ApiErrorCode.fromWire(envelope?['code'] as String?);
    final message =
        envelope?['message'] as String? ??
        'Something went wrong. Please try again.';

    final details = envelope?['details'];
    final fieldErrors = <String, List<String>>{};
    if (details is Map<String, dynamic>) {
      for (final entry in details.entries) {
        final value = entry.value;
        if (value is List) {
          fieldErrors[entry.key] = value.map((v) => '$v').toList();
        }
      }
    }

    return ApiException(
      code: code,
      message: message,
      statusCode: status,
      fieldErrors: fieldErrors,
    );
  }

  final ApiErrorCode code;
  final String message;
  final int? statusCode;

  /// Per-field messages from a 422, keyed by field name, ready to drop into
  /// a form's `validator`.
  final Map<String, List<String>> fieldErrors;

  bool get isSlotTaken => code == ApiErrorCode.slotTaken;

  bool get isAuthFailure => code == ApiErrorCode.unauthorized;

  bool get isOffline =>
      code == ApiErrorCode.network || code == ApiErrorCode.timeout;

  @override
  String toString() => 'ApiException(${code.name}, $statusCode): $message';
}
