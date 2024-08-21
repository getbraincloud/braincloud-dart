import 'package:braincloud_dart/src/reason_codes.dart';

import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable()
class ServerResponse {
  final int statusCode;
  final int reasonCode;
  final String? statusMessage;
  final Map<String, dynamic>? body;

  ServerResponse(
      {required this.statusCode,
      this.reasonCode = ReasonCodes.noReasonCode,
      this.statusMessage,
      this.body});

  factory ServerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerResponseToJson(this);
}
