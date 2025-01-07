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

  /// Award user the passed-in amount of currency. Returns an object 
  /// representing the new currency values.
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - AWARD_VC
  ///
  /// @param vcId
  /// The currency type to retrieve or null
  ///
  /// @param vcAmount	
  /// The amount of currency to award.
  /// 
  /// if all currency types are being requested.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> awardCurrency({required String vcId, required int vcAmount}) {
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
        ServiceOperation.awardVC, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
  /// Consume the passed-in amount of currency from the player.
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - CONSUME_VC
  ///
  /// @param currencyType
  /// The currency type to retrieve or null
  ///
  /// if all currency types are being requested.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> consumeCurrency({required String vcId, required int vcAmount}) {
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
  /// Gets the player's currency for the given currency type
  /// or all currency types if null passed in.
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - GetPlayerVC
  ///
  /// @param currencyType
  /// The currency type to retrieve or null
  ///
  /// if all currency types are being requested.
  ///
  /// returns Future<ServerResponse>
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

  /// Gets the parents's currency for the given currency type
  /// or all currency types if null passed in.
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - GetParentVC
  ///
  /// @param currencyType
  /// The currency type to retrieve or null
  /// if all currency types are being requested.
  ///
  /// @param levelName
  /// The parent level name
  ///
  /// returns Future<ServerResponse>
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

  /// Gets the peers's currency for the given currency type
  /// or all currency types if null passed in.
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - GetPeerVC
  ///
  /// @param currencyType
  /// The currency type to retrieve or null
  /// if all currency types are being requested.
  ///
  /// @param peerCode
  /// The peer code
  ///
  /// returns Future<ServerResponse>
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

  /// Resets player currency to zero
  ///
  /// Service Name - VirtalCurrency
  /// Service Operation - ResetCurrency
  ///
  /// returns Future<ServerResponse>
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
