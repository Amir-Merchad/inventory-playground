import 'package:dio/dio.dart';
import 'package:uuid/uuid.dart';

/// Stamps every outgoing request with a unique `X-Request-Id`.
///
/// The backend's CorrelationIdFilter reuses this id in its own logs, so one id
/// ties the Flutter-side log line to the exact server-side line. Logging itself
/// is handled by TalkerDioLogger — this interceptor only sets the header.
class CorrelationIdInterceptor extends Interceptor {
  static const header = 'X-Request-Id';
  static const _uuid = Uuid();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[header] = _uuid.v4();
    handler.next(options);
  }
}
