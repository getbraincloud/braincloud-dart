import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';

import 'package:braincloud_dart/src/internal/braincloud_websocket.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:json_annotation/json_annotation.dart';

part 'rtt_comms.g.dart';

class RTTComms {
  final BrainCloudClient _clientRef;

  RTTComms(this._clientRef);

  /// Enables Real Time event for this session.
  /// Real Time events are disabled by default. Usually events
  /// need to be polled using GET_EVENTS. By enabling this, events will
  /// be received instantly when they happen through a TCP connection to an Event Server.
  ///
  ///This function will first call requestClientConnection, then connect to the address

  /// @param in_connectionType
  /// @param in_success
  /// @param in_failure
  void enableRTT(RTTConnectionType? inConnectiontype,
      RTTSuccessCallback? inSuccess, RTTFailureCallback? inFailure) {
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

  /// Disables Real Time event for this session.

  void disableRTT() {
    if (!isRTTEnabled() ||
        _rttConnectionStatus == RTTConnectionStatus.disconnecting) {
      return;
    }
    addRTTCommandResponse(RTTCommandResponse(
        service: ServiceName.rttRegistration.value,
        operation: RTTCommandOperation.disconnect,
        data: {"message": "DisableRTT Called"}));
  }

  /// Returns true if RTT is enabled

  bool isRTTEnabled() {
    return _rttConnectionStatus == RTTConnectionStatus.connected;
  }

  ///Returns the status of the connection
  ///
  RTTConnectionStatus getConnectionStatus() {
    return _rttConnectionStatus;
  }

  ///

  void registerRTTCallback(ServiceName inServicename, RTTCallback inCallback) {
    _registeredCallbacks[inServicename.value.toLowerCase()] = inCallback;
  }

  ///

  void deregisterRTTCallback(ServiceName inServicename) {
    String toCheck = inServicename.value.toLowerCase();
    if (_registeredCallbacks.containsKey(toCheck)) {
      _registeredCallbacks.remove(toCheck);
    }
  }

  ///

  void deregisterAllRTTCallbacks() {
    _registeredCallbacks.clear();
  }

  ///

  void setRTTHeartBeatSeconds(int inValue) {
    _heartBeatTime = Duration(seconds: inValue);
  }

  String? _rttConnectionID;
  String? _rttEventServer;

  String? get rttConnectionID => _rttConnectionID;
  String? get rttEventServer => _rttEventServer;

  ///

  void update() async {
    RTTCommandResponse toProcessResponse;
    for (int i = 0; i < _queuedRTTCommands.length; ++i) {
      toProcessResponse = _queuedRTTCommands[i];
      //the rtt websocket has closed and RTT needs to be re-enabled. disconnect is called to fully reset connection
      // if (_webSocketStatus == WebsocketStatus.closed  && toProcessResponse.operation != RTTCommandOperation.disconnect ) {
      if (_webSocketStatus == WebsocketStatus.closed) {
        _rttConnectionStatus = RTTConnectionStatus.disconnecting;
        if (_connectionFailureCallback != null)
          try {
            _connectionFailureCallback!(RTTCommandResponse(
                service: ServiceName.rtt.value,
                operation: RTTCommandOperation.error,
                data: {
                  "error":
                      "RTT Connection has been closed. Re-Enable RTT to re-establish connection : ${toProcessResponse.data}"
                }));
          } catch (e) {
            _clientRef.log(
                "WARNING - this callback threw an exception: " + e.toString(),
                bypassLogEnabled: true);
          }
        disconnect();
        break;
      }

      // does this go to one of our registered service listeners?
      if (_registeredCallbacks.containsKey(toProcessResponse.service)) {
        try {
          _registeredCallbacks[toProcessResponse.service]!(
              RTTCommandResponse.fromJson(toProcessResponse.data ?? {}));
        } catch (e) {
          _clientRef.log(
              "WARNING - this callback threw an exception: " + e.toString(),
              bypassLogEnabled: true);
        }
      }

      // are we actually connected? only pump this back, when the server says we've connected
      else if (_rttConnectionStatus == RTTConnectionStatus.connecting &&
          toProcessResponse.operation == RTTCommandOperation.connect) {
        _sinceLastHeartbeat = DateTime.now();
        _rttConnectionStatus = RTTConnectionStatus.connected;
        if (_connectedSuccessCallback != null)
          try {
            _connectedSuccessCallback!(toProcessResponse);
          } catch (e) {
            _clientRef.log(
                "WARNING - this callback threw an exception: " + e.toString(),
                bypassLogEnabled: true);
          }
      }

      //if we're connected and we get a disconnect - we disconnect the comms...
      else if (_rttConnectionStatus == RTTConnectionStatus.connected &&
          toProcessResponse.operation == RTTCommandOperation.disconnect) {
        _rttConnectionStatus = RTTConnectionStatus.disconnecting;
        disconnect();
      }

      //If there's an error, we send back the error
      else if (_connectionFailureCallback != null &&
          toProcessResponse.operation == RTTCommandOperation.error) {
        if (toProcessResponse.data != null) {
          Map<String, dynamic> messageData = toProcessResponse.data ?? {};
          if (messageData.containsKey("status") &&
              messageData.containsKey("reason_code")) {
            try {
              _connectionFailureCallback!(RTTCommandResponse(
                service: ServiceName.rtt.value,
                operation: RTTCommandOperation.error,
                data: messageData,
              ));
            } catch (e) {
              _clientRef.log(
                  "WARNING - this callback threw an exception: " + e.toString(),
                  bypassLogEnabled: true);
            }
          } else {
            //in the rare case the message is differently structured.
            try {
              _connectionFailureCallback!(RTTCommandResponse(
                  service: ServiceName.rtt.value,
                  operation: RTTCommandOperation.error,
                  data: messageData));
            } catch (e) {
              _clientRef.log(
                  "WARNING - this callback threw an exception: " + e.toString(),
                  bypassLogEnabled: true);
            }
          }
        } else {
          try {
            _connectionFailureCallback!(RTTCommandResponse(
                service: ServiceName.rtt.value,
                operation: RTTCommandOperation.error,
                data: {"error": "Error - No Response from Server"}));
          } catch (e) {
            _clientRef.log(
                "WARNING - this callback threw an exception: " + e.toString(),
                bypassLogEnabled: true);
          }
        }
      }

      //if we're not connected and we're trying to connect, then start the connection
      else if (_rttConnectionStatus == RTTConnectionStatus.disconnected &&
          toProcessResponse.operation == RTTCommandOperation.connect) {
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
    if (_rttConnectionStatus == RTTConnectionStatus.connected) {
      if (DateTime.now().difference(_sinceLastHeartbeat) >= _heartBeatTime) {
        _sinceLastHeartbeat = DateTime.now();
        _send(_buildHeartbeatRequest(), inBLogMessage: true);
      }
    }
  }

  ///

  void connectWebSocket() {
    if (_rttConnectionStatus == RTTConnectionStatus.disconnected) {
      _startReceivingWebSocket();
    }
  }

  ///

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
        _connectionFailureCallback!(RTTCommandResponse(
            service: ServiceName.rttRegistration.value,
            operation: RTTCommandOperation.error,
            reasonCode: _disconnectJson["reason_code"],
            data: (_disconnectJson["reason"] is Map)
                ? _disconnectJson["reason"]
                : _disconnectJson));

        /// [mc] To ensure data is always a Map and not a String
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

  ///

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
          service: ServiceName.rttRegistration.value,
          operation: RTTCommandOperation.error,
          data: buildRTTRequestError(socketException.toString())));
    }

