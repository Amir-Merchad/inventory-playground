import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/core/logging/app_log.dart';
import 'package:frontend/core/network/correlation_id_interceptor.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

const _apiBaseUrl = String.fromEnvironment(
  'API_BASE_URL',
  // defaultValue: 'https://inventory-playground-production.up.railway.app/api',
  defaultValue: 'http://localhost:8080/api',
);

Dio createDioClient() {
  final dio = Dio(
    BaseOptions(
      baseUrl: _apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: const {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Set the correlation-id header first, then log via Talker.
  dio.interceptors.add(CorrelationIdInterceptor());
  dio.interceptors.add(
    TalkerDioLogger(
      talker: AppLog.talker,
      settings: TalkerDioLoggerSettings(
        // Always redact secrets from headers (auth token, cookies).
        hiddenHeaders: {'authorization', 'cookie', 'set-cookie'},
        // Headers/bodies only in debug — never log a password or JWT in release.
        printRequestHeaders: kDebugMode,
        printResponseHeaders: kDebugMode,
        printRequestData: kDebugMode,
        printResponseData: kDebugMode,

        // printRequestHeaders: false,
        // printResponseHeaders: false,
        // printRequestData: false,
        // printResponseData: false,

        // Extra safety once auth exists: don't log auth request/response bodies.
        requestFilter: (options) => !options.path.contains('/auth'),
        responseFilter: (response) => !response.requestOptions.path.contains('/auth'),
      ),
    ),
  );

  return dio;
}
