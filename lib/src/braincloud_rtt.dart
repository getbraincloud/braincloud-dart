import 'dart:async';

import 'package:braincloud_dart/src/internal/rtt_comms.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:flutter/foundation.dart';

class BrainCloudRTT {
  final BrainCloudClient? _clientRef;
  final RTTComms? _commsLayer;

  BrainCloudRTT(this._commsLayer, this._clientRef);

  /// Enables Real Time event for this session.
  /// Real Time events are disabled by default. Usually events
  /// need to be polled using GET_EVENTS. By enabling this, events will
  /// be received instantly when they happen through a TCP connection to an Event Server.
  ///
  ///This function will first call requestClientConnection, then connect to the address
  ///
  /// @param in_connectionType
  ///
  /// returns Future<RTTCommandResponse>
  Future<RTTCommandResponse> enableRTT({RTTConnectionType? connectiontype}) {
    Completer<RTTCommandResponse> completer = Completer();
    _commsLayer?.enableRTT(connectiontype ?? RTTConnectionType.websocket,
        (response) {
      completer.complete(response);
    }, (response) {
      /// TODO: This need to be refactor as the error callback can be called 
      /// at a later time after the success callback as already been called.
      /// For this reason this cannot use a Future style return.
      // if (completer.isCompleted) debugPrint("BrainCloudRTT: enableRTT already completed and need to return error $response");
      // else 
      completer.complete(response);
    });

    return completer.future;
  }

  /// Disables Real Time event for this session.
  void disableRTT() {
    _commsLayer?.disableRTT();
  }

  /// Returns true if RTT is enabled
  bool isRTTEnabled() {
    return _commsLayer?.isRTTEnabled() ?? false;
  }

  /// Returns rtt connectionstatus
  RTTConnectionStatus? getConnectionStatus() {
    return _commsLayer?.getConnectionStatus();
  }

  ///
  void registerRTTEventCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.event, inCallback);
  }

  ///
  void deregisterRTTEventCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.event);
  }

  ///
  void registerRTTChatCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.chat, inCallback);
  }

  ///
  void deregisterRTTChatCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.chat);
  }

  ///
  void registerRTTPresenceCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.presence, inCallback);
  }

  void deregisterRTTPresenceCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.presence);
  }

  void registerRTTMessagingCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.messaging, inCallback);
  }

  void deregisterRTTMessagingCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.messaging);
  }

  void registerRTTLobbyCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.lobby, inCallback);
  }

  void deregisterRTTLobbyCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.lobby);
  }

  void registerRTTAsyncMatchCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.asyncMatch, inCallback);
  }

  void registerRTTBlockchainRefresh(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.userItems, inCallback);
  }

  void deregisterRTTBlockchainRefresh() {
    _commsLayer?.deregisterRTTCallback(ServiceName.userItems);
  }

  void registerRTTBlockchainItemEvent(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.blockChain, inCallback);
  }

  void deregisterRTTBlockchainItemEvent() {
    _commsLayer?.deregisterRTTCallback(ServiceName.blockChain);
  }

  void deregisterRTTAsyncMatchCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.asyncMatch);
  }

  void deregisterAllRTTCallbacks() {
    _commsLayer?.deregisterAllRTTCallbacks();
  }

  void setRTTHeartBeatSeconds(int inValue) {
    _commsLayer?.setRTTHeartBeatSeconds(inValue);
  }

  /// Requests the event server address
  void requestClientConnection(
      SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.rttRegistration,
        ServiceOperation.requestClientConnection, null, callback);
    _clientRef?.sendRequest(sc);
  }

  ///
  String? getRTTConnectionID() {
    return _commsLayer?.rttConnectionID;
  }
}
