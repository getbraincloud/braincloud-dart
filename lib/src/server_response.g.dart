// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) =>
    ServerResponse(
      statusCode: (json['status'] as num).toInt(),
      reasonCode:
          (json['reason_code'] as num?)?.toInt() ?? ReasonCodes.noReasonCode,
      error: json['status_message'] as String?,
      data: json['data'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ServerResponseToJson(ServerResponse instance) =>
    <String, dynamic>{
      'status': instance.statusCode,
      'reason_code': instance.reasonCode,
      'status_message': instance.error,
      'data': instance.data,
    };
