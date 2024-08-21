// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServerResponse _$ServerResponseFromJson(Map<String, dynamic> json) =>
    ServerResponse(
      statusCode: (json['statusCode'] as num).toInt(),
      reasonCode:
          (json['reasonCode'] as num?)?.toInt() ?? ReasonCodes.noReasonCode,
      statusMessage: json['statusMessage'] as String?,
      body: json['body'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$ServerResponseToJson(ServerResponse instance) =>
    <String, dynamic>{
      'statusCode': instance.statusCode,
      'reasonCode': instance.reasonCode,
      'statusMessage': instance.statusMessage,
      'body': instance.body,
    };
