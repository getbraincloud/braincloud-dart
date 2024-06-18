import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudVirtualCurrency {
  final BrainCloudClient _clientRef;

  BrainCloudVirtualCurrency(this._clientRef);

  /// <summary>
  /// Gets the player's currency for the given currency type
  /// or all currency types if null passed in.
  /// </summary>
  /// <remarks>
  /// Service Name - VirtalCurrency
  /// Service Operation - GetPlayerVC
  /// </remarks>
  /// <param name="currencyType">
  /// The currency type to retrieve or null
  /// if all currency types are being requested.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getCurrency(String currencyType, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.VirtualCurrencyServiceCurrencyId.Value] = currencyType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.VirtualCurrency,
        ServiceOperation.getPlayerVC, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the parents's currency for the given currency type
  /// or all currency types if null passed in.
  /// </summary>
  /// <remarks>
  /// Service Name - VirtalCurrency
  /// Service Operation - GetParentVC
  /// </remarks>
  /// <param name="currencyType">
  /// The currency type to retrieve or null
  /// if all currency types are being requested.
  /// </param>
  /// <param name="levelName">
  /// The parent level name
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getParentCurrency(String currencyType, String levelName,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.VirtualCurrencyServiceCurrencyId.Value] = currencyType;
    data[OperationParam.AuthenticateServiceAuthenticateLevelName.Value] =
        levelName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.VirtualCurrency,
        ServiceOperation.getParentVC, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the peers's currency for the given currency type
  /// or all currency types if null passed in.
  /// </summary>
  /// <remarks>
  /// Service Name - VirtalCurrency
  /// Service Operation - GetPeerVC
  /// </remarks>
  /// <param name="currencyType">
  /// The currency type to retrieve or null
  /// if all currency types are being requested.
  /// </param>
  /// <param name="peerCode">
  /// The peer code
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getPeerCurrency(String currencyType, String peerCode,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.VirtualCurrencyServiceCurrencyId.Value] = currencyType;
    data[OperationParam.AuthenticateServiceAuthenticatePeerCode.Value] =
        peerCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.VirtualCurrency,
        ServiceOperation.getPeerVC, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Resets player currency to zero
  /// </summary>
  /// <remarks>
  /// Service Name - VirtalCurrency
  /// Service Operation - ResetCurrency
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void resetCurrency(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.VirtualCurrency,
        ServiceOperation.resetPlayerVC, data, callback);
    _clientRef.sendRequest(sc);
  }
}
