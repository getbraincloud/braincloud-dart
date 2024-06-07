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
  /// <param name="cb_object"></param>
  void EnableRTT(
      RTTConnectionType? in_connectionType,
      SuccessCallback? in_success,
      FailureCallback? in_failure,
      dynamic cb_object) {
    _disconnectedWithReason = false;

    if (IsRTTEnabled() ||
        _rttConnectionStatus == RTTConnectionStatus.CONNECTING) {
      return;
    } else {
      _connectedSuccessCallback = in_success;
      _connectionFailureCallback = in_failure;
      _connectedObj = cb_object;

      m_currentConnectionType =
          in_connectionType ?? RTTConnectionType.WEBSOCKET;
      _clientRef.rttService?.requestClientConnection(
          rttConnectionServerSuccess as SuccessCallback,
          rttConnectionServerError as FailureCallback,
          cb_object);
    }
  }

  /// <summary>
  /// Disables Real Time event for this session.
  /// </summary>
  void DisableRTT() {
    if (!IsRTTEnabled() ||
        _rttConnectionStatus == RTTConnectionStatus.DISCONNECTING) {
      return;
    }
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.RTTRegistration.Value.toLowerCase(),
        "disconnect",
        "DisableRTT Called"));
  }

  /// <summary>
  /// Returns true if RTT is enabled
  /// </summary>
  bool IsRTTEnabled() {
    return _rttConnectionStatus == RTTConnectionStatus.CONNECTED;
  }

  ///<summary>
  ///Returns the status of the connection
  ///</summary>
  RTTConnectionStatus GetConnectionStatus() {
    return _rttConnectionStatus;
  }

  /// <summary>
  ///
  /// </summary>
  void RegisterRTTCallback(
      ServiceName in_serviceName, RTTCallback in_callback) {
    _registeredCallbacks[in_serviceName.Value.toLowerCase()] = in_callback;
  }

  /// <summary>
  ///
  /// </summary>
  void DeregisterRTTCallback(ServiceName in_serviceName) {
    String toCheck = in_serviceName.Value.toLowerCase();
    if (_registeredCallbacks.containsKey(toCheck)) {
      _registeredCallbacks.remove(toCheck);
    }
  }

  /// <summary>
  ///
  /// </summary>
  void DeregisterAllRTTCallbacks() {
    _registeredCallbacks.clear();
  }

  /// <summary>
  ///
  /// </summary>
  void SetRTTHeartBeatSeconds(int in_value) {
    _heartBeatTime = Duration(milliseconds: in_value * 1000);
  }

  late String _rttConnectionID;
  late String _rttEventServer;

  String get RTTConnectionID => _rttConnectionID;
  String get RTTEventServer => _rttEventServer;

  /// <summary>
  ///
  /// </summary>
  void Update() {
    RTTCommandResponse toProcessResponse;
    _queuedRTTCommandsLock.acquire();
    try {
      for (int i = 0; i < _queuedRTTCommands.length; ++i) {
        toProcessResponse = _queuedRTTCommands[i];

        //the rtt websocket has closed and RTT needs to be re-enabled. disconnect is called to fully reset connection
        if (m_webSocketStatus == WebsocketStatus.CLOSED) {
          _connectionFailureCallback!(400, -1,
              "RTT Connection has been closed. Re-Enable RTT to re-establish connection : ${toProcessResponse.jsonMessage}");

          _rttConnectionStatus = RTTConnectionStatus.DISCONNECTING;
          disconnect();
          break;
        }

        //the rtt websocket has closed and RTT needs to be re-enabled. disconnect is called to fully reset connection
        if (m_webSocketStatus == WebsocketStatus.CLOSED) {
          _connectionFailureCallback!(400, -1,
              "RTT Connection has been closed. Re-Enable RTT to re-establish connection : ${toProcessResponse.jsonMessage}");
          _rttConnectionStatus = RTTConnectionStatus.DISCONNECTING;
          disconnect();
          break;
        }

        // does this go to one of our registered service listeners?
        if (_registeredCallbacks.containsKey(toProcessResponse.service)) {
          _registeredCallbacks[toProcessResponse.service]!(
              toProcessResponse.jsonMessage ?? "");
        }

        // are we actually connected? only pump this back, when the server says we've connected
        else if (_rttConnectionStatus == RTTConnectionStatus.CONNECTING &&
            _connectedSuccessCallback != null &&
            toProcessResponse.operation == "connect") {
          _sinceLastHeartbeat = Duration(
              seconds: DateTime.now().subtract(_sinceLastHeartbeat).second);
          _connectedSuccessCallback!(toProcessResponse.jsonMessage ?? "");
          _rttConnectionStatus = RTTConnectionStatus.CONNECTED;
        }

        //if we're connected and we get a disconnect - we disconnect the comms...
        else if (_rttConnectionStatus == RTTConnectionStatus.CONNECTED &&
            _connectionFailureCallback != null &&
            toProcessResponse.operation == "disconnect") {
          _rttConnectionStatus = RTTConnectionStatus.DISCONNECTING;
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
        else if (_rttConnectionStatus == RTTConnectionStatus.DISCONNECTED &&
            toProcessResponse.operation == "connect") {
          // first time connecting? send the server connection call
          _rttConnectionStatus = RTTConnectionStatus.CONNECTING;
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

    if (_rttConnectionStatus == RTTConnectionStatus.CONNECTED) {
      if ((Duration(
              seconds: DateTime.now().subtract(_sinceLastHeartbeat).second)) >=
          _heartBeatTime) {
        _sinceLastHeartbeat = Duration(
            seconds: DateTime.now().subtract(_sinceLastHeartbeat).second);
        _send(_buildHeartbeatRequest(), in_bLogMessage: true);
      }
    }
  }

  /// <summary>
  ///
  /// </summary>
  void connectWebSocket() {
    if (_rttConnectionStatus == RTTConnectionStatus.DISCONNECTED) {
      _startReceivingWebSocket();
    }
  }

  /// <summary>
  ///
  /// </summary>
  void disconnect() {
    //if (m_webSocket != null) m_webSocket?.Close();

    _rttConnectionID = "";
    _rttEventServer = "";

    m_webSocket = null;

    if (_disconnectedWithReason == true) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log(
            "RTT: Disconnect: ${_clientRef.serializeJson(m_disconnectJson)}");
      }
      if (_connectionFailureCallback != null) {
        _connectionFailureCallback!(
            400, m_disconnectJson["reason_code"], m_disconnectJson["reason"]);
      }
    }
    _rttConnectionStatus = RTTConnectionStatus.DISCONNECTED;
  }

  String buildConnectionRequest() {
    Map<String, dynamic> system = {};
    system["platform"] = _clientRef.releasePlatform.toString();
    system["protocol"] = "ws";

    Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData["appId"] = _clientRef.appId;
    jsonData["sessionId"] = _clientRef.sessionID;
    jsonData["profileId"] = _clientRef.profileId;
    jsonData["system"] = system;

    jsonData["auth"] = _rttHeaders;

    Map<String, dynamic> json = {};
    json["service"] = ServiceName.RTT.Value;
    json["operation"] = "CONNECT";
    json["data"] = jsonData;

    return _clientRef.serializeJson(json);
  }

  String _buildHeartbeatRequest() {
    Map<String, dynamic> json = {};
    json["service"] = ServiceName.RTT.Value;
    json["operation"] = "HEARTBEAT";
    json["data"] = null;

    return _clientRef.serializeJson(json);
  }

  /// <summary>
  ///
  /// </summary>
  bool _send(String in_message, {bool in_bLogMessage = true}) {
    bool bMessageSent = false;
    bool m_useWebSocket =
        m_currentConnectionType == RTTConnectionType.WEBSOCKET;
    // early return
    if ((m_useWebSocket && m_webSocket == null)) {
      return bMessageSent;
    }

    try {
      if (in_bLogMessage) {
        if (_clientRef.loggingEnabled) {
          _clientRef.log("RTT SEND: " + in_message);
        }
      }

      // Web Socket
      if (m_useWebSocket) {
        // Uint8List data = Encoding.ASCII.GetBytes(in_message);
        // m_webSocket.SendAsync(data);
      }
    } catch (socketException) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("send exception: " + socketException.toString());
      }
      addRTTCommandResponse(RTTCommandResponse(
          ServiceName.RTTRegistration.Value.toLowerCase(),
          "error",
          buildRTTRequestError(socketException.toString())));
    }

    return bMessageSent;
  }

  /// <summary>
  ///
  /// </summary>
  void _startReceivingWebSocket() {
    bool sslEnabled = m_endpoint?["ssl"];
    String url =
        "${sslEnabled ? "wss://" : "ws://"} ${m_endpoint?["host"]} :  ${m_endpoint?["port"]}  ${_getUrlQueryParameters()}";
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

  void _setupWebSocket(String in_url) {
    // m_webSocket = BrainCloudWebSocket(in_url);
    // m_webSocket.OnClose += WebSocket_OnClose;
    // m_webSocket.OnOpen += Websocket_OnOpen;
    // m_webSocket.OnMessage += WebSocket_OnMessage;
    // m_webSocket.OnError += WebSocket_OnError;
  }

  void _WebSocket_OnClose(BrainCloudWebSocket sender, int code, String reason) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT: Connection closed: " + reason);
    }
    m_webSocketStatus = WebsocketStatus.CLOSED;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.RTTRegistration.Value.toLowerCase(), "disconnect", reason));
  }

  void _Websocket_OnOpen(BrainCloudWebSocket accepted) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT: Connection established.");
    }
    m_webSocketStatus = WebsocketStatus.OPEN;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.RTTRegistration.Value.toLowerCase(), "connect", ""));
  }

  void _WebSocket_OnMessage(BrainCloudWebSocket sender, Uint8List data) {
    if (data.isEmpty) {
      return;
    }
    m_webSocketStatus = WebsocketStatus.MESSAGE;
    String message = utf8.decode(data);
    _onRecv(message);
  }

  void _WebSocket_OnError(BrainCloudWebSocket sender, String message) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT Error: " + message);
    }
    m_webSocketStatus = WebsocketStatus.ERROR;
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.RTTRegistration.Value.toLowerCase(),
        "error",
        buildRTTRequestError(message)));
  }

  /// <summary>
  ///
  /// </summary>
  void _onRecv(String in_message) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT RECV: " + in_message);
    }

    Map<String, dynamic> response = jsonDecode(in_message);

    String service = response["service"];
    String operation = response["operation"];

    Map<String, dynamic> data = {};
    if (response.containsKey("data")) {
      data = response["data"];
    }
    if (operation == "CONNECT") {
      int heartBeat = _heartBeatTime.inMilliseconds / 1000 as int;
      try {
        heartBeat = data["heartbeatSeconds"];
      } catch (e) {
        heartBeat = data["wsHeartbeatSecs"];
      }

      SetRTTHeartBeatSeconds(heartBeat);
    } else if (operation == "DISCONNECT") {
      _disconnectedWithReason = true;
      m_disconnectJson["reason_code"] = data["reasonCode"];
      m_disconnectJson["reason"] = data["reason"];
      m_disconnectJson["severity"] = "ERROR";
    }

    if (data.containsKey("cxId")) {
      _rttConnectionID = data["cxId"];
    }
    if (data.containsKey("evs")) {
      _rttEventServer = data["evs"];
    }

    if (operation != "HEARTBEAT") {
      addRTTCommandResponse(RTTCommandResponse(
          service.toLowerCase(), operation.toLowerCase(), in_message));
    }
  }

  /// <summary>
  ///
  /// </summary>
  void rttConnectionServerSuccess(String jsonResponse, dynamic cbObject) {
    Map<String, dynamic> jsonMessage = jsonDecode(jsonResponse);
    Map<String, dynamic> jsonData = jsonMessage["data"];
    List endpoints = jsonData["endpoints"];
    _rttHeaders = jsonData["auth"];

    if (m_currentConnectionType == RTTConnectionType.WEBSOCKET) {
      //   1st choice: websocket + ssl
      //   2nd: websocket
      m_endpoint = getEndpointForType(endpoints, "ws", true);
      m_endpoint ??= getEndpointForType(endpoints, "ws", false);

      connectWebSocket();
    }
  }

  /// <summary>
  ///
  /// </summary>
  Map<String, dynamic>? getEndpointForType(
      List endpoints, String type, in_bWantSsl) {
    Map<String, dynamic>? toReturn;
    Map<String, dynamic>? tempToReturn;
    for (int i = 0; i < endpoints.length; ++i) {
      tempToReturn = endpoints[i] as Map<String, dynamic>;
      if (tempToReturn["protocol"] as String == type) {
        if (in_bWantSsl) {
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
  void rttConnectionServerError(
      int status, int reasonCode, String jsonError, dynamic cbObject) {
    _rttConnectionStatus = RTTConnectionStatus.DISCONNECTED;
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT Connection Server Error: \n" + jsonError);
    }
    addRTTCommandResponse(RTTCommandResponse(
        ServiceName.RTTRegistration.Value.toLowerCase(), "error", jsonError));
  }

  void addRTTCommandResponse(RTTCommandResponse in_command) {
    lock(m_queuedRTTCommands) {
      m_queuedRTTCommands.Add(in_command);
    }
  }

  String buildRTTRequestError(String in_statusMessage) {
    Map<String, dynamic> json = <String, dynamic>{};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.RTT_CLIENT_ERROR;
    json["status_message"] = in_statusMessage;
    json["severity"] = "ERROR";

    return _clientRef.serializeJson(json);
  }

  bool _disconnectedWithReason = false;
  Map<String, dynamic> m_disconnectJson = <String, dynamic>{};

  Map<String, dynamic>? m_endpoint;
  RTTConnectionType m_currentConnectionType = RTTConnectionType.INVALID;
  BrainCloudWebSocket? m_webSocket;

  Duration _sinceLastHeartbeat = const Duration(milliseconds: 1);
  static const int MAX_PACKETSIZE = 1024;
  Duration _heartBeatTime = const Duration(milliseconds: 10 * 1000);

  // success callbacks
  SuccessCallback? _connectedSuccessCallback;
  FailureCallback? _connectionFailureCallback;
  dynamic _connectedObj;

  Map<String, dynamic> _rttHeaders = {};
  final Map<String, RTTCallback> _registeredCallbacks = {};
  final List<RTTCommandResponse> _queuedRTTCommands = [];

  final Mutex _queuedRTTCommandsLock = Mutex();

  WebsocketStatus m_webSocketStatus = WebsocketStatus.NONE;

  RTTConnectionStatus _rttConnectionStatus = RTTConnectionStatus.DISCONNECTED;
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

enum WebsocketStatus { OPEN, CLOSED, MESSAGE, ERROR, NONE }

enum RTTConnectionStatus { CONNECTED, DISCONNECTED, CONNECTING, DISCONNECTING }

enum RTTConnectionType { INVALID, WEBSOCKET, MAX }
