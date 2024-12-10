import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudBlockchain {
  final BrainCloudClient _clientRef;

  BrainCloudBlockchain(this._clientRef);

  /// Retrieves the blockchain items owned by the caller.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getBlockchainItems(
      {String? integrationId, Map<String, dynamic>? contextJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};

    data[OperationParam.blockChainIntegrationId.value] =
        integrationId ?? "default";
    data[OperationParam.blockChainContext.value] = contextJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.blockChain,
        ServiceOperation.getBlockchainItems, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the uniqs owned by the caller.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getUniqs(
      {required String integrationId, Map<String, dynamic>? contextJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};

    data[OperationParam.blockChainIntegrationId.value] = integrationId;
    data[OperationParam.blockChainContext.value] = contextJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.blockChain, ServiceOperation.getUniqs, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
