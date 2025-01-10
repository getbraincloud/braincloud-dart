import 'dart:collection';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:braincloud_dart/src/internal/braincloud_websocket.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_relay.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';

/// ******************************************************************************************
/// ******************************************************************************************
/// **    This is an alternate version of relay comms only used when building for web       **
/// **    Any changes made to the default relay comms must be made here too.                **
/// **    Only supported protosols is WebSocket, TCP and UDP will throw an error here.      **
/// ******************************************************************************************
/// ******************************************************************************************

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

class RelayComms {
  final BrainCloudClient _clientRef;

  static const MAX_PLAYERS = 40;
  static const INVALID_NET_ID = 40;

  static const int CL2RS_CONNECT = 0;
  static const int CL2RS_DISCONNECT = 1;
  static const int CL2RS_RELAY = 2;
  static const int CL2RS_ACK = 3;
  static const int CL2RS_PING = 4;
  static const int CL2RS_RSMG_ACK = 5;
  static const int CL2RS_ENDMATCH = 6;

  static const int RS2CL_RSMG = 0;
  static const int RS2CL_DISCONNECT = 1;
  static const int RS2CL_RELAY = 2;
  static const int RS2CL_ACK = 3;
  static const int RS2CL_PONG = 4;

  static const int MAX_RSMG_HISTORY = 50;

  late RelayConnectOptions _connectOptions;
  RelayConnectionType _connectionType = RelayConnectionType.websocket;

  List<_Event> _events = [];
  bool _isConnected = false;
  int _pingIntervalMs = 1000; // one second

  static const int _MAX_RELIABLE_RESEND_INTERVAL = 500;
  static const int _MAX_PACKET_ID = 0xFFF;

  static const int SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY = 2;
  static const int SIZE_OF_ACKID_MESSAGE = 11;
  static const int CONNECT_RESEND_INTERVAL_MS = 500;

  static const int MAX_PACKET_SIZE = 1024;
  static const int TIMEOUT_SECONDS = 10;

  String _ownerCxId = "";
  Map<String, int> _cxIdToNetId = {};
  Map<int, String> _netIdToCxId = {};

  // WebSocket
  BrainCloudWebSocket? _webSocket;

  // TCP
  /// for class interface compatibility purpose only, TCP not use on WEB
  Uint8List get tcpReadBuffer => Uint8List(MAX_PACKET_SIZE);

  // ASync TCP Reads
  int _tcpBytesRead = 0; // the ones already processed
  int get tcpBytesRead => _tcpBytesRead;
  int _tcpBytesToRead = 0; // the number to finish reading
  int get tcpBytesToRead => _tcpBytesToRead;
  Uint8List _tcpHeaderReadBuffer = Uint8List(SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY);
  Uint8List get tcpHeaderReadBuffer => _tcpHeaderReadBuffer;

  // ASync TCP Writes
  dynamic fLock;
  Queue<Uint8List> fToSend = Queue<Uint8List>();

  // Packet history
  List<int> _rsmgHistory = [];
  Uint8List get rsmgHistory => Uint8List.fromList(_rsmgHistory);
  Map<int, Map<int, int>> _sendPacketId = {};
  Map<int, int> _recvPacketId = {};
  Map<int, int> get recvPacketId => _recvPacketId;
  Map<int, _UDPPacket> _reliables = {};
  Map<int, List<_UDPPacket>> _orderedReliablePackets = {};
  Map<int, List<_UDPPacket>> get orderedReliablePackets =>
      _orderedReliablePackets;
  Map<int, Map<int, int>> _trackedPacketIds = {};
  // end

  bool _endMatchRequested = false;
  DateTime _lastConnectResendTime = DateTime.now();
  DateTime get lastConnectResendTime => _lastConnectResendTime;
  static const int CONTROL_BYTE_HEADER_LENGTH = 1;
  static const int SIZE_OF_RELIABLE_FLAGS = 2;

  static const int RELIABLE_BIT = 0x8000;
  static const int ORDERED_BIT = 0x4000;

  int _lastPingTime = DateTime.now().millisecondsSinceEpoch;
  Uint8List DISCONNECT_ARR = Uint8List.fromList([CL2RS_DISCONNECT]);
  Uint8List CONNECT_ARR = Uint8List.fromList([CL2RS_CONNECT]);
  Uint8List ENDMATCH_ARR = Uint8List.fromList([CL2RS_ENDMATCH]);

