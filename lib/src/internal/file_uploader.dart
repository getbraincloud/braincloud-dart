import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/status_codes.dart';

class FileUploader {
  String uploadId;

  double progress = 0;

  int get bytesTransferred => (totalBytesToTransfer * progress).round();

  int totalBytesToTransfer = 0;

  FileUploaderStatus status = FileUploaderStatus.none;

  String response = "";

  int statusCode = 0;

  int reasonCode = 0;

  final BrainCloudClient clientRef;
  final String sessionId;
  final String guidLocalPath;
  final String serverUrl;
  final String fileName;
  final String peerCode;
  final int timeoutThreshold;
  final int timeout;

  //transfer rate
  final double timeInterval = 0.25;
  double _transferElapsedTime = 0;
  double _transferRatesTotal = 0;
  int _lastTransferTotal = 0;
  double _transferRatePerSecond = 0;
  int chunkSize = 2048; // You can adjust the chunk size if needed

  //delta time
  DateTime _lastTime = DateTime.now();
  double _deltaTime = 0;

  //timeout
  double _elapsedTime = 0;
  double _timeUnderMinRate = 0;

  HttpClientRequest? _request;

  //CancellationTokenSource _cancelToken;

  FileUploader({
    required this.uploadId,
    required this.guidLocalPath,
    required this.serverUrl,
    required this.sessionId,
    required this.clientRef,
    required this.peerCode,
    required this.fileName,
    this.timeout = 50,
    this.timeoutThreshold = 120,
  });

  void start() async {
    String boundary =
        '----dartFormBoundary${DateTime.now().millisecondsSinceEpoch}';
    var data = clientRef.fileService.fileStorage[guidLocalPath];
    if (data != null) {
      var uri = Uri.parse(serverUrl);
      _request = await HttpClient().postUrl(uri);
      _request!.bufferOutput = false;
      if (_request != null) {
        Map<String, String> postForm = {};
        postForm["sessionId"] = sessionId;
        if (peerCode != "") {
          postForm["peerCode"] = peerCode;
        }
        postForm["uploadId"] = uploadId;
        postForm["fileSize"] = data.length.toString();

        // Set headers
        _request!.headers.set(HttpHeaders.contentTypeHeader,
            'multipart/form-data; boundary=$boundary');

        // Construct the form data.
        StringBuffer postFormData = StringBuffer();
        postForm.forEach((key, value) {
          postFormData.write('--$boundary\r\n');
          postFormData
              .write('Content-Disposition: form-data; name="$key"\r\n\r\n');
          postFormData.write('$value\r\n');
        });

        // Write the start of the multipart form data for the file
        postFormData.write('--$boundary\r\n');
        postFormData.write(
            'Content-Disposition: form-data; name="file"; filename="$fileName"\r\n');
        postFormData.write('Content-Type: application/octet-stream\r\n\r\n');
        var postFormDataClosing = '\r\n--$boundary--\r\n';

        // Calculate content length
        var contentLength =
            postFormData.length + data.length + postFormDataClosing.length;

        _request!.headers.set(HttpHeaders.contentLengthHeader, contentLength);

        // Write the start of the multipart form data
        _request!.write(postFormData);

        // Stream the data in chunks and monitor progress
        int bytesSent = 0;

        for (int i = 0; i < data.length; i += chunkSize) {
          int end = (i + chunkSize < data.length) ? i + chunkSize : data.length;
          _request!.add(data.sublist(i, end));
          await _request!
              .flush(); // This force the sending of current data and makes the progress report more useful data.
          bytesSent += (end - i);
          progress = bytesSent / data.length;
        }

        // Write the end of the multipart form data
        _request!.write(postFormDataClosing);

        // Send the request
        _request!.close().then(handleResponse).onError<HttpException>((e, s) {
          // Ignore aborted error as it was on purpose
          if (reasonCode != ReasonCodes.clientUploadFileCancelled ||
              e.message != "Request has been aborted") throw (e);
        });
      }
    }
  }

