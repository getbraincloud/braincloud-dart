import 'package:braincloud_dart/src/internal/rtt_comms.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudRTT {
  final BrainCloudClient? _clientRef;
  final RTTComms? _commsLayer;

  BrainCloudRTT(this._commsLayer, this._clientRef);

  /// <summary>
  /// Enables Real Time event for this session.
  /// Real Time events are disabled by default. Usually events
  /// need to be polled using GET_EVENTS. By enabling this, events will
  /// be received instantly when they happen through a TCP connection to an Event Server.
  ///
  ///This function will first call requestClientConnection, then connect to the address
  /// </summary>
  /// <param name="in_connectionType"></param>
  /// <param name="in_success"></param>
  /// <param name="in_failure"></param>
  /// <param name="cb_object"></param>
  void enableRTT(
      RTTConnectionType? inConnectiontype,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure,
      dynamic cbObject) {
    _commsLayer?.enableRTT(inConnectiontype ?? RTTConnectionType.websocket,
        inSuccess, inFailure, cbObject);
  }

  /// <summary>
  /// Disables Real Time event for this session.
  /// </summary>
  void disableRTT() {
    _commsLayer?.disableRTT();
  }

  /// <summary>
  /// Returns true if RTT is enabled
  /// </summary>
  bool isRTTEnabled() {
    return _commsLayer?.isRTTEnabled() ?? false;
  }

  /// <summary>
  /// Returns rtt connectionstatus
  /// </summary>
  RTTConnectionStatus? getConnectionStatus() {
    return _commsLayer?.getConnectionStatus();
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTEventCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.event, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTEventCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.event);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTChatCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.chat, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTChatCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.chat);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTPresenceCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.presence, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTPresenceCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.presence);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTMessagingCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.messaging, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTMessagingCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.messaging);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTLobbyCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.lobby, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTLobbyCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.lobby);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTAsyncMatchCallback(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.asyncMatch, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTBlockchainRefresh(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.userItems, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTBlockchainRefresh() {
    _commsLayer?.deregisterRTTCallback(ServiceName.userItems);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTBlockchainItemEvent(RTTCallback inCallback) {
    _commsLayer?.registerRTTCallback(ServiceName.blockChain, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTBlockchainItemEvent() {
    _commsLayer?.deregisterRTTCallback(ServiceName.blockChain);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTAsyncMatchCallback() {
    _commsLayer?.deregisterRTTCallback(ServiceName.asyncMatch);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterAllRTTCallbacks() {
    _commsLayer?.deregisterAllRTTCallbacks();
  }

  /// <summary>
  ///
  /// </summary>
  void setRTTHeartBeatSeconds(int inValue) {
    _commsLayer?.setRTTHeartBeatSeconds(inValue);
  }

  /// <summary>
  /// Requests the event server address
  /// </summary>
  void requestClientConnection(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.rttRegistration,
        ServiceOperation.requestClientConnection, null, callback);
    _clientRef?.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  String? getRTTConnectionID() {
    return _commsLayer?.rttConnectionID;
  }
}
