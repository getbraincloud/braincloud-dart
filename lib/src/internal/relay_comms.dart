import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:braincloud_dart/src/internal/braincloud_websocket.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/braincloud_relay.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';

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
  RelayConnectionType _connectionType = RelayConnectionType.invalid;

  List<_Event> _events = [];
  bool _isConnected = false;
  int _pingIntervalMs = 1000; // one second
  DateTime _lastRecvTime = DateTime.fromMillisecondsSinceEpoch(0);

  static const int _MAX_PACKET_ID_HISTORY = 60 * 10;
  // ^^ So we last 10 seconds at 60 fps
  static const int _MAX_RELIABLE_RESEND_INTERVAL = 500;
  static const int _MAX_PACKET_ID = 0xFFF;
  // static const int MAX_CHANNELS = 4;
  static const double _PACKET_LOWER_THRESHOLD = _MAX_PACKET_ID * 25 / 100;
  static const double _PACKET_HIGHER_THRESHOLD = _MAX_PACKET_ID * 75 / 100;
  static const int SIZE_OF_LENGTH_PREFIX_BYTE_ARRAY = 2;
  static const int SIZE_OF_ACKID_MESSAGE = 11;
  static const int CONNECT_RESEND_INTERVAL_MS = 500;

  static const int MAX_PACKET_SIZE = 1024;
  static const int TIMEOUT_SECONDS = 10;

  String _ownerCxId = "";
  Map<String, int> _cxIdToNetId = {};
  Map<int, String> _netIdToCxId = {};

  // start
  // different connection types
  // WebSocket
  BrainCloudWebSocket? _webSocket;

  // TCP
  Socket? _tcpClient = null;
  Uint8List _tcpReadBuffer = Uint8List(MAX_PACKET_SIZE);
  int _tcpBufferWriteIndex = 0;

  // List<int> _tcpReadBuffer = [];
  // Uint8List get tcpReadBuffer => Uint8List.fromList(_tcpReadBuffer);
  Uint8List get tcpReadBuffer => Uint8List.sublistView(_tcpReadBuffer,0,_tcpBufferWriteIndex);

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

  // UDP
  RawDatagramSocket? _udpClient;
  StreamSubscription<RawSocketEvent>? _udpClientStream;
  InternetAddress? _relayHostAddress;

  // Packet history
  List<int> _rsmgHistory = [];
  Uint8List get rsmgHistory => Uint8List.fromList(_rsmgHistory);
  Map<int, int> _sendPacketId = {};
  Map<int, int> _recvPacketId = {};
  Map<int, int> get recvPacketId => _recvPacketId;
  Map<int, _UDPPacket> _reliables = {};
  Map<int, List<_UDPPacket>> _orderedReliablePackets = {};
  Map<int, List<_UDPPacket>> get orderedReliablePackets =>
      _orderedReliablePackets;
  Map<int,Map<int, int>> _trackedPacketIds = {};
  // end

  bool _resendConnectRequest = false;
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
          _tcpClient?.close();
          break;
        case RelayConnectionType.udp:
          _udpClient?.close();
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
    _resendConnectRequest = false;
    _connectOptions = inOptions;
    _connectedSuccessCallback = inSuccess;
    _connectionFailureCallback = inFailure;
    _sendPacketId.clear();
    _recvPacketId.clear();
    _reliables.clear();
    _rsmgHistory.clear();
    _trackedPacketIds.clear();
    _orderedReliablePackets.clear();
    _udpClientStream = null;
    _udpClient = null;
    _tcpClient = null;
    _relayHostAddress = null;

    bool sslEnabled = _connectOptions.ssl;
    String host = _connectOptions.host;
    int port = _connectOptions.port;
    _relayHostAddress = (await InternetAddress(host));

    switch (_connectionType) {
      case RelayConnectionType.websocket:
        {
          _connectWebSocket(host, port, sslEnabled);
        }
        break;
      case RelayConnectionType.tcp:
        {
          _connectTCPAsync(host, port);
        }
        break;
      case RelayConnectionType.udp:
        {
          _connectUdpAsync(host, port);
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

  void send(Uint8List inData, int inPlayerMask, bool inReliable, bool inOrdered,
      int inChannel) {
    if (!_isConnected) return;
    if (inData.length > MAX_PACKET_SIZE) {
      disconnect();
      _queueErrorEvent(
          "Relay Error: Packet is too big  ${inData.length} > max $MAX_PACKET_SIZE");
      return;
    }

    // Control Byte
    Uint8List controlByteHeader = Uint8List.fromList([CL2RS_RELAY]);

    // Reliable header
    int rh = 0;
    if (inReliable) rh |= RELIABLE_BIT;
    if (inOrdered) rh |= ORDERED_BIT;
    rh |= ((inChannel << 12) & 0x3000);

    // Store inverted player mask
    int playerMask = 0;
    for (int i = 0, len = MAX_PLAYERS; i < len; ++i) {
      playerMask |= ((inPlayerMask >> (MAX_PLAYERS - i - 1)) & 1) << i;
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
    header2 = (playerMask0 >> 8) & 0xFF;
    header3 = playerMask0 & 0xFF;
    header4 = (playerMask1 >> 8) & 0xFF;
    header5 = playerMask1 & 0xFF;
    header6 = (playerMask2 >> 8) & 0xFF;
    header7 = playerMask2 & 0xFF;

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

    // UDP, store reliable in send map
    if (inReliable && _connectionType == RelayConnectionType.udp) {
      _UDPPacket packet = _UDPPacket(packetData, inChannel, packetId, 0);

      int ackId = ackIdData.buffer.asByteData().getUint64(0);
      _reliables[ackId] = packet;
    }
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
    if (_events.length > 0)
    // ** Resend connect request **
    // A UDP client needs to resend that until a confirmation is received that they are connected.
    // A subsequent connection request will just be ignored if already connected.
    // Re-transmission doesn't need to be high frequency. A suitable interval could be 500ms.
    if (_connectionType == RelayConnectionType.udp && _resendConnectRequest) {
      if ((DateTime.now().difference(_lastConnectResendTime)).inMilliseconds >
          CONNECT_RESEND_INTERVAL_MS) {
        _lastConnectResendTime = DateTime.now();
        _send(_buildConnectionRequest());
      }
    }

    DateTime nowMS = DateTime.now();
    if (_isConnected) {
      // Ping
      if (nowMS.millisecondsSinceEpoch - _lastPingTime >= _pingIntervalMs) {
        _sendPing();
      }

      // Process reliable resends
      if (_connectionType == RelayConnectionType.udp) {
        _reliables.values.forEach((value) {
          _UDPPacket packet = value;
          if (packet.timeSinceFirstSend.difference(nowMS).inMilliseconds >
              TIMEOUT_SECONDS) {
            disconnect();
            _queueErrorEvent("Relay d_isConnected, too many packet lost");
            //break;
          }
          if (packet.lastTimeSent.difference(nowMS).inMilliseconds >
              packet.timeInterval) {
            packet.updateTimeIntervalSent();
            _send(packet.rawData);
          }
        }); //for (var kv in _reliables)
      }
    }

    // Check if we timeout
    if (_connectionType == RelayConnectionType.udp &&
        _udpClient != null &&
        nowMS.difference(_lastRecvTime).inSeconds > TIMEOUT_SECONDS) {
      _disconnect();
      _queueErrorEvent("Relay Socket Timeout");
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
            _lastRecvTime = DateTime.now();
            if (evt.data != null) _onRecv(evt.data!);
            break;
          case _EventType.socketError:
            disconnect();
            _queueErrorEvent(evt.message);
            break;
          case _EventType.socketConnected:
            {
              _lastRecvTime = DateTime.now();
              _send(_buildConnectionRequest());

              if (_connectionType == RelayConnectionType.udp) {
                _resendConnectRequest = true;
                _lastConnectResendTime = DateTime.now();
              }
              break;
            }
          case _EventType.connectSuccess:
            if (_connectedSuccessCallback != null) {
               var callback =  _connectedSuccessCallback; // prevent multiple call back
              _connectedSuccessCallback = null; // prevent multiple call back
              callback!({"message": evt.message});
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
              _registeredSystemCallback!(evt.message);
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
    _resendConnectRequest = false;

    _connectionType = RelayConnectionType.invalid;

    _cxIdToNetId.clear();
    _netIdToCxId.clear();
    _ownerCxId = "";

    if (!_endMatchRequested) {
      if (_webSocket != null) _webSocket?.close();
      _webSocket = null;

      if (_tcpClient != null) {
        _tcpClient?.close();
        fToSend.clear();
      }
      _tcpClient = null;

      if (_udpClient != null) _udpClient?.close();
      _udpClient = null;
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
      if (_connectionType == RelayConnectionType.udp) {
        _onUdpAcknowledge(in_packet.sublist(3));
      }
    } else if (controlByte == RS2CL_RELAY) {
      if (in_packet.length < SIZE_OF_ACKID_MESSAGE) {
        _queueErrorEvent(
            "Relay packets cannot be smaller than $SIZE_OF_ACKID_MESSAGE bytes");
        return;
      }
      if (_clientRef.loggingEnabled) {
        _clientRef.log(
            "RELAY RECV:  ${in_packet.length}  bytes, msg: $in_packet}");
      }
      _onRelay(in_packet.sublist(3));
    } else {
      // Invalid packet, throw error
      disconnect();
      _queueErrorEvent("Relay Recv Error: Unknown control byte: $controlByte");
    }
  }

  bool _packetLE(int a, int b) {
    if (a > _PACKET_HIGHER_THRESHOLD && b <= _PACKET_LOWER_THRESHOLD) {
      return true;
    }
    if (b > _PACKET_HIGHER_THRESHOLD && a <= _PACKET_LOWER_THRESHOLD) {
      return false;
    }
    return a <= b;
  }

  void _onRelay(Uint8List in_data) {
    final ByteData dataView = ByteData.sublistView(in_data);
    int rh = dataView.getUint16(0);
    // int playerMask0 = dataView.getUint16(2);
    // int playerMask1 = dataView.getUint16(4);
    int playerMask2 = dataView.getUint16(6);
    int ackId = dataView.getUint64(0);

    int ackIdWithoutPacketId = (ackId & 0xF000FFFFFFFFFFFF).toUnsigned(64);
    bool reliable = ((rh & RELIABLE_BIT) != 0) ? true : false;
    bool ordered = ((rh & ORDERED_BIT) != 0) ? true : false;
    int channel = (rh >> 12) & 0x3;
    int packetId = rh & 0xFFF;
    int netId = (playerMask2 & 0x00FF).toUnsigned(8);

    // Reconstruct ack id without packet id
    if (_connectionType == RelayConnectionType.udp) {
      // Ack reliables, always. An ack might have been previously dropped.
      if (reliable) {
        //extract the data part of the message only.
        _sendAck(in_data);
      }

      if (ordered) {
        int prevPacketId = _MAX_PACKET_ID;
        if (_recvPacketId.containsKey(ackIdWithoutPacketId)) {
          prevPacketId = _recvPacketId[ackIdWithoutPacketId] ?? _MAX_PACKET_ID;
        }

          //look for a tracked packetId in channel for netId
          if (_trackedPacketIds.isNotEmpty &&
              _trackedPacketIds.containsKey(channel) &&
              _trackedPacketIds[channel]!.containsKey(netId))
          {
              prevPacketId = _trackedPacketIds[channel]![netId]!;
              _trackedPacketIds[channel]!.remove(netId);
              if (_clientRef.loggingEnabled)
              {
                  _clientRef.log("Found tracked packetId for channel: ${channel} netId: ${netId} which was ${prevPacketId}");
              }
          }


        if (reliable) {
          if (_packetLE(packetId, prevPacketId)) {
            // We already received that packet if it's lower than the last confirmed
            // packetId. This must be a duplicate
            if (_clientRef.loggingEnabled) {
              _clientRef.log("Duplicated packet from $netId. got $packetId, ignoring it.");
            }
            return;
          }

          // Check if it's out of order, then save it for later
          if (!_orderedReliablePackets.containsKey(ackIdWithoutPacketId)) {
            _orderedReliablePackets[ackIdWithoutPacketId] = [];
          }
          List<_UDPPacket> orderedReliablePackets =
              _orderedReliablePackets[ackIdWithoutPacketId] ?? [];
          if (packetId != ((prevPacketId + 1) & _MAX_PACKET_ID)) {
            if (orderedReliablePackets.length > _MAX_PACKET_ID_HISTORY) {
              disconnect();
              _queueErrorEvent(
                  "Relay disconnected, too many queued out of order packets.");
              return;
            }

            int insertIdx = 0;
            for (; insertIdx < orderedReliablePackets.length; ++insertIdx) {
              var packet = orderedReliablePackets[insertIdx];
              if (packet._id == packetId) {
                if (_clientRef.loggingEnabled) {
                  _clientRef
                      .log("Duplicated packet from $netId. got $packetId");
                }
                return;
              }
              if (_packetLE(packetId, packet._id)) break;
            }
            var newPacket =
                _UDPPacket(in_data.sublist(8), channel, packetId, netId);
            orderedReliablePackets.insert(insertIdx, newPacket);
            if (_clientRef.loggingEnabled) {
              _clientRef.log(
                  "Queuing out of order reliable from $netId. got $packetId");
            }
            return;
          }

          // It's in order, queue event
          _recvPacketId[ackIdWithoutPacketId] = packetId;
          _queueRelayEvent(netId, in_data.sublist(8));

          // Empty previously queued packets if they follow this one
          while (orderedReliablePackets.length > 0) {
            var packet = orderedReliablePackets[0];
            if (packet._id == ((packetId + 1) & _MAX_PACKET_ID)) {
              if (packet._netId != null) {
                _queueRelayEvent(packet._netId!, packet._rawData);
                orderedReliablePackets.removeAt(0);
                packetId = packet._id;
                _recvPacketId[ackIdWithoutPacketId] = packetId;
              }
              continue;
            }
            break; // Out of order
          }
          return;
        } else {
          if (_packetLE(packetId, prevPacketId)) {
            // Just drop out of order packets for unreliables
            if (_clientRef.loggingEnabled) {
              _clientRef.log(
                  "Out of order packet from $netId. Expecting ${((prevPacketId + 1) & _MAX_PACKET_ID)} , got $packetId");
            }
            return;
          }
          _recvPacketId[ackIdWithoutPacketId] = packetId;
        }
      }
    }

    _queueRelayEvent(netId, in_data.sublist(8));
  }

  void _onRSMG(Uint8List in_data) {
    // Here in_data start at the data.
    int rsmgPacketId = in_data.buffer.asByteData().getUint16(0);

    if (_connectionType == RelayConnectionType.udp) {
      // Send ack, always. Even if we already received it
      _sendRSMGAck(rsmgPacketId);

      // If already received, we ignore
      for (int i = 0; i < _rsmgHistory.length; ++i) {
        if (_rsmgHistory[i] == rsmgPacketId) {
          if (_clientRef.loggingEnabled) {
            _clientRef.log("Duplicated System Msg: $rsmgPacketId");
          }
          return;
        }
      }

      // Add to history
      _rsmgHistory.add(rsmgPacketId);

      // Crop to max history
      while (_rsmgHistory.length > MAX_RSMG_HISTORY) {
        _rsmgHistory.removeAt(0);
      }
    }

    int stringOffset = 2; // 2 for packet id
    int stringLen = in_data.length - stringOffset;
    if (stringLen == 0) {
      _queueErrorEvent("RSMG cannot be empty");
      return;
    }

    String jsonMessage = String.fromCharCodes(in_data.sublist(stringOffset));
    if (_clientRef.loggingEnabled) {
      _clientRef.log("Relay System Msg: $jsonMessage");
    }

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
            _resendConnectRequest = false;
            _queueConnectSuccessEvent(jsonMessage);
          }
          break;
        }
      case "NET_ID":
        {
          int netId = parsedDict["netId"];
          String cxId = parsedDict["cxId"];

          List<int>? packetIdArray =  parsedDict["orderedPacketIds"];
          if (packetIdArray != null)
          {
              for (int channelID = 0; channelID < packetIdArray.length; channelID++)
              {
                  int packetID = packetIdArray[channelID];
                  if (packetID != 0)
                  {
                      _trackedPacketIds[channelID]?[netId] = packetID;
                      if (_clientRef.loggingEnabled)
                      {
                          _clientRef.log("Added tracked packetId ${packetID} for netID ${netId} at channel ${channelID}");
                      }
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
    if (_clientRef.loggingEnabled) {
      _clientRef.log("Relay LastPing: $_ping ms");
    }
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
      case RelayConnectionType.tcp:
        {
          if (_tcpClient == null) {
            return bMessageSent;
          }
        }
        break;
      case RelayConnectionType.udp:
        {
          if (_udpClient == null) {
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
        case RelayConnectionType.tcp:
          {
            _tcpClient?.add(newData);
            // _tcpClient?.flush();
            bMessageSent = true;
          }
          break;
        case RelayConnectionType.udp:
          {
            if (_relayHostAddress != null) {
              bMessageSent = _udpSend(newData);
            } else {
              _queueSocketErrorEvent("Missing Server address");
            }
          }
          break;
        default:
          break;
      }
    } catch (socketException) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("send exception: $socketException");
      }
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

  String _buildRSRequestError(String inStatusmessage) {
    Map<String, dynamic> json = {};
    json["status"] = 403;
    json["reason_code"] = ReasonCodes.rsClientError;
    json["status_message"] = inStatusmessage;
    json["severity"] = "ERROR";

    return _clientRef.serializeJson(json);
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
    if (_clientRef.loggingEnabled) {
      if (_endMatchRequested) {
        _clientRef.log("Relay: Connection closed by end match");
      } else {
        _clientRef.log("Relay: Connection closed: $reason");
      }
    }
    _queueErrorEvent(reason);
  }

  void _websocketOnOpen() {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("Relay: Connection established.");
    }
    // initial connect call, sets connection requests if not connected
    _queueSocketConnectedEvent();
  }

  void _webSocketOnMessage({required Uint8List data}) {
    _queueSocketDataEvent(data);
  }

  void _websocketOnError({required String message}) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("Relay Error: $message");
    }
    _queueErrorEvent(message);
  }

  /// -----------------------
  /// TcpSocket

  void _connectTCPAsync(String host, int port) async {
    _tcpClient = await Socket.connect(host, port);
    _tcpClient?.setOption(SocketOption.tcpNoDelay, true);

    if (_clientRef.loggingEnabled) {
      _clientRef.log(
          "Starting TCP connect ASYNC  ${_tcpClient?.remoteAddress} s: ${_tcpClient?.remotePort}");
    }

    if (_tcpClient != null) {
      _tcpClient?.listen(_onTcpRead, onError: _onTcpError, onDone: _onTcpDone);
      _queueSocketConnectedEvent();
      _tcpBytesToRead = 0;
    } else {
      _queueSocketErrorEvent("Could not connect to Relay server $host");
    }
  }

 void _onTcpRead(Uint8List data) {
    // Expand buffer if needed
    if (_tcpBufferWriteIndex + data.length > _tcpReadBuffer.length) {
      final newSize = (_tcpBufferWriteIndex + data.length) * 2;
      final newBuffer = Uint8List(newSize)..setRange(0, _tcpBufferWriteIndex, _tcpReadBuffer);
      _tcpReadBuffer = newBuffer;
    }

    // Add new data to the buffer
    _tcpReadBuffer.setRange(_tcpBufferWriteIndex, _tcpBufferWriteIndex + data.length, data);
    _tcpBufferWriteIndex += data.length;

    // Process messages
    int readIndex = 0;
    while (_tcpBufferWriteIndex - readIndex >= 3) {
      int messageLength = (_tcpReadBuffer[readIndex] << 8) | _tcpReadBuffer[readIndex + 1];
      
      if (_tcpBufferWriteIndex - readIndex >= messageLength) {
        // We must create a new Uint8List here as sublistView refer to the _tcpReadBuffer and can cause issue if more than 1 msg is received.
        Uint8List completeMsg = Uint8List.fromList(Uint8List.sublistView(_tcpReadBuffer, readIndex, readIndex + messageLength));
        _queueSocketDataEvent(completeMsg);
        readIndex += messageLength;
      } else {
        break;
      }
    }

    // Shift unprocessed data to the start of the buffer
    if (readIndex > 0) {
      _tcpReadBuffer.setRange(0, _tcpBufferWriteIndex - readIndex, _tcpReadBuffer, readIndex);
      _tcpBufferWriteIndex -= readIndex;
    }
  }
  void _onTcpError(Object error) {
    _queueErrorEvent("Tcp error ${error.toString()}");
  }

  void _onTcpDone() {
    if (_tcpClient != null) _tcpClient?.close();
    _tcpClient = null;
  }

  /// -----------------------
  /// UdpSocket

  void _connectUdpAsync(String host, int port) async {
    final adrType = _relayHostAddress?.type == InternetAddressType.IPv6
        ? InternetAddress.anyIPv6
        : InternetAddress.anyIPv4;
    _udpClient = await RawDatagramSocket.bind(adrType, 0, reuseAddress: true);
    if (_udpClient != null) {
      _lastRecvTime = DateTime.now();
      _udpClientStream = _udpClient?.listen(_onUdpEvent,
          onError: _onUdpError, onDone: _onUdpDone);
      _queueSocketConnectedEvent();
    }
  }

  void _onUdpAcknowledge(Uint8List in_data) {
    int ackId = in_data.buffer.asByteData().getInt64(0);
    _reliables.remove(ackId);

    if (_clientRef.loggingEnabled) {
      _clientRef.log("RELAY RECV ACK: $ackId");
    }
  }

  bool _udpSend(Uint8List data) {
    if (_relayHostAddress != null && _udpClient != null) {
      int bSent =
          _udpClient!.send(data, _relayHostAddress!, _connectOptions.port);
      return (bSent == data.length);
    }
    return false;
  }

  void _onUdpEvent(RawSocketEvent event) {
    // Check what kind of event this is and proceed
    try {
      switch (event) {
        case RawSocketEvent.read:
          final Datagram? datagram = _udpClient?.receive();
          if (datagram != null) _queueSocketDataEvent(datagram.data);
          // _udpClient?.writeEventsEnabled = true;
          break;
        case RawSocketEvent.write:
          // Indicate ready to sending....
          break;
        case RawSocketEvent.closed:
          _disconnect();
          break;
        default:
          _queueErrorEvent("Unexpected event $event");
      }
    } catch (e) {
      _queueErrorEvent(e.toString());
    }
  }

  void _onUdpError(Object error) {
    _queueErrorEvent("Udp error ${error.toString()}");
  }

  void _onUdpDone() {
    _udpClientStream?.cancel();
    _udpClient?.close();
    _udpClientStream = null;
    _udpClient = null;
  }

  void _sendAck(Uint8List in_data) {
    Uint8List header = Uint8List.fromList([CL2RS_ACK]);
    _send(_concatenateByteArrays(
        header, in_data.sublist(0, SIZE_OF_ACKID_MESSAGE)));
  }

  void _sendRSMGAck(int rsmgPacketId) {
    Uint8List data = Uint8List.fromList(
        [CL2RS_RSMG_ACK, (rsmgPacketId >> 8) & 0xFF, rsmgPacketId & 0xFF]);
    _send(data);
  }
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
