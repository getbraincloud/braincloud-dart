import 'dart:typed_data';

import 'package:http/http.dart';

enum WebRequestStatus {
  /// Pending status indicating web request is still active

  pending,

  /// Done status indicating web request has completed successfully

  done,

  /// Error status indicating there was a network error or error http code returned

  error
}

class RequestState {
  int packetId = -1;

  DateTime timeSent = DateTime.fromMillisecondsSinceEpoch(0); 

  WebRequestStatus status = WebRequestStatus.pending;

  int retries = 0;

  // we process the signature on the background thread
  String signature = "";

  // we also process the byte array on the background thread
  Uint8List? byteArray;

  bool _isCancelled = false;
  bool get isCancelled => _isCancelled;

  WebRequest? webRequest;

  String requestString = "";

  List<dynamic> messageList = [];

  bool loseThisPacket = false;

  bool packetRequiresLongTimeout = false;

  bool packetNoRetry = false;

  RequestState();

  void cancelRequest() {
    _isCancelled = true;
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