  void cancelUpload() {
    status = FileUploaderStatus.completeFailed;
    statusCode = StatusCodes.clientNetworkError;
    reasonCode = ReasonCodes.clientUploadFileCancelled;
    response = "Upload of $fileName cancelled by user ";
    if (clientRef.loggingEnabled) {
      clientRef.log("Upload of $fileName cancelled by user");
    }
    _request?.abort();
  }

  void update() {
    updateDeltaTime();
    _elapsedTime += _deltaTime;

    updateTransferRate();
  }

  FutureOr handleResponse(HttpClientResponse clientResponse) async {
    _transferRatePerSecond = 0;

    statusCode = clientResponse.statusCode;

    if (statusCode != StatusCodes.ok) {
      status = FileUploaderStatus.completeFailed;
      clientRef.fileService.fileStorage.remove(guidLocalPath);
      if (clientResponse.reasonPhrase.isNotEmpty) {
        reasonCode = ReasonCodes.clientUploadFileUnknown;
        response = clientResponse.reasonPhrase;
      } else {
        response = await clientResponse.transform(utf8.decoder).join();
      }

      JsonErrorMessage? resp;

      try {
        resp = JsonErrorMessage.fromJson(jsonDecode(response));
      } catch (e) {
        if (clientRef.loggingEnabled) {
          clientRef.log(e.toString());
        }
      }

      if (resp != null) {
        reasonCode = resp.reasonCode;
      } else {
        reasonCode = ReasonCodes.clientUploadFileUnknown;
        response = response;
      }
    } else {
      status = FileUploaderStatus.completeSuccess;
      clientRef.fileService.fileStorage.remove(guidLocalPath);

      response = await clientResponse.transform(utf8.decoder).join();

      if (clientRef.loggingEnabled) {
        clientRef.log("Uploaded $fileName in $_elapsedTime seconds");
      }
    }

    cleanupRequest();
  }

  void updateTransferRate() {
    _transferElapsedTime += _deltaTime;

    if (_transferElapsedTime > timeInterval) {
      _transferRatePerSecond = _transferRatesTotal / _transferElapsedTime;
      _transferRatesTotal = 0;
      _transferElapsedTime = 0;
    } else {
      _transferRatesTotal += bytesTransferred - _lastTransferTotal;
      _lastTransferTotal = bytesTransferred;
    }
  }

  void checkTimeout() {
    if (_transferRatePerSecond < timeoutThreshold) {
      _timeUnderMinRate += _deltaTime;
    } else {
      _timeUnderMinRate = 0.0;
    }

    if (_timeUnderMinRate > timeout) {
      throwError(ReasonCodes.clientUploadFileTimedOut,
          "Upload of $fileName failed due to timeout.");
    }
  }

  void updateDeltaTime() {
    _deltaTime = DateTime.now()
        .difference(_lastTime)
        .inSeconds
        .toDouble(); //Subtract(_lastTime).TotalSeconds;
    _lastTime = DateTime.now();
  }

  void throwError(int reasonCode, String message) {
    status = FileUploaderStatus.completeFailed;
    statusCode = StatusCodes.clientNetworkError;
    reasonCode = reasonCode;
    response = message;
    // response = createErrorString(statusCode, reasonCode, message);
  }

  String createErrorString(int statusCode, int reasonCode, String message) {
    return JsonErrorMessage(statusCode, reasonCode, message)
        .toJson()
        .toString();
  }

  void cleanupRequest() {
    _request?.close();
    // if (_request == null) return;
    // _request.Dispose();
    // _request = null;
  }
}

enum FileUploaderStatus {
  none("None"),
  pending("Pending"),
  uploading("Uploading"),
  completeFailed("CompleteFailed"),
  completeSuccess("CompleteSuccess");

  const FileUploaderStatus(this.value);

  final String value;

  static FileUploaderStatus fromString(String s) {
    FileUploaderStatus type = FileUploaderStatus.values
        .firstWhere((e) => e.value == s, orElse: () => FileUploaderStatus.none);

    return type;
  }

  @override
  String toString() => value;
}
