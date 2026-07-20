import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';
part 'api_error.g.dart';

/// One field-level validation failure, e.g. {"field": "name", "message": "must not be blank"}.
/// The backend sends a list of these under the JSON key "errors" for a 400 VALIDATION_ERROR.
@freezed
abstract class ApiFieldError with _$ApiFieldError {
  const factory ApiFieldError({
    required String field,
    required String message,
  }) = _ApiFieldError;

  factory ApiFieldError.fromJson(Map<String, dynamic> json) =>
      _$ApiFieldErrorFromJson(json);
}

/// A typed, UI-safe representation of a backend error.
///
/// Mirrors the backend's RFC 9457 ProblemDetail body:
///   { "status": 409, "title": "Conflict", "detail": "...",
///     "code": "DUPLICATE_SKU", "errors": [ ... ] }
///
/// `status` is 0 when there was no HTTP response at all (timeout / no network).
@freezed
abstract class ApiError with _$ApiError {
  const factory ApiError({
    required int status,
    required String code,
    // Backend calls this "detail"; we expose it as `message`.
    @JsonKey(name: 'detail') required String message,
    // Backend calls this "errors"; we expose it as `fieldErrors`.
    @JsonKey(name: 'errors') @Default([]) List<ApiFieldError> fieldErrors,
  }) = _ApiError;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}
