// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'braincloud_comms.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

JsonResponseBundleV2 _$JsonResponseBundleV2FromJson(
        Map<String, dynamic> json) =>
    JsonResponseBundleV2(
      (json['packetId'] as num).toInt(),
      (json['responses'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      (json['events'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$JsonResponseBundleV2ToJson(
        JsonResponseBundleV2 instance) =>
    <String, dynamic>{
      'packetId': instance.packetId,
      'responses': instance.responses,
      'events': instance.events,
    };

JsonResponseErrorBundleV2 _$JsonResponseErrorBundleV2FromJson(
        Map<String, dynamic> json) =>
    JsonResponseErrorBundleV2(
      (json['packetId'] as num).toInt(),
      (json['responses'] as List<dynamic>)
          .map((e) => JsonErrorMessage.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$JsonResponseErrorBundleV2ToJson(
        JsonResponseErrorBundleV2 instance) =>
    <String, dynamic>{
      'packetId': instance.packetId,
      'responses': instance.responses,
    };

JsonErrorMessage _$JsonErrorMessageFromJson(Map<String, dynamic> json) =>
    JsonErrorMessage(
      (json['status'] as num).toInt(),
      (json['reason_code'] as num).toInt(),
      json['status_message'] as String,
    )..severity = json['severity'] as String;

Map<String, dynamic> _$JsonErrorMessageToJson(JsonErrorMessage instance) =>
    <String, dynamic>{
      'reason_code': instance.reasonCode,
      'status': instance.status,
      'status_message': instance.statusMessage,
      'severity': instance.severity,
    };
