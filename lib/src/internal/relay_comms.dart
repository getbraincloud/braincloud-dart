import 'dart:collection';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:braincloud_dart/src/internal/braincloud_websocket.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_relay.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class RelayComms {
  final BrainCloudClient _clientRef;

  static const MAX_PACKETSIZE = 1024;

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
  RelayConnectionType _connectionType = RelayConnectionType.invalid;

  List<_Event> _events = [];
  bool isConnected = false;
  DateTime _lastNowMS = DateTime.now();
  int _timeSinceLastPingRequest = 0;
  int _pingInterval = 1000; // one second
  DateTime _lastRecvTime = DateTime.fromMicrosecondsSinceEpoch(1);

  static const int _MAX_PACKET_ID_HISTORY =
      60 * 10; // So we last 10 seconds at 60 fps
  static const int _MAX_RELIABLE_RESEND_INTERVAL = 500;
  static const int _MAX_PACKET_ID = 0xFFF;
  static const int _MAX_CHANNELS = 4;
  static const double _PACKET_LOWER_THRESHOLD = _MAX_PACKET_ID * 25 / 100;
  static const double _PACKET_HIGHER_THRESHOLD = _MAX_PACKET_ID * 75 / 100;

  String _ownerCxId = "";
  Map<String, int> _cxIdToNetId = {};
  Map<int, String> _netIdToCxId = {};
  int _netId = INVALID_NET_ID;

  // start
  // different connection types
  // WebSocket
  BrainCloudWebSocket? _webSocket;
  // TCP TODO: find TCP and NetowrkSream for Dart
  // TcpClient _tcpClient = null;
  // NetworkStream _tcpStream = null;
  Uint8List _tcpReadBuffer = Uint8List(MAX_PACKETSIZE);

  // ASync TCP Reads
  static const int SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY = 2;
  int _tcpBytesRead = 0; // the ones already processed
  int _tcpBytesToRead = 0; // the number to finish reading
  Uint8List _tcpHeaderReadBuffer = Uint8List(SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY);

  // ASync TCP Writes
  dynamic fLock;
  Queue<Uint8List> fToSend = Queue<Uint8List>();

  // UDP TODO: find UDB Client for Dart
  //UdpClient _udpClient = null;

  // Packet history
  List<int> _rsmgHistory = [];
  Map<int, int> _sendPacketId = {};
  Map<int, int> _recvPacketId = {};
  Map<int, _UDPPacket> _reliables = {};
  Map<int, List<_UDPPacket>> _orderedReliablePackets = {};
  // end

  bool _resendConnectRequest = false;
  bool _endMatchRequested = false;
  DateTime _lastConnectResendTime = DateTime.now();

  static const int CONTROL_BYTE_HEADER_LENGTH = 1;
  static const int SIZE_OF_RELIABLE_FLAGS = 2;

  static const int RELIABLE_BIT = 0x8000;
  static const int ORDERED_BIT = 0x4000;

  final int _sentPing = DateTime.now().millisecond;
  Uint8List DISCONNECT_ARR = Uint8List(CL2RS_DISCONNECT);
  Uint8List CONNECT_ARR = Uint8List(CL2RS_CONNECT);
  Uint8List ENDMATCH_ARR = Uint8List(CL2RS_ENDMATCH);

  // success callbacks
  SuccessCallback? _connectedSuccessCallback;
  FailureCallback? _connectionFailureCallback;
  dynamic _connectedObj;

  RelayCallback? _registeredRelayCallback;
  RelaySystemCallback? _registeredSystemCallback;

  /// <summary>
  /// Last Synced Ping
  /// </summary>
  late int _ping;
  int get getPing => _ping;

  RelayComms(this._clientRef);

  /// <summary>
  /// Callbacks responded to on the main thread
  /// </summary>
  update() {
    // ** Resend connect request **
    // A UDP client needs to resend that until a confirmation is received that they are connected.
    // A subsequent connection request will just be ignored if already connected.
    // Re-transmission doesn't need to be high frequency. A suitable interval could be 500ms.
    if (_connectionType == RelayConnectionType.udp && _resendConnectRequest) {
      // if ((DateTime.now().difference(_lastConnectResendTime)).inSeconds > 0.5)
      // {
      //     send(buildConnectionRequest());
      //     _lastConnectResendTime = DateTime.now();
      // }
    }

    // Ping
    DateTime nowMS = DateTime.now();
    if (isConnected) {
      _timeSinceLastPingRequest += nowMS.difference(_lastNowMS).inMilliseconds;
      _lastNowMS = nowMS;

      if (_timeSinceLastPingRequest >= _pingInterval) {
        _timeSinceLastPingRequest = 0;
        ping();
      }

      // Process reliable resends
      if (_connectionType == RelayConnectionType.udp) {
        _reliables.values.forEach((value) {
          _UDPPacket packet = value;
          if ((packet.TimeSinceFirstSend - nowMS).Milliseconds > 10000) {
            disconnect();
            queueErrorEvent("Relay disconnected, too many packet lost");
            //break;
          }
          if ((packet.LastTimeSent - nowMS).Milliseconds >
              packet.TimeInterval) {
            packet.UpdateTimeIntervalSent();
            //TODO: send(packet.RawData);
          }
        }); //for (var kv in _reliables)
      }
    }

    // Check if we timeout
    if (_connectionType == RelayConnectionType.udp &&
        nowMS.difference(_lastRecvTime).inMilliseconds > 10000) {
      disconnect();
      queueErrorEvent("Relay Socket Timeout");
    }

    // Perform event callbacks
    for (int i = 0;
        i < 10 && _events.length > 0;
        ++i) // Events can trigger other events, we want to consume as fast as possible. Add loop cap in case get stuck
    {
      List<_Event> eventsCopy = [];
      lock(_events) {
        eventsCopy = _events;
        _events = [];
      }

      for (int j = 0; j < eventsCopy.length; ++j) {
        _Event evt = eventsCopy[j];
        switch (evt.type) {
          case _EventType.SocketData:
            _lastRecvTime = DateTime.now();
            //TODO: onRecv(evt.data);
            break;
          case _EventType.SocketError:
            disconnect();
            queueErrorEvent(evt.message);
            break;
          case _EventType.SocketConnected:
            {
              _lastNowMS = DateTime.now();
              _lastRecvTime = DateTime.now();
              //send(buildConnectionRequest()); TODO: call send

              if (_connectionType == RelayConnectionType.udp) {
                _resendConnectRequest = true;
                _lastConnectResendTime = DateTime.now();
              }
              break;
            }
          case _EventType.ConnectSuccess:
            if (_connectedSuccessCallback != null) {
              _connectedSuccessCallback!(evt.message);
            }
            break;
          case _EventType.ConnectFailure:
            //When End Match is requested, then the server will close the connection
            if (_connectionFailureCallback != null && !_endMatchRequested) {
              eventsCopy.clear();
              lock(_events) {
                _events.Clear();
              }

              var callback = _connectionFailureCallback;
              var callbackObj = _connectedObj;
              _connectionFailureCallback = null;
              _connectedObj = null;
              //TODO: callback(200, ReasonCodes.RS_ENDMATCH_REQUESTED, buildRSRequestError(evt.message), callbackObj);
            }
            break;
          case _EventType.System:
            if (_registeredSystemCallback != null) {
              _registeredSystemCallback!(evt.message);
            }
            break;
          case _EventType.Relay:
            if (_registeredRelayCallback != null) {
              // Callback data without headers
              Uint8List data = Uint8List(evt.data.length - 11);
              //Buffer.BlockCopy(evt.data, 11, data, 0, data.length);
              _registeredRelayCallback!(evt.netId, data);
            }
            break;
        }
      }
    }
  }

  void ping() {
    //TODO:
    // _sentPing = DateTime.now().millisecondsSinceEpoch;
    // int lastPingShort = Convert.ToInt16(_ping * 0.0001);
    // byte data1, data2;
    // fromShortBE(lastPingShort, out data1, out data2);

    // Uint8List dataArr = { data1, data2 };
    // byte target = Convert.ToByte(CL2RS_PING);
    // Uint8List header = { target };

    // Uint8List destination = concatenateByteArrays(header, dataArr);
    // send(destination);
  }

  Uint8List buildConnectionRequest() {
    //TODO:
    // Dictionary<string, object> json = new Dictionary<string, object>();
    // json["cxId"] = m_clientRef.RTTConnectionID;
    // json["lobbyId"] = m_connectOptions.lobbyId;
    // json["passcode"] = m_connectOptions.passcode;
    // json["version"] = m_clientRef.BrainCloudClientVersion;

    // Uint8List array = concatenateByteArrays(CONNECT_ARR, Encoding.ASCII.GetBytes(m_clientRef.SerializeJson(json)));
    Uint8List array = Uint8List(0);
    return array;
  }

  Uint8List buildEndMatchRequest(Map<String, dynamic> in_jsonPayload) {
    Uint8List array = Uint8List(
        0); //TODO: concatenateByteArrays(ENDMATCH_ARR, Encoding.ASCII.GetBytes(m_clientRef.SerializeJson(in_jsonPayload)));
    return array;
  }

  String buildRSRequestError(String in_statusMessage) {
    Map<String, dynamic> json = {};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.RS_CLIENT_ERROR;
    json["status_message"] = in_statusMessage;
    json["severity"] = "ERROR";

    return _clientRef.serializeJson(json);
  }

  Uint8List buildDisconnectRequest() {
    return DISCONNECT_ARR;
  }

  disconnect() {}

  getOwnerProfileId() {}

  queueError(String error) {}

  send(Uint8List inData, int inPlayerMask, bool inReliable, bool inOrdered,
      int inChannel) {
    if (!isConnected) return;
    if (inData.length > MAX_PACKETSIZE) {
      disconnect();
      queueErrorEvent(
          "Packet too big:   ${inData.length} > max $MAX_PACKETSIZE");
      return;
    }

    // NetId
    Uint8List controlByteHeader = Uint8List.fromList([CL2RS_RELAY]);

    // Reliable header
    int rh = 0;
    if (inReliable) rh |= RELIABLE_BIT;
    if (inOrdered) rh |= ORDERED_BIT;
    rh |= ((inChannel << 12) & 0x3000);

    // Store inverted player mask
    int playerMask = 0;
    for (int i = 0, len = MAX_PLAYERS; i < len; ++i) {
      playerMask |= ((playerMask >> (MAX_PLAYERS - i - 1)) & 1) << i;
    }
    playerMask = (playerMask << 8) & 0x0000FFFFFFFFFF00;

    // AckId without packet id
    int ackIdWithoutPacketId = ((rh << 48) & 0xFFFF000000000000) | playerMask;

    // Packet Id
    int packetId = 0;
    if (_sendPacketId.containsKey(ackIdWithoutPacketId)) {
      packetId = _sendPacketId[ackIdWithoutPacketId]!;
    }
    _sendPacketId[ackIdWithoutPacketId] = (packetId + 1) & _MAX_PACKET_ID;

    // Add packet id to the header, then encode
    rh |= packetId;

    int playerMask0 = ((playerMask >> 32) & 0xFFFF);
    int playerMask1 = ((playerMask >> 16) & 0xFFFF);
    int playerMask2 = ((playerMask) & 0xFFFF);

    int header0, header1, header2, header3, header4, header5, header6, header7;

    header0 = (rh >> 8);
    header1 = (rh >> 0);
    header2 = (rh >> 8);
    header3 = (rh >> 0);
    header4 = (rh >> 8);
    header5 = (rh >> 0);
    header6 = (rh >> 8);
    header7 = (rh >> 0);

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

    //send(packetData); TODO: call send

    // UDP, store reliable in send map
    if (inReliable && _connectionType == RelayConnectionType.udp) {
      _UDPPacket packet =
          _UDPPacket(packetData, inChannel, packetId, ByteData(0));

      int ackId = (ackIdData as ByteData).getUint16(0, Endian.little);
      _reliables[ackId] = packet;
    }
  }

  void setPingInterval(int inInterval) {}

  void deregisterSystemCallback() {}

  void registerSystemCallback(RelaySystemCallback inCallback) {}

  void deregisterRelayCallback() {}

  void registerRelayCallback(RelayCallback inCallback) {}

  void EndMatch(Map<String, dynamic> json) {}

  void Connect(
      RelayConnectionType inConnectiontype,
      RelayConnectOptions inOptions,
      SuccessCallback? inSuccess,
      FailureCallback? inFailure,
      cbObject) {}

  int GetNetIdForCxId(String cxId) {
    return -1;
  }

  GetCxIdForNetId(int netId) {}

  GetOwnerCxId() {}

  int GetNetIdForProfileId(String profileId) {
    // _cxIdToNetId.forEach(key, value)
    //           {
    //               List<String> splits = key.Split(':');
    //               if (splits.length != 3) {
    //                 continue;
    //                 }
    //               if (profileId == splits[1]) {
    //                 return value;
    //                 }
    //           }
    return INVALID_NET_ID;
  }

  String? GetProfileIdForNetId(int netId) {
    if (_netIdToCxId.containsKey(netId)) {
      String? cxId = _netIdToCxId[netId];
      List<String>? splits = cxId?.split(':');
      if (splits?.length != 3) {
        return null;
      }
      return splits?[1];
    }
    return null;
  }

  void queueErrorEvent(String message) {
    //TODO:
    // var evt = _Event( _EventType.ConnectFailure, message);

    // lock (_events)
    // {
    //     _events.Add(evt);
    // }
  }

  Uint8List _concatenateByteArrays(Uint8List a, Uint8List b) {
    Uint8List rv = Uint8List(a.length + b.length);
    // Buffer.BlockCopy(a, 0, rv, 0, a.length);
    // Buffer.BlockCopy(b, 0, rv, a.length, b.length);
    return rv;
  }

  int toShortBE(Uint8List byteArr) {
    var offset = SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY + CONTROL_BYTE_HEADER_LENGTH;

    var bytes = Uint8List(2);
    bytes[0] = byteArr[offset + 1];
    bytes[1] = byteArr[offset + 0];

    return (bytes as ByteData).getUint16(0, Endian.little);
  }
}

