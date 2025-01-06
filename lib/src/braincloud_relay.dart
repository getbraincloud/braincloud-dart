// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:braincloud_dart/src/internal/relay_comms.dart' if (dart.library.js_interop) 'package:braincloud_dart/src/internal/relay_comms_web.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';


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

  /// @param in_connectionType
  /// @param in_options
  void connect(
      {required RelayConnectionType connectionType,      
      required RelayConnectOptions options,
      SuccessCallback? onSuccess,
      FailureCallback? onFailure}) {
      // This cannot be converted to use Future as these callack can be called multiple times.
    _commsLayer.connect(connectionType, options, onSuccess, onFailure);
  }

  /// Disables relay event for this session.

  void disconnect() {
    _commsLayer.disconnect();
  }

  /// Terminate the match instance by the owner.

  /// @param jsonpayload data sent in JSON format. It will be relayed to other connnected players.
  void endMatch({required Map<String, dynamic> payload}) {
    _commsLayer.endMatch(payload);
  }

  /// Is Connected

  bool isConnected() {
    return _commsLayer.isConnected;
  }

  /// Register callback for relay messages coming from peers on the main thread

  void registerRelayCallback(RelayCallback inCallback) {
    _commsLayer.registerRelayCallback(inCallback);
  }

  /// Deregister the relay callback

  void deregisterRelayCallback() {
    _commsLayer.deregisterRelayCallback();
  }

  /// Register callback for RelayServer system messages.
  ///
  /// # CONNECT
  /// Received when a new member connects to the server.
  /// {
  ///   op: "CONNECT",
  ///   profileId: "...",
  ///   ownerId: "...",
  ///   netId: #
  /// }
  ///
  /// # NET_ID
  /// Receive the Net Id assossiated with a profile Id. This is
  /// sent for each already connected members once you
  /// successfully connected.
  /// {
  ///   op: "NET_ID",
  ///   profileId: "...",
  ///   netId: #
  /// }
  ///
  /// # DISCONNECT
  /// Received when a member disconnects from the server.
  /// {
  ///   op: "DISCONNECT",
  ///   profileId: "..."
  /// }
  ///
  /// # MIGRATE_OWNER
  /// If the owner left or never connected in a timely manner,
  /// the relay-server will migrate the role to the next member
  /// with the best ping. If no one else is currently connected
  /// yet, it will be transferred to the next member in the
  /// lobby members' list. This last scenario can only occur if
  /// the owner connected first, then quickly disconnected.
  /// Leaving only unconnected lobby members.
  /// {
  ///   op: "MIGRATE_OWNER",
  ///   profileId: "..."
  /// }

  void registerSystemCallback(RelaySystemCallback inCallback) {
    _commsLayer.registerSystemCallback(inCallback);
  }

  /// Deregister the relay callback

  void deregisterSystemCallback() {
    _commsLayer.deregisterSystemCallback();
  }

  /// Send a packet to peer(s)

  /// <param in_data="message to be sent">
  /// <param to_netId="the net id to send to, BrainCloudRelay.TO_ALL_PLAYERS to relay to all">
  /// <param in_reliable="send this reliably or not">
  /// <param in_ordered="received this ordered or not">
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;

  void send(Uint8List data, int toNetid,
      {bool reliable = true, bool ordered = true, int channel = 0}) {
    if (toNetid == toAllPlayers) {
      sendToAll(
          data,
          reliable: reliable,
          ordered: ordered,
          inChannel: channel);
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

  /// <param in_data="message to be sent">
  /// <param in_playerMask="Mask of the players to send to. 0001 = netId 0, 0010 = netId 1, etc. If you pass ALL_PLAYER_MASK you will be included and you will get an echo for your message. Use sendToAll instead, you will be filtered out. You can manually filter out by : ALL_PLAYER_MASK &= ~(1 << myNetId)">
  /// <param in_reliable="send this reliably or not">
  /// <param in_ordered="received this ordered or not">
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;

  void sendToPlayers(
      Uint8List data,
      {required int playerMask,
      bool reliable = true,
      bool ordered = true,
      int channel = 0}) {
    _commsLayer.send(data, playerMask, reliable, ordered, channel);
  }

  /// Send a packet to all except yourself

  /// <param in_data="message to be sent">
  /// <param in_reliable="send this reliably or not">
  /// <param in_ordered="received this ordered or not">
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;

  void sendToAll(
      Uint8List data,
      {bool reliable = true,
      bool ordered = true,
      int inChannel = 0}) {
    var myProfileId = _clientRef.authenticationService.profileId;
    var myNetId = getNetIdForProfileId(myProfileId!);

    int myBit = 1 << myNetId;
    int myInvertedBits = ~myBit;
    int playerMask = toAllPlayers & myInvertedBits;
    _commsLayer.send(data, playerMask, reliable, ordered, inChannel);
  }

  /// Set the ping interval in Seconds

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
