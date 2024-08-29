import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudRedemptionCode {
  final BrainCloudClient _clientRef;

  BrainCloudRedemptionCode(this._clientRef);

  /// <summary>
  /// Redeem a code.
  /// </summary>
  /// <remarks>
  /// Service Name - redemptionCode
  /// Service Operation - REDEEM_CODE
  /// </remarks>
  /// <param name="scanCode">
  /// The code to redeem
  /// </param>
  /// <param name="codeType">
  /// The type of code
  /// </param>
  /// <param name="jsonCustomRedemptionInfo">
  /// Optional - A JSON String containing custom redemption data
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void redeemCode(
      String scanCode,
      String codeType,
      String jsonCustomRedemptionInfo,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.redemptionCodeServiceScanCode.value] = scanCode;
    data[OperationParam.redemptionCodeServiceCodeType.value] = codeType;

    if (Util.isOptionalParameterValid(jsonCustomRedemptionInfo)) {
      Map<String, dynamic> customRedemptionInfo =
          jsonDecode(jsonCustomRedemptionInfo);
      data[OperationParam.redemptionCodeServiceCustomRedemptionInfo.value] =
          customRedemptionInfo;
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.redemptionCode,
        ServiceOperation.redeemCode, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve the codes already redeemed by player.
  /// </summary>
  /// <remarks>
  /// Service Name - redemptionCode
  /// Service Operation - GET_REDEEMED_CODES
  /// </remarks>
  /// <param name="codeType">
  /// Optional - The type of codes to retrieve. Returns all codes if left unspecified.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getRedeemedCodes(
      String codeType, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(codeType)) {
      data = {};
      data[OperationParam.redemptionCodeServiceCodeType.value] = codeType;
    }

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.redemptionCode,
        ServiceOperation.getRedeemedCodes, data, callback);
    _clientRef.sendRequest(sc);
  }
}