  // success callbacks
  SuccessCallback? _connectedSuccessCallback;
  FailureCallback? _connectionFailureCallback;

  RelayCallback? _registeredRelayCallback;
  RelaySystemCallback? _registeredSystemCallback;

  /// Last Synced Ping
  late int _ping;
  int get getPing => _ping;

  RelayComms(this._clientRef);

  void connect(
      RelayConnectionType inConnectionType,
      RelayConnectOptions inOptions,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure) async {
    if (_isConnected) {
      switch (_connectionType) {
        case RelayConnectionType.tcp:
          if (kIsWeb)
            throw ("Relay service only support WebSocket on Web deployment.");
          break;
        case RelayConnectionType.udp:
          if (kIsWeb)
            throw ("Relay service only support WebSocket on Web deployment.");
          break;
        case RelayConnectionType.websocket:
          _webSocket?.close();
          break;
        default:
      }
    }
    _connectionType = inConnectionType;
    _ping = 999;
    _endMatchRequested = false;
    _connectOptions = inOptions;
    _connectedSuccessCallback = inSuccess;
    _connectionFailureCallback = inFailure;
    _sendPacketId.clear();
    _recvPacketId.clear();
    _reliables.clear();
    _rsmgHistory.clear();
    _trackedPacketIds.clear();
    _orderedReliablePackets.clear();

    bool sslEnabled = _connectOptions.ssl;
    String host = _connectOptions.host;
    int port = _connectOptions.port;

    switch (_connectionType) {
      case RelayConnectionType.websocket:
        {
          _connectWebSocket(host, port, sslEnabled);
        }
        break;
      default:
        break;
    }
  }

  void disconnect() {
    if (_isConnected) {
      _send(_buildDisconnectRequest());
      _disconnect();
    }
  }

  void endMatch(Map<String, dynamic> json) {
    if (this._isConnected) {
      this._send(_buildEndMatchRequest(json));
      _endMatchRequested = true;
    }
  }

  bool get isConnected => _isConnected;

  void registerRelayCallback(RelayCallback inCallback) {
    this._registeredRelayCallback = inCallback;
  }

  void deregisterRelayCallback() {
    this._registeredRelayCallback = null;
  }

  void registerSystemCallback(RelaySystemCallback inCallback) {
    this._registeredSystemCallback = inCallback;
  }

  void deregisterSystemCallback() {
    this._registeredSystemCallback = null;
  }

  void queueError(String error) {
    _queueErrorEvent(error);
  }

int reverseBits8(int value) {
    int num = value & 0xFF;
    int reversed = 0;
    for (int i = 0; i < 8; i++) {
        reversed = (reversed << 1) | (num & 1); // Shift left and add the least significant bit
        num >>= 1; // Shift the input number to the right
    }
    return reversed;
}

List<int> splitToBytes40(int number) {
    var value = number & 0x0000FFFFFFFFFF;    
    List<int>  bytes = [];
    for (var i = 0; i < 6; i++) {
        bytes.add(reverseBits8(value >> (i * 8)) & 0xFF); // Extract each byte
    }
    return bytes; // Big-endian order
}

int bytesToInt40(List<int> bytes) {
    if (bytes.length < 6) {
        throw new Exception("Byte array must have at lease 6 elements.");
    }
    var number = 0;
    for (var i = 0; i < bytes.length; i++) {    
      number += (reverseBits8(bytes[i]) << (i * 8));
    }
    return number;
}


