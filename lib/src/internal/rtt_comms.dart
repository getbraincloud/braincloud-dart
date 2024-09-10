import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:braincloud_dart/src/internal/braincloud_websocket.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:mutex/mutex.dart';

class RTTComms {
  final BrainCloudClient _clientRef;

  RTTComms(this._clientRef);

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
  void enableRTT(RTTConnectionType? inConnectiontype,
      SuccessCallback? inSuccess, FailureCallback? inFailure) {
    _disconnectedWithReason = false;

    if (isRTTEnabled() ||
        _rttConnectionStatus == RTTConnectionStatus.connecting) {
      return;
    } else {
      _connectedSuccessCallback = inSuccess;
      _connectionFailureCallback = inFailure;

      _currentConnectionType = inConnectiontype ?? RTTConnectionType.websocket;
      _clientRef.rttService.requestClientConnection((response) {
        rttConnectionServerSuccess(response);
      }, (statusCode, reasonCode, statusMessage) {
        rttConnectionServerError(statusCode, reasonCode, statusMessage);
      });
    }
  }

  /// <summary>
  /// Disables Real Time event for this session.
  /// </summary>
  void disableRTT() {
    if (!isRTTEnabled() ||
        _rttConnectionStatus == RTTConnectionStatus.disconnecting) {
      return;
    }
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.rttRegistration.value.toLowerCase(),
        "disconnect",
        "DisableRTT Called"));
  }

  /// <summary>
  /// Returns true if RTT is enabled
  /// </summary>
  bool isRTTEnabled() {
    return _rttConnectionStatus == RTTConnectionStatus.connected;
  }

  ///<summary>
  ///Returns the status of the connection
  ///</summary>
  RTTConnectionStatus getConnectionStatus() {
    return _rttConnectionStatus;
  }

  /// <summary>
  ///
  /// </summary>
  void registerRTTCallback(ServiceName inServicename, RTTCallback inCallback) {
    _registeredCallbacks[inServicename.value.toLowerCase()] = inCallback;
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterRTTCallback(ServiceName inServicename) {
    String toCheck = inServicename.value.toLowerCase();
    if (_registeredCallbacks.containsKey(toCheck)) {
      _registeredCallbacks.remove(toCheck);
    }
  }

  /// <summary>
  ///
  /// </summary>
  void deregisterAllRTTCallbacks() {
    _registeredCallbacks.clear();
  }

  /// <summary>
  ///
  /// </summary>
  void setRTTHeartBeatSeconds(int inValue) {
    _heartBeatTime = Duration(milliseconds: inValue * 1000);
  }

  late String _rttConnectionID;
  late String _rttEventServer;

  String get rttConnectionID => _rttConnectionID;
  String get rttEventServer => _rttEventServer;

  /// <summary>
  ///
  /// </summary>
  void update() {
    RTTCommandResponse toProcessResponse;
    _queuedRTTCommandsLock.acquire();
    try {
      for (int i = 0; i < _queuedRTTCommands.length; ++i) {
        toProcessResponse = _queuedRTTCommands[i];

        //the rtt websocket has closed and RTT needs to be re-enabled. disconnect is called to fully reset connection
        if (_webSocketStatus == WebsocketStatus.closed) {
          _connectionFailureCallback!(400, -1,
              "RTT Connection has been closed. Re-Enable RTT to re-establish connection : ${toProcessResponse.jsonMessage}");

          _rttConnectionStatus = RTTConnectionStatus.disconnecting;
          disconnect();
          break;
        }

        //the rtt websocket has closed and RTT needs to be re-enabled. disconnect is called to fully reset connection
        if (_webSocketStatus == WebsocketStatus.closed) {
          _connectionFailureCallback!(400, -1,
              "RTT Connection has been closed. Re-Enable RTT to re-establish connection : ${toProcessResponse.jsonMessage}");
          _rttConnectionStatus = RTTConnectionStatus.disconnecting;
          disconnect();
          break;
        }

        // does this go to one of our registered service listeners?
        if (_registeredCallbacks.containsKey(toProcessResponse.service)) {
          _registeredCallbacks[toProcessResponse.service]!(
              toProcessResponse.jsonMessage ?? "");
        }

        // are we actually connected? only pump this back, when the server says we've connected
        else if (_rttConnectionStatus == RTTConnectionStatus.connecting &&
            _connectedSuccessCallback != null &&
            toProcessResponse.operation == "connect") {
          _sinceLastHeartbeat = Duration(
              seconds: DateTime.now().subtract(_sinceLastHeartbeat).second);
          _rttConnectionStatus = RTTConnectionStatus.connected;
          _connectedSuccessCallback!(
              jsonDecode(toProcessResponse.jsonMessage ?? ""));
        }

        //if we're connected and we get a disconnect - we disconnect the comms...
        else if (_rttConnectionStatus == RTTConnectionStatus.connected &&
            _connectionFailureCallback != null &&
            toProcessResponse.operation == "disconnect") {
          _rttConnectionStatus = RTTConnectionStatus.disconnecting;
          disconnect();
        }

        //If there's an error, we send back the error
        else if (_connectionFailureCallback != null &&
            toProcessResponse.operation == "error") {
          if (toProcessResponse.jsonMessage != null) {
            Map<String, dynamic> messageData =
                jsonDecode(toProcessResponse.jsonMessage ?? "");
            if (messageData.containsKey("status") &&
                messageData.containsKey("reason_code")) {
              _connectionFailureCallback!(
                messageData["status"],
                messageData["reason_code"],
                toProcessResponse.jsonMessage ?? "",
              );
            } else {
              //in the rare case the message is differently structured.
              _connectionFailureCallback!(
                  400, -1, toProcessResponse.jsonMessage ?? "");
            }
          } else {
            _connectionFailureCallback!(
                400, -1, "Error - No Response from Server");
          }
        }

        //if we're not connected and we're trying to connect, then start the connection
        else if (_rttConnectionStatus == RTTConnectionStatus.disconnected &&
            toProcessResponse.operation == "connect") {
          // first time connecting? send the server connection call
          _rttConnectionStatus = RTTConnectionStatus.connecting;
          _send(buildConnectionRequest());
        } else {
          if (_clientRef.loggingEnabled) {
            _clientRef.log("WARNING no handler registered for RTT callbacks ");
          }
        }
      }

      _queuedRTTCommands.clear();
    } finally {
      _queuedRTTCommandsLock.release();
    }

    if (_rttConnectionStatus == RTTConnectionStatus.connected) {
      if ((Duration(
              seconds: DateTime.now().subtract(_sinceLastHeartbeat).second)) >=
          _heartBeatTime) {
        _sinceLastHeartbeat = Duration(
            seconds: DateTime.now().subtract(_sinceLastHeartbeat).second);
        _send(_buildHeartbeatRequest(), inBLogMessage: true);
      }
    }
  }

  /// <summary>
  ///
  /// </summary>
  void connectWebSocket() {
    if (_rttConnectionStatus == RTTConnectionStatus.disconnected) {
      _startReceivingWebSocket();
    }
  }

  /// <summary>
  ///
  /// </summary>
  void disconnect() {
    _webSocket?.close();

    _rttConnectionID = "";
    _rttEventServer = "";

    _webSocket = null;

    if (_disconnectedWithReason == true) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log(
            "RTT: Disconnect: ${_clientRef.serializeJson(_disconnectJson)}");
      }
      if (_connectionFailureCallback != null) {
        _connectionFailureCallback!(
            400, _disconnectJson["reason_code"], _disconnectJson["reason"]);
      }
    }
    _rttConnectionStatus = RTTConnectionStatus.disconnected;
  }

  String buildConnectionRequest() {
    Map<String, dynamic> system = {};
    system["platform"] = _clientRef.releasePlatform.toString();
    system["protocol"] = "ws";

    Map<String, dynamic> jsonData = {};
    jsonData["appId"] = _clientRef.appId;
    jsonData["sessionId"] = _clientRef.sessionID;
    jsonData["profileId"] = _clientRef.profileId;
    jsonData["system"] = system;

    jsonData["auth"] = _rttHeaders;

    Map<String, dynamic> json = {};
    json["service"] = ServiceName.rtt.value;
    json["operation"] = "CONNECT";
    json["data"] = jsonData;

    return _clientRef.serializeJson(json);
  }

  String _buildHeartbeatRequest() {
    Map<String, dynamic> json = {};
    json["service"] = ServiceName.rtt.value;
    json["operation"] = "HEARTBEAT";
    json["data"] = null;

    return _clientRef.serializeJson(json);
  }

  /// <summary>
  ///
  /// </summary>
  bool _send(String inMessage, {bool inBLogMessage = true}) {
    bool bMessageSent = false;
    bool mUsewebsocket = _currentConnectionType == RTTConnectionType.websocket;
    // early return
    if ((mUsewebsocket && _webSocket == null)) {
      return bMessageSent;
    }

    try {
      if (inBLogMessage) {
        if (_clientRef.loggingEnabled) {
          _clientRef.log("RTT SEND: $inMessage");
        }
      }

      // Web Socket
      if (mUsewebsocket) {
        Uint8List data = ascii.encode(inMessage);
        _webSocket?.send(data);
      }
    } catch (socketException) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("send exception: $socketException");
      }
      addRTTCommandResponse(RTTCommandResponse(
          ServiceName.rttRegistration.value.toLowerCase(),
          "error",
          buildRTTRequestError(socketException.toString())));
    }

    return bMessageSent;
  }

  /// <summary>
  ///
  /// </summary>
  void _startReceivingWebSocket() {
    String sslEnabled = _endpoint?["ssl"] ? "wss://" : "ws://";
    String url =
        "$sslEnabled${_endpoint?["host"]}:${_endpoint?["port"]}${_getUrlQueryParameters()}";
    _setupWebSocket(url);
  }

  String _getUrlQueryParameters() {
    String sToReturn = "?";
    int count = 0;
    _rttHeaders.forEach((key, value) {
      if (count > 0) sToReturn += "&";
      sToReturn += "$key=$value";
      ++count;
    });

    return sToReturn;
  }

  void _setupWebSocket(String inUrl) {
    _webSocket = BrainCloudWebSocket(inUrl,
        onOpen: webSocketOnOpen,
        onClose: webSocketOnClose,
        onMessage: webSocketOnMessage,
        onError: webSocketOnError);
  }

  void webSocketOnClose({required int code, required String reason}) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT: Connection closed: $reason");
    }
    _webSocketStatus = WebsocketStatus.closed;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.rttRegistration.value.toLowerCase(), "disconnect", reason));
  }

  void webSocketOnOpen() {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT: Connection established.");
    }
    _webSocketStatus = WebsocketStatus.open;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.rttRegistration.value.toLowerCase(), "connect", ""));
  }

  void webSocketOnMessage({required Uint8List data}) {
    if (data.isEmpty) {
      return;
    }
    _webSocketStatus = WebsocketStatus.message;
    String message = utf8.decode(data);
    _onRecv(message);
  }

  void webSocketOnError({required String message}) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT Error: $message");
    }
    _webSocketStatus = WebsocketStatus.error;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.rttRegistration.value.toLowerCase(),
        "error",
        buildRTTRequestError(message)));
  }

  /// <summary>
  ///
  /// </summary>
  void _onRecv(String inMessage) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT RECV: $inMessage");
    }

    Map<String, dynamic> response = jsonDecode(inMessage);

    String service = response["service"];
    String operation = response["operation"];

    Map<String, dynamic> data = {};
    if (response.containsKey("data")) {
      data = response["data"];
    }
    if (operation == "CONNECT") {
      int heartBeat = (_heartBeatTime.inMilliseconds / 1000).truncate();
      try {
        heartBeat = data["heartbeatSeconds"];
      } catch (e) {
        heartBeat = data["wsHeartbeatSecs"];
      }

      setRTTHeartBeatSeconds(heartBeat);
    } else if (operation == "DISCONNECT") {
      _disconnectedWithReason = true;
      _disconnectJson["reason_code"] = data["reasonCode"];
      _disconnectJson["reason"] = data["reason"];
      _disconnectJson["severity"] = "ERROR";
    }

    if (data.containsKey("cxId")) {
      _rttConnectionID = data["cxId"];
    }
    if (data.containsKey("evs")) {
      _rttEventServer = data["evs"];
    }

    if (operation != "HEARTBEAT") {
      addRTTCommandResponse(RTTCommandResponse(
          service.toLowerCase(), operation.toLowerCase(), inMessage));
    }
  }

  /// <summary>
  ///
  /// </summary>
  void rttConnectionServerSuccess(Map<String, dynamic> jsonResponse) {
    Map<String, dynamic> jsonData = jsonResponse["data"];
    List endpoints = jsonData["endpoints"];
    _rttHeaders = jsonData["auth"];

    if (_currentConnectionType == RTTConnectionType.websocket) {
      //   1st choice: websocket + ssl
      //   2nd: websocket
      _endpoint = getEndpointForType(endpoints, "ws", true);
      _endpoint ??= getEndpointForType(endpoints, "ws", false);

      connectWebSocket();
    }
  }

  /// <summary>
  ///
  /// </summary>
  Map<String, dynamic>? getEndpointForType(
      List endpoints, String type, inBwantssl) {
    Map<String, dynamic>? toReturn;
    Map<String, dynamic>? tempToReturn;
    for (int i = 0; i < endpoints.length; ++i) {
      tempToReturn = endpoints[i] as Map<String, dynamic>;
      if (tempToReturn["protocol"] as String == type) {
        if (inBwantssl) {
          if (tempToReturn.containsKey("ssl")) {
            toReturn = tempToReturn;
            break;
          }
        } else {
          toReturn = tempToReturn;
          break;
        }
      }
    }

    return toReturn;
  }

  /// <summary>
  ///
  /// </summary>
  void rttConnectionServerError(int status, int reasonCode, String jsonError) {
    _rttConnectionStatus = RTTConnectionStatus.disconnected;
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT Connection Server Error: \n$jsonError");
    }
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.rttRegistration.value.toLowerCase(), "error", jsonError));
  }

  void addRTTCommandResponse(RTTCommandResponse inCommand) {
    _queuedRTTCommandsLock.acquire();
    try {
      _queuedRTTCommands.add(inCommand);
    } finally {
      _queuedRTTCommandsLock.release();
    }
  }

  String buildRTTRequestError(String inStatusmessage) {
    Map<String, dynamic> json = <String, dynamic>{};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.rttClientError;
    json["status_message"] = inStatusmessage;
    json["severity"] = "ERROR";

    return _clientRef.serializeJson(json);
  }

  bool _disconnectedWithReason = false;
  final Map<String, dynamic> _disconnectJson = {};

  Map<String, dynamic>? _endpoint;
  RTTConnectionType _currentConnectionType = RTTConnectionType.invalid;
  BrainCloudWebSocket? _webSocket;

  Duration _sinceLastHeartbeat = const Duration(milliseconds: 1);
  static const int maxPacketsize = 1024;
  Duration _heartBeatTime = const Duration(milliseconds: 10 * 1000);

  // success callbacks
  SuccessCallback? _connectedSuccessCallback;
  FailureCallback? _connectionFailureCallback;
  //dynamic _connectedObj;

  Map<String, dynamic> _rttHeaders = {};
  final Map<String, RTTCallback> _registeredCallbacks = {};
  final List<RTTCommandResponse> _queuedRTTCommands = [];

  final Mutex _queuedRTTCommandsLock = Mutex();

  WebsocketStatus _webSocketStatus = WebsocketStatus.none;

  RTTConnectionStatus _rttConnectionStatus = RTTConnectionStatus.disconnected;
}

class RTTCommandResponse {
  late String service;
  late String operation;
  String? jsonMessage;
  RTTCommandResponse(String inService, String inOp, String inMsg) {
    service = inService;
    operation = inOp;
    jsonMessage = inMsg;
  }
}

enum WebsocketStatus { open, closed, message, error, none }

enum RTTConnectionStatus { connected, disconnected, connecting, disconnecting }

enum RTTConnectionType { invalid, websocket, max }
