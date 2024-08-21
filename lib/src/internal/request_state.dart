import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

enum WebRequestStatus {
  /// <summary>
  /// Pending status indicating web request is still active
  /// </summary>
  pending,

  /// <summary>
  /// Done status indicating web request has completed successfully
  /// </summary>
  done,

  /// <summary>
  /// Error status indicating there was a network error or error http code returned
  /// </summary>
  error
}

class RequestState {
  late int packetId;

  late DateTime timeSent;

  WebRequestStatus status = WebRequestStatus.pending;

  int retries = 0;

  // we process the signature on the background thread
  late String signature;

  // we also process the byte array on the background thread
  Uint8List? byteArray;

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  WebRequest? webRequest;

  late String requestString;

  late List<dynamic> messageList;

  bool loseThisPacket = false;

  bool packetRequiresLongTimeout = false;

  bool packetNoRetry = false;

  RequestState();

  void cancelRequest() {
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

  UploadHanlder? _uploadHandler;
  UploadHanlder? get uploadHandler => _uploadHandler;

  WebRequest(super.method, super.url);
}

class DownloadHandler {
  Response? response;
  bool get isDone => response != null;
}

class UploadHanlder {
  Response? response;
  bool get isDone => response != null;
}
