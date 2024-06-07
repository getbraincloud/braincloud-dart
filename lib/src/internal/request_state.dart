import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

enum eWebRequestStatus {
  /// <summary>
  /// Pending status indicating web request is still active
  /// </summary>
  STATUS_PENDING,

  /// <summary>
  /// Done status indicating web request has completed successfully
  /// </summary>
  STATUS_DONE,

  /// <summary>
  /// Error status indicating there was a network error or error http code returned
  /// </summary>
  STATUS_ERROR
}

class RequestState {
  late int PacketId;

  late DateTime TimeSent;

  eWebRequestStatus status = eWebRequestStatus.STATUS_PENDING;

  int Retries = 0;

  // we process the signature on the background thread
  late String Signature;

  // we also process the byte array on the background thread
  Uint8List? ByteArray;

  bool _isCancelled = false;
  bool get IsCancelled => _isCancelled;

  WebRequest? webRequest;

  late String RequestString;

  late List<dynamic> MessageList;

  bool LoseThisPacket = false;

  bool PacketRequiresLongTimeout = false;

  bool PacketNoRetry = false;

  RequestState();

  void CancelRequest() {
    try {
      _isCancelled = true;
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

class WebRequest extends Request {
  Response? response;
  String? error;
  bool get isDone => response != null;

  DownloadHandler? _downloadHandler;
  DownloadHandler? get downloadHandler => _downloadHandler;
  WebRequest(super.method, super.url);
}

class DownloadHandler {
  Response? response;
  bool get isDone => response != null;
}
