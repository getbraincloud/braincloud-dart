import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/status_codes.dart';

import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable()
class ServerResponse {
  @JsonKey(name: 'status')
  final int statusCode;
  @JsonKey(name: 'reason_code')
  final int? reasonCode;
  @JsonKey(name: 'status_message')
  final String? statusMessage;
  @JsonKey(name: 'data')
  final Map<String, dynamic>? data;

  ServerResponse(
      {required this.statusCode,
      this.reasonCode = ReasonCodes.noReasonCode,
      this.statusMessage,
      this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerResponseToJson(this);

  @override
  String toString() {
    return 'Status: $statusCode Reason: $reasonCode Message: $statusMessage hasData: ${(data?.isNotEmpty ?? false) ? 'Yes' : 'No'}';
  }

  bool isSuccess() => statusCode == StatusCodes.ok;
}
