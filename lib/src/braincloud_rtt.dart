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
    _commsLayer?.EnableRTT(inConnectiontype ?? RTTConnectionType.WEBSOCKET,
        inSuccess, inFailure, cbObject);
  }

  /// <summary>
  /// Disables Real Time event for this session.
  /// </summary>
  void disableRTT() {
    _commsLayer?.DisableRTT();
  }

  /// <summary>
  /// Returns true if RTT is enabled
  /// </summary>
  bool isRTTEnabled() {
    return _commsLayer?.IsRTTEnabled() ?? false;
  }

  /// <summary>
  /// Returns rtt connectionstatus
  /// </summary>
  RTTConnectionStatus? getConnectionStatus() {
    return _commsLayer?.GetConnectionStatus();
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTEventCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.Event, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTEventCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.Event);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTChatCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.Chat, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTChatCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.Chat);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTPresenceCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.Presence, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTPresenceCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.Presence);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTMessagingCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.Messaging, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTMessagingCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.Messaging);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTLobbyCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.Lobby, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTLobbyCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.Lobby);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTAsyncMatchCallback(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.AsyncMatch, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTBlockchainRefresh(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.UserItems, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTBlockchainRefresh() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.UserItems);
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTBlockchainItemEvent(RTTCallback inCallback) {
    _commsLayer?.RegisterRTTCallback(ServiceName.BlockChain, inCallback);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTBlockchainItemEvent() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.BlockChain);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTAsyncMatchCallback() {
    _commsLayer?.DeregisterRTTCallback(ServiceName.AsyncMatch);
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterAllRTTCallbacks() {
    _commsLayer?.DeregisterAllRTTCallbacks();
  }

  /// <summary>
  ///
  /// </summary>
  void setRTTHeartBeatSeconds(int inValue) {
    _commsLayer?.SetRTTHeartBeatSeconds(inValue);
  }

  /// <summary>
  /// Requests the event server address
  /// </summary>
  void requestClientConnection(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.RTTRegistration,
        ServiceOperation.requestClientConnection, null, callback);
    _clientRef?.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  String? getRTTConnectionID() {
    return _commsLayer?.RTTConnectionID;
  }
}
