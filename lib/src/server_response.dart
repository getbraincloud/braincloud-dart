import '/src/reason_codes.dart';
import '/src/status_codes.dart';

import 'package:json_annotation/json_annotation.dart';

part 'server_response.g.dart';

@JsonSerializable()
class ServerResponse {
  @JsonKey(name: 'status')
  final int statusCode;
  @JsonKey(name: 'reason_code')
  final int? reasonCode;
  @JsonKey(name: 'status_message')
  final dynamic error;
  @JsonKey(name: 'data')
  final Map<String, dynamic>? data;

  ServerResponse(
      {required this.statusCode,
      this.reasonCode = ReasonCodes.noReasonCode,
      this.error,
      this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) =>
      _$ServerResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ServerResponseToJson(this);

  @override
  String toString() {
    return 'ServerResponse(statusCode: $statusCode, reasonCode: $reasonCode, statusMessage: $error, data: ${(data?.isNotEmpty ?? false) ? '<Has Data>' : '<Data is empty>'})';
  }

  bool isSuccess() => statusCode == StatusCodes.ok;
}