  void send(Uint8List inData, int inPlayerMask, bool inReliable, bool inOrdered,
      int inChannel) {
    if (!_isConnected) return;
    if (inData.length > MAX_PACKET_SIZE) {
      disconnect();
      _queueErrorEvent(
          "Relay Error: Packet is too big  ${inData.length} > max $MAX_PACKET_SIZE");
      return;
    }

    List<int> playerMaskBytes = splitToBytes40(inPlayerMask);

    // Control Byte
    Uint8List controlByteHeader = Uint8List.fromList([CL2RS_RELAY]);

    // Reliable header
    int rh = 0;
    if (inReliable) rh |= RELIABLE_BIT;
    if (inOrdered) rh |= ORDERED_BIT;
    rh |= ((inChannel << 12) & 0x3000);

    // Due to JS limitation of 32bits we separate the reliable header and the player mask in 2 dim array.
    // Packet Id
    int packetId = 0;
    if (_sendPacketId.containsKey(rh)) {
      if (_sendPacketId[rh]?.containsKey(inPlayerMask) ?? false) {
        packetId = _sendPacketId[rh]?[inPlayerMask] ?? packetId;
      }
    } else {
      _sendPacketId[rh] = {};
    } 
    _sendPacketId[rh]?[inPlayerMask] = (packetId + 1) & _MAX_PACKET_ID;

    // Add packet id to the header, then encode
    rh |= packetId;

    int header0, header1, header2, header3, header4, header5, header6, header7;

    header0 = (rh >> 8);
    header1 = (rh >> 0);
    header2 = playerMaskBytes[0] & 0xFF;
    header3 = playerMaskBytes[1] & 0xFF;
    header4 = playerMaskBytes[2] & 0xFF;
    header5 = playerMaskBytes[3] & 0xFF;
    header6 = playerMaskBytes[4] & 0xFF;
    header7 = playerMaskBytes[5] & 0xFF;

    Uint8List ackIdData = Uint8List.fromList([
      header0,
      header1,
      header2,
      header3,
      header4,
      header5,
      header6,
      header7
    ]);

    // Rest of data
    Uint8List header = _concatenateByteArrays(controlByteHeader, ackIdData);
    Uint8List packetData = _concatenateByteArrays(header, inData);

    _send(packetData);
  }

  void setPingInterval(int inIntervalSec) {
    this._pingIntervalMs = inIntervalSec * 1000;
  }

  String? getOwnerProfileId() {
    List<String> splits = _ownerCxId.split(":");
    if (splits.length != 3) return null;
    return splits[1];
  }

  String? getProfileIdForNetId(int netId) {
    if (_netIdToCxId.containsKey(netId)) {
      String? cxId = _netIdToCxId[netId];
      if (cxId != null) {
        List<String> splits = cxId.split(':');
        if (splits.length != 3) {
          return null;
        }
        return splits[1];
      }
    }
    return null;
  }

  int getNetIdForProfileId(String profileId) {
    int result = INVALID_NET_ID;
    _cxIdToNetId.forEach((key, value) {
      List<String> splits = key.split(':');
      if (splits.length == 3 && profileId == splits[1]) {
        result = value;
      }
    });
    return result;
  }

  String getOwnerCxId() => _ownerCxId;

  String? getCxIdForNetId(int netId) => _netIdToCxId[netId];

  int getNetIdForCxId(String cxId) => _cxIdToNetId[cxId] ?? INVALID_NET_ID;

  /// Callbacks responded to on the main thread
  update() {
    // ** Resend connect request **
    // A UDP client needs to resend that until a confirmation is received that they are connected.
    // A subsequent connection request will just be ignored if already connected.
    // Re-transmission doesn't need to be high frequency. A suitable interval could be 500ms.

    DateTime nowMS = DateTime.now();
    if (_isConnected) {
      // Ping
      // if ((DateTime.now().millisecondsSinceEpoch - _lastPingTime) >= _pingIntervalMs) {
      if (nowMS.millisecondsSinceEpoch - _lastPingTime >= _pingIntervalMs) {
        _sendPing();
      }
    }

    // Perform event callbacks
    for (int i = 0;
        i < 10 && _events.length > 0;
        ++i) // Events can trigger other events, we want to consume as fast as possible. Add loop cap in case get stuck
    {
      List<_Event> eventsCopy = [];
      eventsCopy = _events;
      _events = [];

      for (int j = 0; j < eventsCopy.length; ++j) {
        _Event evt = eventsCopy[j];
        switch (evt.type) {
          case _EventType.socketData:
            if (evt.data != null) _onRecv(evt.data!);
            break;
          case _EventType.socketError:
            disconnect();
            _queueErrorEvent(evt.message);
            break;
          case _EventType.socketConnected:
            {
              _send(_buildConnectionRequest());
              break;
            }
          case _EventType.connectSuccess:
            if (_connectedSuccessCallback != null) {
              var callback =
                  _connectedSuccessCallback; // prevent multiple call back
              _connectedSuccessCallback = null; // prevent multiple call back
              callback!(jsonDecode(evt.message));
            }
            break;
          case _EventType.connectFailure:
            //When End Match is requested, then the server will close the connection
            if (_connectionFailureCallback != null && !_endMatchRequested) {
              eventsCopy.clear();
              _events.clear();

              var callback = _connectionFailureCallback;
              _connectionFailureCallback = null;

              callback!(200, ReasonCodes.rsEndmatchRequested,
                  _buildRSRequestError(evt.message));
            }
            break;
          case _EventType.system:
            if (_registeredSystemCallback != null) {
              _registeredSystemCallback!(jsonDecode(evt.message));
            }
            break;
          case _EventType.relay:
            if (_registeredRelayCallback != null) {
              // Callback data without headers
              // if (evt.data != null && evt.data!.length > 10) {
              // Uint8List data = evt.data!.sublist(SIZE_OF_ACKID_MESSAGE);
              if (_registeredRelayCallback != null)
                _registeredRelayCallback!(evt.netId!, evt.data!);
            }
            // }
            break;
        }
      }
    }
  }

