// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';

import 'package:braincloud_dart/src/internal/relay_comms.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudRelay {
  final BrainCloudClient _clientRef;
  late RelayComms? _commsLayer;

  final int toAllPlayers = 0x000000FFFFFFFFFF;
  final int maxPlayers = 40;
  final int channelHighPriority_1 = 0;
  final int channelHighPriority_2 = 1;
  final int channelNormalPriority = 2;
  final int channelLowPriority = 3;

  BrainCloudRelay(RelayComms? inComms, this._clientRef) {
    _commsLayer = inComms;
  }

  /// <summary>
  /// Use Ping() in order to properly calculate the Last ping received
  /// </summary>
  int get lastPing => _commsLayer?.getPing ?? 0;

  /// <summary>
  /// et the lobby's owner profile Id.
  /// </summary>
  String get ownerProfileId => _commsLayer?.getOwnerProfileId() ?? "";

  /// <summary>
  /// et the lobby's owner profile Id.
  /// </summary>
  String getOwnerProfileId() {
    return ownerProfileId;
  }

  /// <summary>
  /// Returns the profileId associated with a netId.
  /// </summary>
  String? getProfileIdForNetId(int netId) {
    return _commsLayer?.GetProfileIdForNetId(netId);
  }

  /// <summary>
  /// Returns the netId associated with a profileId.
  /// </summary>
  int getNetIdForProfileId(String profileId) {
    return _commsLayer?.GetNetIdForProfileId(profileId) ?? 0;
  }

  /// <summary>
  /// et the lobby's owner RTT connection Id.
  /// </summary>
  String get ownerCxId => _commsLayer?.GetOwnerCxId() ?? "";

  /// <summary>
  /// et the lobby's owner profile Id.
  /// </summary>
  String getOwnerCxId() {
    return ownerCxId;
  }

  /// <summary>
  /// Returns the RTT connection Id associated with a netId.
  /// </summary>
  String getCxIdForNetId(int netId) {
    return _commsLayer?.GetCxIdForNetId(netId) ?? "";
  }

  /// <summary>
  /// Returns the netId associated with an RTT connection Id.
  /// </summary>
  int getNetIdForCxId(String cxId) {
    return _commsLayer?.GetNetIdForCxId(cxId) ?? 0;
  }

  /// <summary>
  /// Start off a connection, based off connection type to brainClouds Relay Servers.  Connect options come in from "ROOM_ASSIGNED" lobby callback
  /// </summary>
  /// <param name="in_connectionType"></param>
  /// <param name="in_options"></param>
  /// <param name="in_success"></param>
  /// <param name="in_failure"></param>
  /// <param name="cb_object"></param>
  void connect(
      RelayConnectionType inConnectiontype,
      RelayConnectOptions inOptions,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure,
      dynamic cbObject) {
    _commsLayer?.Connect(
        inConnectiontype, inOptions, inSuccess, inFailure, cbObject);
  }

  /// <summary>
  /// Disables relay event for this session.
  /// </summary>
  void disconnect() {
    _commsLayer?.disconnect();
  }

  /// <summary>
  /// Terminate the match instance by the owner.
  /// </summary>
  /// <param name="json">payload data sent in JSON format. It will be relayed to other connnected players.</param>
  void endMatch(Map<String, dynamic> json) {
    _commsLayer?.EndMatch(json);
  }

  /// <summary>
  /// Is Connected
  /// </summary>
  bool isConnected() {
    return _commsLayer?.isConnected ?? false;
  }

  /// <summary>
  /// Register callback for relay messages coming from peers on the main thread
  /// </summary>
  void registerRelayCallback(RelayCallback inCallback) {
    _commsLayer?.registerRelayCallback(inCallback);
  }

  /// <summary>
  /// Deregister the relay callback
  /// </summary>
  void deregisterRelayCallback() {
    _commsLayer?.deregisterRelayCallback();
  }

  /// <summary>
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
  /// </summary>
  void registerSystemCallback(RelaySystemCallback inCallback) {
    _commsLayer?.registerSystemCallback(inCallback);
  }

  /// <summary>
  /// Deregister the relay callback
  /// </summary>
  void deregisterSystemCallback() {
    _commsLayer?.deregisterSystemCallback();
  }

  /// <summary>
  /// Send a packet to peer(s)
  /// </summary>
  /// <param in_data="message to be sent"></param>
  /// <param to_netId="the net id to send to, BrainCloudRelay.TO_ALL_PLAYERS to relay to all"></param>
  /// <param in_reliable="send this reliably or not"></param>
  /// <param in_ordered="received this ordered or not"></param>
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;
  /// </param>
  void send(Uint8List inData, int toNetid,
      {bool inReliable = true, bool inOrdered = true, int inChannel = 0}) {
    if (toNetid == toAllPlayers) {
      sendToAll(
          inData: inData,
          inReliable: inReliable,
          inOrdered: inOrdered,
          inChannel: inChannel);
    } else if (toNetid >= maxPlayers) {
      // Error. Invalid net id
      String error = "Invalid NetId: $toNetid";
      _commsLayer?.queueError(error);
    } else {
      int playerMask = 1 << toNetid;
      _commsLayer?.send(inData, playerMask, inReliable, inOrdered, inChannel);
    }
  }

  /// <summary>
  /// Send a packet to any players by using a mask
  /// </summary>
  /// <param in_data="message to be sent"></param>
  /// <param in_playerMask="Mask of the players to send to. 0001 = netId 0, 0010 = netId 1, etc. If you pass ALL_PLAYER_MASK you will be included and you will get an echo for your message. Use sendToAll instead, you will be filtered out. You can manually filter out by : ALL_PLAYER_MASK &= ~(1 << myNetId)"></param>
  /// <param in_reliable="send this reliably or not"></param>
  /// <param in_ordered="received this ordered or not"></param>
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;
  /// </param>
  void sendToPlayers(
      {required inData,
      required inPlayerMask,
      bool inReliable = true,
      bool inOrdered = true,
      int inChannel = 0}) {
    _commsLayer?.send(inData, inPlayerMask, inReliable, inOrdered, inChannel);
  }

  /// <summary>
  /// Send a packet to all except yourself
  /// </summary>
  /// <param in_data="message to be sent"></param>
  /// <param in_reliable="send this reliably or not"></param>
  /// <param in_ordered="received this ordered or not"></param>
  /// <param in_channel="0,1,2,3 (max of four channels)">
  /// CHANNEL_HIGH_PRIORITY_1 = 0;
  /// CHANNEL_HIGH_PRIORITY_2 = 1;
  /// CHANNEL_NORMAL_PRIORITY = 2;
  /// CHANNEL_LOW_PRIORITY = 3;
  /// </param>
  void sendToAll(
      {required inData,
      bool inReliable = true,
      bool inOrdered = true,
      int inChannel = 0}) {
    var myProfileId = _clientRef.authenticationService?.profileId;
    var myNetId = getNetIdForProfileId(myProfileId!);

    int myBit = 1 << myNetId;
    int myInvertedBits = ~myBit;
    int playerMask = toAllPlayers & myInvertedBits;
    _commsLayer?.send(inData, playerMask, inReliable, inOrdered, inChannel);
  }

  /// <summary>
  /// Set the ping interval.
  /// </summary>
  void setPingInterval(int inInterval) {
    _commsLayer?.setPingInterval(inInterval);
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
}
