// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudVirtualCurrency {
  final BrainCloudClient _clientRef;

  BrainCloudVirtualCurrency(this._clientRef);

  /// @warning Method is recommended to be used in Cloud Code only for security
  /// If you need to use it client side, enable 'Allow Currency Calls from Client' on the brainCloud dashboard
  ///
  /// @param in_currencyType The currency type to award
  /// @param in_amount The amount to award
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> awardCurrency(
      {required String vcId, required int vcAmount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = vcId;
    data[OperationParam.virtualCurrencyServiceCurrencyAmount.value] = vcAmount;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.virtualCurrency, ServiceOperation.awardVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// @warning Method is recommended to be used in Cloud Code only for security
  /// If you need to use it client side, enable 'Allow Currency Calls from Client' on the brainCloud dashboard
  ///
  /// @param in_currencyType The currency type to consume
  /// @param in_amount The amount to consume
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> consumeCurrency(
      {required String vcId, required int vcAmount}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = vcId;
    data[OperationParam.virtualCurrencyServiceCurrencyAmount.value] = vcAmount;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.consumePlayerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the user's currency account. Optional parameter: `in_vcId` (if retrieving a specific currency).
  /// Service Name - VirtualCurrency
  /// Service Operation - GetCurrency
  ///
  /// @param in_vcId Optional currency id to retrieve (pass NULL to get all currencies)
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> getCurrency({required String vcId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = vcId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getPlayerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the parent user's currency account. Optional parameter: `in_vcId` (if retrieving a specific currency).
  /// Service Name - VirtualCurrency
  /// Service Operation - GetParentCurrency
  ///
  /// @param in_vcId Optional currency id to retrieve (pass NULL to get all currencies)
  /// @param in_levelName The parent level name
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> getParentCurrency(
      {required String vcId, required String levelName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = vcId;
    data[OperationParam.authenticateServiceAuthenticateLevelName.value] =
        levelName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getParentVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the peer user's currency account. Optional parameter: `in_vcId` (if retrieving a specific currency).
  /// Service Name - VirtualCurrency
  /// Service Operation - GetPeerCurrency
  ///
  /// @param in_vcId Optional currency id to retrieve (pass NULL to get all currencies)
  /// @param in_peerCode The peer code identifying the other user
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> getPeerCurrency(
      {required String vcId, required String peerCode}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.virtualCurrencyServiceCurrencyId.value] = vcId;
    data[OperationParam.authenticateServiceAuthenticatePeerCode.value] =
        peerCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.getPeerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Reset player's currency to zero
  /// Service Name - VirtualCurrency
  /// Service Operation - ResetCurrency
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> resetCurrency() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.virtualCurrency,
        ServiceOperation.resetPlayerVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
