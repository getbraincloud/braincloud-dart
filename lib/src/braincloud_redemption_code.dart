import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudRedemptionCode {
  final BrainCloudClient _clientRef;

  BrainCloudRedemptionCode(this._clientRef);

  /// Redeem a code.
  ///
  /// Service Name - redemptionCode
  /// Service Operation - REDEEM_CODE
  ///
  /// @param scanCode
  /// The code to redeem
  ///
  /// @param codeType
  /// The type of code
  ///
  /// @param jsonCustomRedemptionInfo
  /// Optional - A JSON String containing custom redemption data
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> redeemCode(
      {required String scanCode,
      required String codeType,
      Map<String, dynamic>? customRedemptionInfo}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.redemptionCodeServiceScanCode.value] = scanCode;
    data[OperationParam.redemptionCodeServiceCodeType.value] = codeType;

    if (customRedemptionInfo != null) {
      data[OperationParam.redemptionCodeServiceCustomRedemptionInfo.value] =
          customRedemptionInfo;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.redemptionCode,
        ServiceOperation.redeemCode, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the codes already redeemed by player.
  ///
  /// Service Name - redemptionCode
  /// Service Operation - GET_REDEEMED_CODES
  ///
  /// @param codeType
  /// Optional - The type of codes to retrieve. Returns all codes if left unspecified.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getRedeemedCodes({required String codeType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(codeType)) {
      data = {};
      data[OperationParam.redemptionCodeServiceCodeType.value] = codeType;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.redemptionCode,
        ServiceOperation.getRedeemedCodes, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