    return bMessageSent;
  }

  ///

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
    if (_rttConnectionStatus == RTTConnectionStatus.disconnected ||
        _rttConnectionStatus == RTTConnectionStatus.disconnecting) return;
    addRTTCommandResponse(RTTCommandResponse(
        service: ServiceName.rttRegistration.value,
        operation: RTTCommandOperation.disconnect,
        data: json.decode(reason)));
  }

  void webSocketOnOpen() {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT: Connection established.");
    }
    _webSocketStatus = WebsocketStatus.open;
    addRTTCommandResponse(RTTCommandResponse(
        service: ServiceName.rttRegistration.value,
        operation: RTTCommandOperation.connect));
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
        service: ServiceName.rttRegistration.value,
        operation: RTTCommandOperation.error,
        data: buildRTTRequestError(message)));
  }

  ///

  void _onRecv(String inMessage) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT RECV: $inMessage");
    }

    Map<String, dynamic> response = jsonDecode(inMessage);

    if (!response.containsKey("service") ||
        !response.containsKey("operation")) {
      _clientRef.log(
          "RTT RECV: missing service/operation, invalid message $inMessage");
      return;
    }
    String service = response["service"];
    String operation = response["operation"];

    Map<String, dynamic> data = {};
    if (response.containsKey("data")) {
      data = response["data"] ?? {};
    }
    if (operation == "CONNECT") {
      int heartBeat = _heartBeatTime.inSeconds;
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
          service: service,
          operation: operation.toLowerCase(),
          data: response));
    }
  }

  ///

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

  ///

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

  ///

  void rttConnectionServerError(int status, int reasonCode, String jsonError) {
    _rttConnectionStatus = RTTConnectionStatus.disconnected;
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RTT Connection Server Error: \n$jsonError");
    }
    addRTTCommandResponse(RTTCommandResponse(
        service: ServiceName.rttRegistration.value,
        operation: RTTCommandOperation.error,
        data: jsonDecode(jsonError)));
  }

  void addRTTCommandResponse(RTTCommandResponse inCommand) async {
    _queuedRTTCommands.add(inCommand);
  }

  Map<String, dynamic> buildRTTRequestError(String inStatusmessage) {
    Map<String, dynamic> json = <String, dynamic>{};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.rttClientError;
    json["status_message"] = inStatusmessage;
    json["severity"] = "ERROR";

    return json;
  }

  bool _disconnectedWithReason = false;
  final Map<String, dynamic> _disconnectJson = {};

  Map<String, dynamic>? _endpoint;
  RTTConnectionType _currentConnectionType = RTTConnectionType.invalid;
  BrainCloudWebSocket? _webSocket;

  DateTime _sinceLastHeartbeat = DateTime.now();
  static const int maxPacketsize = 1024;
  Duration _heartBeatTime = const Duration(milliseconds: 10 * 1000);

  // success callbacks
  RTTSuccessCallback? _connectedSuccessCallback;
  RTTFailureCallback? _connectionFailureCallback;
  //dynamic _connectedObj;

  // For testing only
  // @visibleForTesting
  set connectedSuccessCallback(value) => _connectedSuccessCallback = value;
  // @visibleForTesting
  set connectionFailureCallback(value) => _connectionFailureCallback = value;
  // @visibleForTesting
  set currentConnectionType(value) => _currentConnectionType = value;

  Map<String, dynamic> _rttHeaders = {};
  final Map<String, RTTCallback> _registeredCallbacks = {};
  final List<RTTCommandResponse> _queuedRTTCommands = [];

  WebsocketStatus _webSocketStatus = WebsocketStatus.none;

  RTTConnectionStatus _rttConnectionStatus = RTTConnectionStatus.disconnected;
}

@JsonSerializable()
class RTTCommandResponse {
  final String service;
  final String operation;
  Map<String, dynamic>? data;
  final int? reasonCode;

  RTTCommandResponse(
      {required this.service,
      required this.operation,
      this.data,
      this.reasonCode});

  @override
  String toString() {
    return "RTTCommandResponse(service:$service, operation:$operation, reasonCode: $reasonCode, data: $data)";
  }

  factory RTTCommandResponse.fromJson(Map<String, dynamic> json) =>
      _$RTTCommandResponseFromJson(json);
  Map<String, dynamic> toJson() => _$RTTCommandResponseToJson(this);
}

typedef RTTSuccessCallback = Function(RTTCommandResponse response);
typedef RTTFailureCallback = Function(RTTCommandResponse response);

enum WebsocketStatus { open, closed, message, error, none }

enum RTTConnectionStatus { connected, disconnected, connecting, disconnecting }

enum RTTConnectionType { invalid, websocket, max }

class RTTCommandOperation {
  static final String connect = "connect";
  static final String disconnect = "disconnect";
  static final String error = "error";
}