  /// ==============================================
  /// Helpers ...
  /// ============================
  ///

  void _sendPing() {
    _lastPingTime = DateTime.now().millisecondsSinceEpoch;
    Uint8List data = Uint8List.fromList(
        [CL2RS_PING, (_lastPingTime >> 8) & 0xFF, _lastPingTime & 0xFF]);
    _send(data);
  }

  void _disconnect() {
    _isConnected = false;
    _connectedSuccessCallback = null;
    // _connectedObj = null;

    _connectionType = RelayConnectionType.invalid;

    _cxIdToNetId.clear();
    _netIdToCxId.clear();
    _ownerCxId = "";

    if (!_endMatchRequested) {
      if (_webSocket != null) _webSocket?.close();
      _webSocket = null;
    }

    // cleanup UDP stuff
    _sendPacketId.clear();
    _recvPacketId.clear();
    _reliables.clear();
    _orderedReliablePackets.clear();
  }

  void _onRecv(Uint8List in_packet) {
    // in_data does still have the size prefix here.
    if (in_packet.length < 3) // Any packet is at least 3 bytes
    {
      _queueErrorEvent(
          "Relay Recv Error: packet cannot be smaller than 3 bytes");
      return;
    }

    // Read control byte
    int controlByte = in_packet[SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY];

    // Take action depending on the control byte
    if (controlByte == RS2CL_RSMG) {
      if (in_packet.length < 5) {
        _queueErrorEvent(
            "Relay Recv Error: Packet is smaller than header's size");
        return;
      }
      _onRSMG(in_packet.sublist(3));
    } else if (controlByte == RS2CL_DISCONNECT) {
      disconnect();
      _queueErrorEvent("Relay: Disconnected by server");
    } else if (controlByte == RS2CL_PONG) {
      _onPong();
    } else if (controlByte == RS2CL_ACK) {
      if (in_packet.length < SIZE_OF_ACKID_MESSAGE) {
        _queueErrorEvent(
            "ack packet cannot be smaller than $SIZE_OF_ACKID_MESSAGE bytes");
        return;
      }
    } else if (controlByte == RS2CL_RELAY) {
      if (in_packet.length < SIZE_OF_ACKID_MESSAGE) {
        _queueErrorEvent(
            "Relay packets cannot be smaller than $SIZE_OF_ACKID_MESSAGE bytes");
        return;
      }
      _clientRef
            .log("RELAY RECV:  ${in_packet.length}  bytes, msg: $in_packet}");
      _onRelay(in_packet.sublist(3));
    } else {
      // Invalid packet, throw error
      disconnect();
      _queueErrorEvent("Relay Recv Error: Unknown control byte: $controlByte");
    }
  }

  // bool _packetLE(int a, int b) {
  //   if (a > _PACKET_HIGHER_THRESHOLD && b <= _PACKET_LOWER_THRESHOLD) {
  //     return true;
  //   }
  //   if (b > _PACKET_HIGHER_THRESHOLD && a <= _PACKET_LOWER_THRESHOLD) {
  //     return false;
  //   }
  //   return a <= b;
  // }

  void _onRelay(Uint8List in_data) {
    final ByteData dataView = ByteData.sublistView(in_data);
    int playerMask2 = dataView.getUint16(6);

    int netId = (playerMask2 & 0x00FF).toUnsigned(8);

    // Reconstruct ack id without packet id

    _queueRelayEvent(netId, in_data.sublist(8));
  }

