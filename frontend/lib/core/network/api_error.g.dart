// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiFieldError _$ApiFieldErrorFromJson(Map<String, dynamic> json) =>
    _ApiFieldError(
      field: json['field'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$ApiFieldErrorToJson(_ApiFieldError instance) =>
    <String, dynamic>{
      'field': instance.field,
      'message': instance.message,
    };

_ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => _ApiError(
      status: (json['status'] as num).toInt(),
      code: json['code'] as String,
      message: json['detail'] as String,
      fieldErrors: (json['errors'] as List<dynamic>?)
              ?.map((e) => ApiFieldError.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ApiErrorToJson(_ApiError instance) => <String, dynamic>{
      'status': instance.status,
      'code': instance.code,
      'detail': instance.message,
      'errors': instance.fieldErrors,
    };
