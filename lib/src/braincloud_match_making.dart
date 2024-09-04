import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudMatchMaking {
  final BrainCloudClient _clientRef;

  BrainCloudMatchMaking(this._clientRef);

  /// <summary>
  /// Read match making record
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - Read
  /// </remarks>
  Future<ServerResponse> read() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sets player rating
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - SetPlayerRating
  /// </remarks>
  /// <param name="playerRating">
  /// The new player rating.
  /// </param>
  Future<ServerResponse> setPlayerRating({required int playerRating}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = playerRating;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.setPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Resets player rating
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - resetPlayerRating
  /// </remarks>
  Future<ServerResponse> resetPlayerRating() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.resetPlayerRating, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Increments player rating
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - incrementPlayerRating
  /// </remarks>
  /// <param name="increment">
  /// The increment amount
  /// </param>
  Future<ServerResponse> incrementPlayerRating({required int increment}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = increment;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.incrementPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Decrements player rating
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - decrementPlayerRating
  /// </remarks>
  /// <param name="decrement">
  /// The decrement amount
  /// </param>
  Future<ServerResponse> decrementPlayerRating({required int decrement}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = decrement;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.decrementPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Turns shield on
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOn
  /// </remarks>
  Future<ServerResponse> turnShieldOn() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOn, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Turns shield on for the specified number of minutes
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOnFor
  /// </remarks>
  /// <param name="minutes">
  /// Number of minutes to turn the shield on for
  /// </param>
  Future<ServerResponse> turnShieldOnFor({required int minutes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceMinutes.value] = minutes;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOnFor, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Turns shield off
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOff
  /// </remarks>
  Future<ServerResponse> turnShieldOff() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOff, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Increases the shield on time by specified number of minutes
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - IncrementShieldOnFor
  /// </remarks>
  /// <param name="minutes">
  /// Number of minutes to increase the shield time for
  /// </param>
  Future<ServerResponse> incrementShieldOnFor({required int minutes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceMinutes.value] = minutes;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );

    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.incrementShieldOnFor, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Gets the shield expiry for the given player id. Passing in a null player id
  /// will return the shield expiry for the current player. The value returned is
  /// the time in UTC millis when the shield will expire.
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - getShieldExpiry
  /// </remarks>
  /// <param name="playerId">
  /// The player id or use null to retrieve for the current player
  /// </param>
  Future<ServerResponse> getShieldExpiry({required String playerId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    if (Util.isOptionalParameterValid(playerId)) {
      data[OperationParam.matchMakingServicePlayerId.value] = playerId;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.getShieldExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Finds matchmaking enabled players
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS
  /// </remarks>
  /// <param name="rangeDelta">
  /// The range delta
  /// </param>
  /// <param name="numMatches">
  /// The maximum number of matches to return
  /// </param>
  Future<ServerResponse> findPlayers(
      {required int rangeDelta, required int numMatches}) {
    return findPlayersWithAttributes(
        rangeDelta: rangeDelta, numMatches: numMatches, jsonAttributes: "");
  }

  /// <summary>
  /// Finds matchmaking enabled players with additional attributes
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS
  /// </remarks>
  /// <param name="rangeDelta">
  /// The range delta
  /// </param>
  /// <param name="numMatches">
  /// The maximum number of matches to return
  /// </param>
  /// <param name="jsonAttributes">
  /// Attributes match criteria
  /// </param>
  Future<ServerResponse> findPlayersWithAttributes(
      {required int rangeDelta,
      required int numMatches,
      required String jsonAttributes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceRangeDelta.value] = rangeDelta;
    data[OperationParam.matchMakingServiceNumMatches.value] = numMatches;

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> attribs = jsonDecode(jsonAttributes);
      data[OperationParam.matchMakingServiceAttributes.value] = attribs;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.findPlayers, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Finds matchmaking enabled players using a cloud code filter
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS_USING_FILTER
  /// </remarks>
  /// <param name="rangeDelta">
  /// The range delta
  /// </param>
  /// <param name="numMatches">
  /// The maximum number of matches to return
  /// </param>
  /// <param name="jsonExtraParms">
  /// Parameters to pass to the CloudCode filter script
  /// </param>
  Future<ServerResponse> findPlayersUsingFilter(
      {required int rangeDelta,
      required int numMatches,
      required String jsonExtraParms}) {
    return findPlayersWithAttributesUsingFilter(
        rangeDelta: rangeDelta,
        numMatches: numMatches,
        jsonAttributes: "",
        jsonExtraParms: jsonExtraParms);
  }

  /// <summary>
  /// Finds matchmaking enabled players using a cloud code filter
  /// and additional attributes
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS_USING_FILTER
  /// </remarks>
  /// <param name="rangeDelta">
  /// The range delta
  /// </param>
  /// <param name="numMatches">
  /// The maximum number of matches to return
  /// </param>
  /// <param name="jsonAttributes">
  /// Attributes match criteria
  /// </param>
  /// <param name="jsonExtraParms">
  /// Parameters to pass to the CloudCode filter script
  /// </param>
  Future<ServerResponse> findPlayersWithAttributesUsingFilter(
      {required int rangeDelta,
      required int numMatches,
      required String jsonAttributes,
      required String jsonExtraParms}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceRangeDelta.value] = rangeDelta;
    data[OperationParam.matchMakingServiceNumMatches.value] = numMatches;

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> attribs = jsonDecode(jsonAttributes);
      data[OperationParam.matchMakingServiceAttributes.value] = attribs;
    }

    if (Util.isOptionalParameterValid(jsonExtraParms)) {
      Map<String, dynamic> extraParms = jsonDecode(jsonExtraParms);
      data[OperationParam.matchMakingServiceExtraParams.value] = extraParms;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.findPlayersUsingFilter, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Enables Match Making for the Player
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - EnableMatchMaking
  /// </remarks>
  Future<ServerResponse> enableMatchMaking() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.enableMatchMaking, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Disables Match Making for the Player
  /// </summary>
  /// <remarks>
  /// Service Name - MatchMaking
  /// Service Operation - EnableMatchMaking
  /// </remarks>
  Future<ServerResponse> disableMatchMaking() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.disableMatchMaking, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
