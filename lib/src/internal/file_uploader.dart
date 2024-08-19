import 'dart:typed_data';
import 'package:braincloud_dart/src/internal/enums/file_uploader_status.dart';
import 'package:braincloud_dart/src/internal/progress_stream.dart';
import 'package:http/http.dart' as http;

import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/status_codes.dart';

class FileUploader {
  String uploadId;

  double progress = 0;

  double get bytesTransferred => (totalBytesToTransfer * progress);

  int totalBytesToTransfer = 0;

  FileUploaderStatus status = FileUploaderStatus.None;

  String response = "";

  int statusCode = 0;

  int reasonCode = 0;

  //Silencing Unity WebPlayer && WebGL Warnings with Pragma Disable: FileUploader not supported on WebPlayer && WebGL
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
  double _lastTransferTotal = 0;
  double _transferRatePerSecond = 0;

  //delta time
  DateTime _lastTime = DateTime.now();
  double _deltaTime = 0;

  //timeout
  double _elapsedTime = 0;
  double _timeUnderMinRate = 0;

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

  void start() {
    Uint8List? file = clientRef.fileService.fileStorage[guidLocalPath];
    Map<String, String> postForm = {};
    postForm["sessionId"] = sessionId;

    if (peerCode != "") {
      postForm["peerCode"] = peerCode;
    }
    postForm["uploadId"] = uploadId;
    postForm["fileSize"] = file?.length.toString() ?? "";

    http
        .post(Uri.parse(serverUrl), headers: postForm)
        .then((response) => handleResponse(response));

    status = FileUploaderStatus.Uploading;
    if (clientRef.loggingEnabled) {
      clientRef.log("Started upload of $fileName");
    }
    _lastTime = DateTime.now();
  }

  void handleResponse(http.Response response) {
    statusCode = response.statusCode;
    if (clientRef.loggingEnabled) {
      clientRef.log("${"Uploaded $fileName"} in $_elapsedTime seconds");
    }
  }

  void bytesReadCallback(dynamic sender, ProgressStreamReportEventArgs args) {
    progress = args.streamPosition / args.streamLength;
  }

  void cancelUpload() {
// #if USE_WEB_REQUEST
//             _request.Abort();
// #elif (!(DOT_NET || GODOT))
//             _request = null;
// #else
//             _cancelToken.Cancel();
// #endif
    status = FileUploaderStatus.CompleteFailed;
    statusCode = StatusCodes.clientNetworkError;
    reasonCode = ReasonCodes.clientUploadFileCancelled;
    response = createErrorString(
        statusCode, reasonCode, "Upload of $fileName cancelled by user ");

    if (clientRef.loggingEnabled) {
      clientRef.log("Upload of $fileName cancelled by user");
    }
  }

  void update() {
    updateDeltaTime();
    _elapsedTime += _deltaTime;

    updateTransferRate();
// #if !(DOT_NET || GODOT) && (UNITY_IOS || UNITY_ANDROID)
//             CheckTimeout();
// #endif
//             if (Status == FileUploaderStatus.CompleteFailed || Status == FileUploaderStatus.CompleteSuccess)
//             {
// #if !(DOT_NET || GODOT) && USE_WEB_REQUEST
//                 CleanupRequest();
// #endif
//                 return;
//             }

// #if !(DOT_NET || GODOT)
//             Progress = _request.uploadProgress;
//             if (_request.isDone) HandleResponse();
// #endif
  }

  // void handleFileResponse()
  // {
  //     _transferRatePerSecond = 0;

  //     statusCode = response.responseCode;

  //     if (statusCode != StatusCodes.OK)
  //     {
  //         status = FileUploaderStatus.CompleteFailed;
  //         clientRef.fileService.fileStorage.remove(guidLocalPath);
  //         if (_response.error != null)
  //         {
  //             reasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_UNKNOWN;
  //             response = createErrorString(statusCode, reasonCode, _response.error ?? "");
  //         }
  //         else

  //             Response = _response.downloadHandler.text;

  //         JsonErrorMessage resp = null;

  //         try { resp = jsonDecode(Response); }
  //         catch (e)
  //         {
  //             if (clientRef.loggingEnabled)
  //             {
  //                 clientRef.log(e.toString());
  //             }
  //         }

  //         if (resp != null)
  //             ReasonCode = resp.reason_code;
  //         else
  //         {
  //             ReasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_UNKNOWN;
  //             Response = createErrorString(statusCode, reasonCode, response);
  //         }
  //     }
  //     else
  //     {
  //         Status = FileUploaderStatus.CompleteSuccess;
  //         clientRef.fileService.fileStorage.Remove(guidLocalPath);

  //         Response = _response.downloadHandler.text;

  //         if (clientRef.loggingEnabled)
  //         {
  //             clientRef.log("${"Uploaded $fileName in $elapsedTime seconds");
  //         }
  //     }

  //     cleanupRequest();

  // }

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
    status = FileUploaderStatus.CompleteFailed;
    statusCode = StatusCodes.clientNetworkError;
    reasonCode = reasonCode;
    response = createErrorString(statusCode, reasonCode, message);
  }

  String createErrorString(int statusCode, int reasonCode, String message) {
    return JsonErrorMessage(statusCode, reasonCode, message).toString();
  }

  void cleanupRequest() {
    // if (_request == null) return;
    // _request.Dispose();
    // _request = null;
  }
}