  void _onRSMG(Uint8List in_data) {
    // Here in_data start at the data.

    int stringOffset = 2; // 2 for packet id
    int stringLen = in_data.length - stringOffset;
    if (stringLen == 0) {
      _queueErrorEvent("RSMG cannot be empty");
      return;
    }

    String jsonMessage = String.fromCharCodes(in_data.sublist(stringOffset));
    _clientRef.log("Relay System Msg: $jsonMessage");

    Map<String, dynamic> parsedDict = jsonDecode(jsonMessage);

    switch (parsedDict["op"] as String) {
      case "CONNECT":
        {
          int netId = parsedDict["netId"];
          String cxId = parsedDict["cxId"];
          _cxIdToNetId[cxId] = netId;
          _netIdToCxId[netId] = cxId;
          if (cxId == _clientRef.rttConnectionID && !_isConnected) {
            _ownerCxId = parsedDict["ownerCxId"] as String;
            _isConnected = true;
            _queueConnectSuccessEvent(jsonMessage);
          }
          break;
        }
      case "NET_ID":
        {
          int netId = parsedDict["netId"];
          String cxId = parsedDict["cxId"];

          List<int>? packetIdArray = parsedDict["orderedPacketIds"];
          if (packetIdArray != null) {
            for (int channelID = 0;
                channelID < packetIdArray.length;
                channelID++) {
              int packetID = packetIdArray[channelID];
              if (packetID != 0) {
                _trackedPacketIds[channelID]?[netId] = packetID;
                _clientRef.log(
                    "Added tracked packetId ${packetID} for netID ${netId} at channel ${channelID}");
              }
            }
          }

          _cxIdToNetId[cxId] = netId;
          _netIdToCxId[netId] = cxId;
          break;
        }
      case "MIGRATE_OWNER":
        {
          _ownerCxId = parsedDict["cxId"] as String;
          break;
        }
      case "DISCONNECT":
        {
          String cxId = parsedDict["cxId"];
          if (cxId == _clientRef.rttService.getRTTConnectionID()) {
            // We are the one that got disconnected!
            disconnect();
            _queueErrorEvent("Relay: Disconnected by server");
            return;
          }
          break;
        }
      case "END_MATCH":
        {
          _endMatchRequested = true;
          disconnect();
          break;
        }
    }

    _queueSystemEvent(jsonMessage);
  }

  void _onPong() {
    _ping = DateTime.now().millisecondsSinceEpoch - _lastPingTime;
    _clientRef.log("Relay LastPing: $_ping ms");
  }

  void _queueSocketErrorEvent(String message) {
    var evt = new _Event(type: _EventType.socketError, message: message);
    _events.add(evt);
  }

  void _queueErrorEvent(String message) {
    var evt = _Event(type: _EventType.connectFailure, message: message);
    _events.add(evt);
  }

  void _queueSystemEvent(String jsonString) {
    var evt = _Event(type: _EventType.system, message: jsonString);
    _events.add(evt);
  }

  void _queueRelayEvent(int netId, Uint8List data) {
    var evt = _Event(type: _EventType.relay, netId: netId, data: data);
    _events.add(evt);
  }

  void _queueSocketDataEvent(Uint8List data) {
    var evt = _Event(type: _EventType.socketData, data: data);
    _events.add(evt);
  }

  void _queueSocketConnectedEvent() {
    _Event evt = new _Event(type: _EventType.socketConnected);
    _events.add(evt);
  }

  void _queueConnectSuccessEvent(String jsonString) {
    var evt = _Event(type: _EventType.connectSuccess, message: jsonString);
    _events.add(evt);
  }

  bool _send(Uint8List data) {
    bool bMessageSent = false;
    // early return, based on type
    switch (_connectionType) {
      case RelayConnectionType.websocket:
        {
          if (_webSocket == null) {
            return bMessageSent;
          }
        }
        break;
      default:
        break;
    }
    // actually do the send
    try {
      Uint8List newData = _addSizePrefixTo(data);
      switch (_connectionType) {
        case RelayConnectionType.websocket:
          {
            _webSocket?.sendAsync(newData);
            bMessageSent = true;
          }
          break;
        default:
          break;
      }
      _clientRef.log("RELAY SEND:  ${newData.length}  bytes, msg: $newData}");
    } catch (socketException) {
      _clientRef.log("send exception: $socketException");
      _queueSocketErrorEvent(socketException.toString());
    }

    return bMessageSent;
  }

  // Packet helpers

  Uint8List _buildConnectionRequest() {
    Map<String, dynamic> json = {};
    json["cxId"] = _clientRef.rttConnectionID;
    json["lobbyId"] = _connectOptions.lobbyId;
    json["passcode"] = _connectOptions.passcode;
    json["version"] = _clientRef.brainCloudClientVersion;

    Uint8List array = _concatenateByteArrays(CONNECT_ARR,
        Uint8List.fromList(utf8.encode(_clientRef.serializeJson(json))));
    return array;
  }

