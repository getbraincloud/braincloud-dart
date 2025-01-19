import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';
import '/src/util.dart';

class BrainCloudMatchMaking {
  final BrainCloudClient _clientRef;

  BrainCloudMatchMaking(this._clientRef);

  /// Read match making record
  ///
  /// Service Name - MatchMaking
  /// Service Operation - Read
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> read() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sets player rating
  ///
  /// Service Name - MatchMaking
  /// Service Operation - SetPlayerRating
  ///
  /// @param playerRating
  /// The new player rating.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> setPlayerRating({required int playerRating}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = playerRating;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.setPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Resets player rating
  ///
  /// Service Name - MatchMaking
  /// Service Operation - resetPlayerRating
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> resetPlayerRating() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.resetPlayerRating, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Increments player rating
  ///
  /// Service Name - MatchMaking
  /// Service Operation - incrementPlayerRating
  ///
  /// @param increment
  /// The increment amount
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> incrementPlayerRating({required int increment}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = increment;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.incrementPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Decrements player rating
  ///
  /// Service Name - MatchMaking
  /// Service Operation - decrementPlayerRating
  ///
  /// @param decrement
  /// The decrement amount
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> decrementPlayerRating({required int decrement}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServicePlayerRating.value] = decrement;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.decrementPlayerRating, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Turns shield on
  ///
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOn
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> turnShieldOn() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOn, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Turns shield on for the specified number of minutes
  ///
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOnFor
  ///
  /// @param minutes
  /// Number of minutes to turn the shield on for
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> turnShieldOnFor({required int minutes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceMinutes.value] = minutes;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOnFor, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Turns shield off
  ///
  /// Service Name - MatchMaking
  /// Service Operation - ShieldOff
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> turnShieldOff() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.shieldOff, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Increases the shield on time by specified number of minutes
  ///
  /// Service Name - MatchMaking
  /// Service Operation - IncrementShieldOnFor
  ///
  /// @param minutes
  /// Number of minutes to increase the shield time for
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> incrementShieldOnFor({required int minutes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceMinutes.value] = minutes;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );

    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.incrementShieldOnFor, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the shield expiry for the given player id. Passing in a null player id
  /// will return the shield expiry for the current player. The value returned is
  /// the time in UTC millis when the shield will expire.
  ///
  /// Service Name - MatchMaking
  /// Service Operation - getShieldExpiry
  ///
  /// @param playerId
  /// The player id or use null to retrieve for the current player
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getShieldExpiry({required String playerId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    if (Util.isOptionalParameterValid(playerId)) {
      data[OperationParam.matchMakingServicePlayerId.value] = playerId;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.getShieldExpiry, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds matchmaking enabled players
  ///
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS
  ///
  /// @param rangeDelta
  /// The range delta
  ///
  /// @param numMatches
  /// The maximum number of matches to return
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> findPlayers(
      {required int rangeDelta, required int numMatches}) {
    return findPlayersWithAttributes(
        rangeDelta: rangeDelta, numMatches: numMatches);
  }

  /// Finds matchmaking enabled players with additional attributes
  ///
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS
  ///
  /// @param rangeDelta
  /// The range delta
  ///
  /// @param numMatches
  /// The maximum number of matches to return
  ///
  /// @param jsonAttributes
  /// Attributes match criteria
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> findPlayersWithAttributes(
      {required int rangeDelta,
      required int numMatches,
      Map<String, dynamic>? jsonAttributes}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceRangeDelta.value] = rangeDelta;
    data[OperationParam.matchMakingServiceNumMatches.value] = numMatches;

    if (jsonAttributes != null) {
      Map<String, dynamic> attribs = jsonAttributes;
      data[OperationParam.matchMakingServiceAttributes.value] = attribs;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.matchMaking, ServiceOperation.findPlayers, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finds matchmaking enabled players using a cloud code filter
  ///
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS_USING_FILTER
  ///
  /// @param rangeDelta
  /// The range delta
  ///
  /// @param numMatches
  /// The maximum number of matches to return
  ///
  /// @param jsonExtraParms
  /// Parameters to pass to the CloudCode filter script
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> findPlayersUsingFilter(
      {required int rangeDelta,
      required int numMatches,
      Map<String, dynamic>? jsonExtraParms}) {
    return findPlayersWithAttributesUsingFilter(
        rangeDelta: rangeDelta,
        numMatches: numMatches,
        jsonExtraParms: jsonExtraParms);
  }

  /// Finds matchmaking enabled players using a cloud code filter
  /// and additional attributes
  ///
  /// Service Name - MatchMaking
  /// Service Operation - FIND_PLAYERS_USING_FILTER
  ///
  /// @param rangeDelta
  /// The range delta
  ///
  /// @param numMatches
  /// The maximum number of matches to return
  ///
  /// @param jsonAttributes
  /// Attributes match criteria
  ///
  /// @param jsonExtraParms
  /// Parameters to pass to the CloudCode filter script
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> findPlayersWithAttributesUsingFilter(
      {required int rangeDelta,
      required int numMatches,
      Map<String, dynamic>? jsonAttributes,
      Map<String, dynamic>? jsonExtraParms}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.matchMakingServiceRangeDelta.value] = rangeDelta;
    data[OperationParam.matchMakingServiceNumMatches.value] = numMatches;

    if (jsonAttributes != null) {
      data[OperationParam.matchMakingServiceAttributes.value] = jsonAttributes;
    }

    if (jsonExtraParms != null) {
      data[OperationParam.matchMakingServiceExtraParams.value] = jsonExtraParms;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.findPlayersUsingFilter, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Enables Match Making for the Player
  ///
  /// Service Name - MatchMaking
  /// Service Operation - EnableMatchMaking
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> enableMatchMaking() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.enableMatchMaking, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Disables Match Making for the Player
  ///
  /// Service Name - MatchMaking
  /// Service Operation - EnableMatchMaking
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> disableMatchMaking() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.matchMaking,
        ServiceOperation.disableMatchMaking, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
