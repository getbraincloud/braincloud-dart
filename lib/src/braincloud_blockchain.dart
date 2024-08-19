import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudBlockchain {
  final BrainCloudClient _clientRef;

  BrainCloudBlockchain(this._clientRef);

  /// <summary>
  /// Retrieves the blockchain items owned by the caller.
  /// </summary>
  void getBlockchainItems(
      String? inIntegrationid,
      String? inContextjson,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure,
      dynamic inCbobject) {
    var context = jsonDecode(inContextjson ?? "{}");
    Map<String, dynamic> data = {};

    data[OperationParam.blockChainIntegrationId.value] =
        inIntegrationid ?? "default";
    data[OperationParam.blockChainContext.value] = context;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        inSuccess, inFailure,
        cbObject: inCbobject);
    ServerCall sc = ServerCall(ServiceName.blockChain,
        ServiceOperation.getBlockchainItems, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the uniqs owned by the caller.
  /// </summary>
  void getUniqs(
      String inIntegrationid,
      String inContextjson,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure,
      dynamic inCbobject) {
    var context = jsonDecode(inContextjson);
    Map<String, dynamic> data = {};

    data[OperationParam.blockChainIntegrationId.value] = inIntegrationid;
    data[OperationParam.blockChainContext.value] = context;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        inSuccess, inFailure,
        cbObject: inCbobject);
    ServerCall sc = ServerCall(
        ServiceName.blockChain, ServiceOperation.getUniqs, data, callback);
    _clientRef.sendRequest(sc);
  }
}
