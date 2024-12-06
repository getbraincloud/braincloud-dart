// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rtt_comms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RTTCommandResponse _$RTTCommandResponseFromJson(Map<String, dynamic> json) =>
    RTTCommandResponse(
      service: json['service'] as String,
      operation: json['operation'] as String,
      data: json['data'] as Map<String, dynamic>?,
      reasonCode: (json['reasonCode'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RTTCommandResponseToJson(RTTCommandResponse instance) =>
    <String, dynamic>{
      'service': instance.service,
      'operation': instance.operation,
      'data': instance.data,
      'reasonCode': instance.reasonCode,
    };
