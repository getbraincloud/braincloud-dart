import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudVirtualCurrency {
  final BrainCloudClient _clientRef;

  BrainCloudVirtualCurrency(this._clientRef);

  /// Gets the player's currency for the given currency type
  /// or all currency types if null passed in.

  /// Service Name - VirtalCurrency
  /// Service Operation - GetPlayerVC

  /// @param currencyType
  /// The currency type to retrieve or null
  /// if all currency types are being requested.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getCurrency({required String currencyType}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = currencyType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getPlayerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the parents's currency for the given currency type
  /// or all currency types if null passed in.

  /// Service Name - VirtalCurrency
  /// Service Operation - GetParentVC

  /// @param currencyType
  /// The currency type to retrieve or null
  /// if all currency types are being requested.

  /// @param levelName
  /// The parent level name

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getParentCurrency(
      {required String currencyType, required String levelName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = currencyType;
    data[OperationParam.authenticateServiceAuthenticateLevelName.value] =
        levelName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getParentVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the peers's currency for the given currency type
  /// or all currency types if null passed in.

  /// Service Name - VirtalCurrency
  /// Service Operation - GetPeerVC

  /// @param currencyType
  /// The currency type to retrieve or null
  /// if all currency types are being requested.

  /// @param peerCode
  /// The peer code

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getPeerCurrency(
      {required String currencyType, required String peerCode}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = currencyType;
    data[OperationParam.authenticateServiceAuthenticatePeerCode.value] =
        peerCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getPeerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Resets player currency to zero

  /// Service Name - VirtalCurrency
  /// Service Operation - ResetCurrency

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetCurrency() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.resetPlayerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
