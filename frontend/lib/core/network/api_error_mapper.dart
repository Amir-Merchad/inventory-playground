import 'package:dio/dio.dart';

import 'api_error.dart';

/// Converts any thrown error into a typed [ApiError].
///
/// Two very different situations produce a DioException:
///   - the server responded with an error body  (we parse the ProblemDetail)
///   - no response arrived at all               (timeout / DNS / refused)
/// Every catch block in the app should route through this one function.
ApiError toApiError(Object error) {
  if (error is DioException) {
    return _fromDioException(error);
  }
  // Not a Dio error at all — a bug in our own code. Never leak toString() to users.
  return const ApiError(
    status: 0,
    code: 'UNKNOWN',
    message: 'Something went wrong.',
  );
}

ApiError _fromDioException(DioException e) {
  final response = e.response;

  // CASE A: the server responded with a JSON body (409, 404, 400, 500...).
  // Parse our ProblemDetail contract out of it.
  if (response != null && response.data is Map<String, dynamic>) {
    final data = response.data as Map<String, dynamic>;
    return ApiError.fromJson({
      ...data,
      // These keys can be missing/null in the body; supply safe fallbacks
      // so fromJson never chokes on a required field.
      'status': data['status'] ?? response.statusCode ?? 0,
      'code': data['code'] ?? 'UNKNOWN',
      'detail': data['detail'] ?? data['title'] ?? 'Something went wrong.',
    });
  }

  // CASE B: no usable response body — build a client-side error from the type.
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const ApiError(
        status: 0,
        code: 'TIMEOUT',
        message: 'The server took too long to respond. Please try again.',
      );
    case DioExceptionType.connectionError:
      return const ApiError(
        status: 0,
        code: 'NETWORK',
        message: "Can't reach the server. Check your connection.",
      );
    case DioExceptionType.cancel:
      return const ApiError(
        status: 0,
        code: 'CANCELLED',
        message: 'The request was cancelled.',
      );
    case DioExceptionType.badCertificate:
    case DioExceptionType.badResponse:
    case DioExceptionType.unknown:
      return const ApiError(
        status: 0,
        code: 'UNKNOWN',
        message: 'Something went wrong.',
      );
  }
}