  Uint8List _buildEndMatchRequest(Map<String, dynamic> inJsonpayload) {
    Uint8List array = _concatenateByteArrays(
        ENDMATCH_ARR,
        Uint8List.fromList(
            utf8.encode(_clientRef.serializeJson(inJsonpayload))));
    return array;
  }

  Map<String, dynamic> _buildRSRequestError(String inStatusmessage) {
    Map<String, dynamic> json = {};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.rsClientError;
    json["status_message"] = inStatusmessage;
    json["severity"] = "ERROR";

    return json;
    // return _clientRef.serializeJson(json);
  }

  Uint8List _buildDisconnectRequest() {
    return DISCONNECT_ARR;
  }

  // Low level Packet helpers

  Uint8List _addSizePrefixTo(Uint8List data) {
    int sizeOfData = data.length + SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY;
    ByteData sizeValue = ByteData(2);
    sizeValue.setInt16(0, sizeOfData, Endian.big);
    Uint8List sizeHeader = sizeValue.buffer.asUint8List();
    return _concatenateByteArrays(sizeHeader, data);
  }

  Uint8List _concatenateByteArrays(Uint8List a, Uint8List b) {
    Uint8List rv = Uint8List(a.length + b.length);
    rv.setRange(0, a.length, a);
    rv.setRange(a.length, b.length + a.length, b);
    return rv;
  }

  /// ==============================================
  ///                 Networking
  /// -----------------------
  /// WebSocket

  void _connectWebSocket(String host, int port, bool sslEnabled) {
    String sslString = sslEnabled ? "wss://" : "ws://";
    String url = "$sslString$host:$port";
    _webSocket = BrainCloudWebSocket(url,
        onClose: _webSocketOnClose,
        onOpen: _websocketOnOpen,
        onMessage: _webSocketOnMessage,
        onError: _websocketOnError);
  }

  void _webSocketOnClose({required int code, required String reason}) {
    if (_endMatchRequested) {
      _clientRef.log("Relay: Connection closed by end match");
    } else {
      _clientRef.log("Relay: Connection closed: $reason");
    }
    _queueErrorEvent(reason);
  }

  void _websocketOnOpen() {
    _clientRef.log("Relay: Connection established.");
    // initial connect call, sets connection requests if not connected
    _queueSocketConnectedEvent();
  }

  void _webSocketOnMessage({required Uint8List data}) {
    _queueSocketDataEvent(data);
  }

  void _websocketOnError({required String message}) {
    _clientRef.log("Relay Error: $message");
    _queueErrorEvent(message);
  }

  // @visibleForTesting
  void rawSend(Uint8List data) => _send(data);
}

enum RelayConnectionType { invalid, websocket, tcp, udp, max }

enum _EventType {
  socketError,
  socketConnected,
  socketData,
  connectSuccess,
  connectFailure,
  relay,
  system
}

class _Event {
  _EventType type;
  String message;
  int? netId;
  Uint8List? data;

  _Event({required this.type, this.message = "", this.netId, this.data});

  @override
  String toString() {
    return "_Event({type: $type, netId: $netId, message:$message, data: $data})";
  }
}

class _UDPPacket {
  _UDPPacket(Uint8List inData, int inChannel, int packetId, int netId) {
    _lastTimeSent = DateTime.now();
    _timeSinceFirstSend = DateTime.now();
    _timeInterval = inChannel <= 1
        ? 50
        : inChannel == 2
            ? 150
            : 250; // ms
    _rawData = inData;
    _id = packetId;
    _netId = netId;
  }

  void updateTimeIntervalSent() {
    _lastTimeSent = DateTime.now();
    _timeInterval = min((timeInterval * 1.25).toInt(),
        RelayComms._MAX_RELIABLE_RESEND_INTERVAL);
  }

  DateTime _timeSinceFirstSend = DateTime.now();
  DateTime _lastTimeSent = DateTime.now();
  late int _timeInterval;
  late Uint8List _rawData;
  late int _id;
  int? _netId;

  DateTime get timeSinceFirstSend => _timeSinceFirstSend;
  DateTime get lastTimeSent => _lastTimeSent;
  int get timeInterval => _timeInterval;
  Uint8List get rawData => _rawData;
  int get id => _id;
  int? get netId => _netId;
}