enum RelayConnectionType { invalid, websocket, tcp, udp, max }

enum _EventType {
  SocketError,
  SocketConnected,
  SocketData,
  ConnectSuccess,
  ConnectFailure,
  Relay,
  System
}

class _Event {
  _EventType type;
  String message;
  int netId;
  List<int> data;

  _Event(this.type, this.message, this.netId, this.data);
}

class _UDPPacket {
  _UDPPacket(
      List<int> inData, int inChannel, int in_packetId, ByteData in_netId) {
    _LastTimeSent = DateTime.now();
    _TimeSinceFirstSend = DateTime.now();
    _TimeInterval = inChannel <= 1
        ? 50
        : inChannel == 2
            ? 150
            : 250; // ms
    _RawData = inData;
    _Id = in_packetId;
    _NetId = in_netId;
  }

  void UpdateTimeIntervalSent() {
    _LastTimeSent = DateTime.now();
    _TimeInterval = min((TimeInterval * 1.25), MAX_RELIABLE_RESEND_INTERVAL);
  }

  DateTime _TimeSinceFirstSend = DateTime.now();
  DateTime _LastTimeSent = DateTime.now();
  late int _TimeInterval;
  late List<int> _RawData;
  late int _Id;
  ByteData? _NetId;

  get TimeSinceFirstSend => _TimeSinceFirstSend;
  get LastTimeSent => _LastTimeSent;
  get TimeInterval => _TimeInterval;
  get RawData => _RawData;
  get Id => _Id;
  get NetId => _NetId;

  final int MAX_PACKET_ID_HISTORY = 60 * 10; // So we last 10 seconds at 60 fps
  final int MAX_RELIABLE_RESEND_INTERVAL = 500;
  static int MAX_PACKET_ID = 0xFFF;
  final int MAX_CHANNELS = 4;
  final int PACKET_LOWER_THRESHOLD = MAX_PACKET_ID * 25 / 100 as int;
  final int PACKET_HIGHER_THRESHOLD = MAX_PACKET_ID * 75 / 100 as int;
}
