// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import '/src/internal/relay_comms.dart'
    if (dart.library.js_interop) '/src/internal/relay_comms_web.dart';
import '/src/braincloud_client.dart';
import '/src/server_callback.dart';

class BrainCloudRelay {
  final BrainCloudClient _clientRef;
  late RelayComms _commsLayer;

  static final int toAllPlayers = 0x000000FFFFFFFFFF;
  static final int maxPlayers = 40;
  static final int channelHighPriority_1 = 0;
  static final int channelHighPriority_2 = 1;
  static final int channelNormalPriority = 2;
  static final int channelLowPriority = 3;

  BrainCloudRelay(RelayComms inComms, this._clientRef) {
    _commsLayer = inComms;
  }

  /// Use Ping() in order to properly calculate the Last ping received

  int getPing() => _commsLayer.getPing;

  /// et the lobby's owner profile Id.

  String get ownerProfileId => _commsLayer.getOwnerProfileId() ?? "";

  /// et the lobby's owner profile Id.

  String getOwnerProfileId() {
    return ownerProfileId;
  }

  /// Returns the profileId associated with a netId.

  String? getProfileIdForNetId(int netId) {
    return _commsLayer.getProfileIdForNetId(netId);
  }

  /// Returns the netId associated with a profileId.

  int getNetIdForProfileId(String profileId) {
    return _commsLayer.getNetIdForProfileId(profileId);
  }

  /// et the lobby's owner RTT connection Id.

  String get ownerCxId => _commsLayer.getOwnerCxId();

  /// et the lobby's owner profile Id.

  String getOwnerCxId() {
    return ownerCxId;
  }

  /// Returns the RTT connection Id associated with a netId.

  String getCxIdForNetId(int netId) {
    return _commsLayer.getCxIdForNetId(netId) ?? "";
  }

  /// Returns the netId associated with an RTT connection Id.

  int getNetIdForCxId(String cxId) {
    return _commsLayer.getNetIdForCxId(cxId);
  }

  /// Start off a connection, based off connection type to brainClouds Relay Servers.  Connect options come in from "ROOM_ASSIGNED" lobby callback

  /// Start a connection, based on connection type to
  /// brainClouds Relay Servers. Connect options come in
  /// from ROOM_ASSIGNED lobby callback.
  /// @param connectionType
  /// @param host
  /// @param port
  /// @param passcode
  /// @param lobbyId
  ///
  /// @return Future<ServerResponse>
  ///
  void connect(
      {required RelayConnectionType connectionType,
      required RelayConnectOptions options,
      SuccessCallback? onSuccess,
      FailureCallback? onFailure}) {
    // This cannot be converted to use Future as these callack can be called multiple times.
    _commsLayer.connect(connectionType, options, onSuccess, onFailure);
  }

  /// Disconnects from the relay server
  ///
  /// @return Future<ServerResponse>
  ///

  void disconnect() {
    _commsLayer.disconnect();
  }

  /// Terminate the match instance by the owner.

  /// Requests to end the current match on the relay server
  ///
  /// @return Future<ServerResponse>
  ///
  void endMatch({required Map<String, dynamic> payload}) {
    _commsLayer.endMatch(payload);
  }

  /// Is Connected

  bool isConnected() {
    return _commsLayer.isConnected;
  }

  /// Register callback for relay messages coming from peers.
  ///
  /// @return Future<ServerResponse>
  ///

  void registerRelayCallback(RelayCallback inCallback) {
    _commsLayer.registerRelayCallback(inCallback);
  }

  /// Deregister the relay callback

  void deregisterRelayCallback() {
    _commsLayer.deregisterRelayCallback();
  }

  /// Register callback for RelayServer system messages.
  ///
  /// @return Future<ServerResponse>
  ///

  void registerSystemCallback(RelaySystemCallback inCallback) {
    _commsLayer.registerSystemCallback(inCallback);
  }

  /// Deregister the relay callback

  void deregisterSystemCallback() {
    _commsLayer.deregisterSystemCallback();
  }

  /// Send a packet to peer(s)

  /// Send a packet to peer(s)
  ///
  /// @param data Byte array for the data to send
  /// @param size Size of data in bytes
  /// @param toNetId The net id to send to, TO_ALL_PLAYERS to relay to all.
  /// @param reliable Send this reliable or not.
  /// @param ordered Receive this ordered or not.
  /// @param channel One of: (CHANNEL_HIGH_PRIORITY_1, CHANNEL_HIGH_PRIORITY_2, CHANNEL_NORMAL_PRIORITY, CHANNEL_LOW_PRIORITY)
  /// @return Future<ServerResponse>
  ///

  void send(Uint8List data, int toNetid,
      {bool reliable = true, bool ordered = true, int channel = 0}) {
    if (toNetid == toAllPlayers) {
      sendToAll(data, reliable: reliable, ordered: ordered, inChannel: channel);
    } else if (toNetid >= maxPlayers) {
      // Error. Invalid net id
      String error = "Invalid NetId: $toNetid";
      _commsLayer.queueError(error);
    } else {
      int playerMask = (1 << toNetid);
      _commsLayer.send(data, playerMask, reliable, ordered, channel);
    }
  }

  /// Send a packet to any players by using a mask

  /// Send a packet to any players by using a mask
  ///
  /// @param data Byte array for the data to send
  /// @param size Size of data in bytes
  /// @param playerMask Mask of the players to send to. 0001 = netId 0, 0010 = netId 1, etc. If you pass ALL_PLAYER_MASK you will be included and you will get an echo for your message. Use sendToAll instead, you will be filtered out. You can manually filter out by : ALL_PLAYER_MASK &= ~(1 << myNetId)
  /// @param reliable Send this reliable or not.
  /// @param ordered Receive this ordered or not.
  /// @param channel One of: (CHANNEL_HIGH_PRIORITY_1, CHANNEL_HIGH_PRIORITY_2, CHANNEL_NORMAL_PRIORITY, CHANNEL_LOW_PRIORITY)
  /// @return Future<ServerResponse>
  ///

  void sendToPlayers(Uint8List data,
      {required int playerMask,
      bool reliable = true,
      bool ordered = true,
      int channel = 0}) {
    _commsLayer.send(data, playerMask, reliable, ordered, channel);
  }

  /// Send a packet to all except yourself

  /// Send a packet to all except yourself
  ///
  /// @param data Byte array for the data to send
  /// @param size Size of data in bytes
  /// @param reliable Send this reliable or not.
  /// @param ordered Receive this ordered or not.
  /// @param channel One of: (CHANNEL_HIGH_PRIORITY_1, CHANNEL_HIGH_PRIORITY_2, CHANNEL_NORMAL_PRIORITY, CHANNEL_LOW_PRIORITY)
  /// @return Future<ServerResponse>
  ///

  void sendToAll(Uint8List data,
      {bool reliable = true, bool ordered = true, int inChannel = 0}) {
    var myProfileId = _clientRef.authenticationService.profileId;
    var myNetId = getNetIdForProfileId(myProfileId!);

    int myBit = 1 << myNetId;
    int myInvertedBits = ~myBit;
    int playerMask = toAllPlayers & myInvertedBits;
    _commsLayer.send(data, playerMask, reliable, ordered, inChannel);
  }

  /// Set the ping interval. Ping allows to keep the connection
  /// alive, but also inform the player of his current ping.
  /// The default is 1 second interval.
  ///
  /// @return Future<ServerResponse>
  ///

  void setPingInterval(int inIntervalSec) {
    _commsLayer.setPingInterval(inIntervalSec);
  }
}

class RelayConnectOptions {
  bool ssl = true;
  String host;
  int port;
  String passcode;
  String lobbyId;

  RelayConnectOptions(
    this.ssl,
    this.host,
    this.port,
    this.passcode,
    this.lobbyId,
  );

  @override
  String toString() {
    return "RelayConnectOptions(ssl:$ssl, host:$host, port:$port, passcode:${passcode.isNotEmpty ? "**..**" : "<empty>"}, lobbyId:$lobbyId)";
  }
}
