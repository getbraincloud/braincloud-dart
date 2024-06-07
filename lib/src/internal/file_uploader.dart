import 'dart:typed_data';
import 'package:braincloud_dart/src/internal/enums/file_uploader_status.dart';
import 'package:braincloud_dart/src/internal/progress_stream.dart';
import 'package:http/http.dart' as http;

import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/status_codes.dart';

class FileUploader {
  String UploadId;

  double Progress = 0;

  double get BytesTransferred => (TotalBytesToTransfer * Progress);

  int TotalBytesToTransfer = 0;

  FileUploaderStatus Status = FileUploaderStatus.None;

  String Response = "";

  int StatusCode = 0;

  int ReasonCode = 0;

  //Silencing Unity WebPlayer && WebGL Warnings with Pragma Disable: FileUploader not supported on WebPlayer && WebGL
  BrainCloudClient _client;
  String _sessionId;
  String _guidLocalPath;
  String _serverUrl;
  late String fileName;
  String _peerCode;
  int _timeoutThreshold = 50;
  int _timeout = 120;

  //transfer rate
  final double TIME_INTERVAL = 0.25;
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

  //TODO: _request

  //CancellationTokenSource _cancelToken;

  FileUploader(
      this.UploadId,
      this._guidLocalPath,
      this._serverUrl,
      this._sessionId,
      this._timeout,
      this._timeoutThreshold,
      this._client,
      this._peerCode);

  void Start() {
    Uint8List? file = _client.fileService.fileStorage[_guidLocalPath];
    Map<String, dynamic> postForm = {};
    postForm["sessionId"] = _sessionId;

    if (_peerCode != "") {
      postForm["peerCode"] = _peerCode;
    }
    postForm["uploadId"] = UploadId;
    postForm["fileSize"] = file?.length;
    //postForm["uploadFile" = file, _fileName; TODO: fix binay data add

//     #if USE_WEB_REQUEST
//             _request = UnityWebRequest.Post(_serverUrl, postForm);
//             _request.SendWebRequest();
//     #else
//             _request = new WWW(_serverUrl, postForm);
//     #endif
// #else
//             var requestMessage = new HttpRequestMessage()
//             {
//                 RequestUri = new Uri(_serverUrl),
//                 Method = HttpMethod.Post
//             };

//             var requestContent = new MultipartFormDataContent();
//             byte[] fileData = _client.FileService.FileStorage[_guidLocalPath];
//             _client.FileService.FileStorage.Remove(_guidLocalPath);
//             if (fileData == null)
//             {
//                 ThrowError(ReasonCodes.FILE_DOES_NOT_EXIST,"Local path is wrong or file doesn't exist");
//                 return;
//             }
//             ProgressStream fileStream = new ProgressStream(new MemoryStream(fileData));
//             fileStream.BytesRead += BytesReadCallback;

//             requestContent.Add(new StringContent(_sessionId), "sessionId");
//             if (_peerCode != "") requestContent.Add(new StringContent(_peerCode), "peerCode");
//             requestContent.Add(new StringContent(UploadId), "uploadId");
//             requestContent.Add(new StringContent(TotalBytesToTransfer.ToString()), "fileSize");
//             requestContent.Add(new StreamContent(fileStream), "uploadFile", _fileName);

//             requestMessage.Content = requestContent;
//             _cancelToken = new CancellationTokenSource();
//             Task<HttpResponseMessage> httpRequest = HttpClient.SendAsync(requestMessage, _cancelToken.Token);
//             httpRequest.ContinueWith(async (t) =>
//             {
//                 await AsyncHttpTaskCallback(t);
//             });
// #endif
    Status = FileUploaderStatus.Uploading;
    if (_client.loggingEnabled) {
      _client.log("Started upload of " + fileName);
    }
    _lastTime = DateTime.now();
  }

  void AsyncHttpTaskCallback(Future<http.Response> asyncResult) async {
    // if (asyncResult.IsCanceled) return;

    // bool isError = false;
    // http.Response? message;

    // //a callback method to end receiving the data
    // try
    // {
    //     message = asyncResult.Result;
    //     Content content = message.Content;

    //     // End the operation
    //     Response = await content.ReadAsStringAsync();
    //     StatusCode = (int)message.StatusCode;
    //     Status = FileUploaderStatus.CompleteSuccess;
    //     if (_client.LoggingEnabled)
    //     {
    //         _client.Log("Uploaded " + _fileName + " in " + _elapsedTime.ToString("0.0##") + " seconds");
    //     }
    // }
    // catch (WebException wex)
    // {
    //     Response = CreateErrorString(StatusCode, ReasonCode, wex.Message);
    // }
    // catch (Exception ex)
    // {
    //     Response = CreateErrorString(StatusCode, ReasonCode, ex.Message);
    // }

    // if (isError)
    // {
    //     Status = FileUploaderStatus.CompleteFailed;
    //     StatusCode = StatusCodes.CLIENT_NETWORK_ERROR;
    //     ReasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_UNKNOWN;
    // }

    // // Release the HttpResponseMessage
    // if(message != null) message.ispose();
  }

  void BytesReadCallback(dynamic sender, ProgressStreamReportEventArgs args) {
    Progress = args.StreamPosition / args.StreamLength;
  }

  void CancelUpload() {
// #if USE_WEB_REQUEST
//             _request.Abort();
// #elif (!(DOT_NET || GODOT))
//             _request = null;
// #else
//             _cancelToken.Cancel();
// #endif
    Status = FileUploaderStatus.CompleteFailed;
    StatusCode = StatusCodes.CLIENT_NETWORK_ERROR;
    ReasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_CANCELLED;
    Response = CreateErrorString(
        StatusCode, ReasonCode, "Upload of $fileName cancelled by user ");

    if (_client.loggingEnabled) {
      _client.log("Upload of $fileName cancelled by user");
    }
  }

  void Update() {
    UpdateDeltaTime();
    _elapsedTime += _deltaTime;

    UpdateTransferRate();
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

// #if !(DOT_NET || GODOT)
//         void HandleResponse()
//         {
//             _transferRatePerSecond = 0;

// #if USE_WEB_REQUEST
//             StatusCode = (int)_request.responseCode;
// #else
//             if (_request.responseHeaders.ContainsKey("STATUS"))
//             {
//                 String code = _request.responseHeaders["STATUS"].Split(' ')[1];
//                 StatusCode = int.Parse(code);
//             }
//             else StatusCode = StatusCodes.CLIENT_NETWORK_ERROR;
// #endif
//             if (StatusCode != StatusCodes.OK)
//             {
//                 Status = FileUploaderStatus.CompleteFailed;
//                 _client.FileService.FileStorage.Remove(_guidLocalPath);
//                 if (_request.error != null)
//                 {
//                     ReasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_UNKNOWN;
//                     Response = CreateErrorString(StatusCode, ReasonCode, _request.error);
//                 }
//                 else
// #if USE_WEB_REQUEST
//                     Response = _request.downloadHandler.text;
// #else
//                     Response = _request.text;
// #endif
//                 JsonErrorMessage resp = null;

//                 try { resp = JsonReader.Deserialize<JsonErrorMessage>(Response); }
//                 catch (JsonDeserializationException e)
//                 {
//                     if (_client.LoggingEnabled)
//                     {
//                         _client.Log(e.Message);
//                     }
//                 }

//                 if (resp != null)
//                     ReasonCode = resp.reason_code;
//                 else
//                 {
//                     ReasonCode = ReasonCodes.CLIENT_UPLOAD_FILE_UNKNOWN;
//                     Response = CreateErrorString(StatusCode, ReasonCode, Response);
//                 }
//             }
//             else
//             {
//                 Status = FileUploaderStatus.CompleteSuccess;
//                 _client.FileService.FileStorage.Remove(_guidLocalPath);
// #if USE_WEB_REQUEST
//                 Response = _request.downloadHandler.text;
// #else
//                 Response = _request.text;
// #endif
//                 if (_client.LoggingEnabled)
//                 {
//                     _client.Log("Uploaded " + _fileName + " in " + _elapsedTime.ToString("0.0##") + " seconds");
//                 }
//             }

// #if USE_WEB_REQUEST
//             CleanupRequest();
// #endif
//         }
// #endif

  void UpdateTransferRate() {
    _transferElapsedTime += _deltaTime;

    if (_transferElapsedTime > TIME_INTERVAL) {
      _transferRatePerSecond = _transferRatesTotal / _transferElapsedTime;
      _transferRatesTotal = 0;
      _transferElapsedTime = 0;
    } else {
      _transferRatesTotal += BytesTransferred - _lastTransferTotal;
      _lastTransferTotal = BytesTransferred;
    }
  }

  void CheckTimeout() {
    if (_transferRatePerSecond < _timeoutThreshold)
      _timeUnderMinRate += _deltaTime;
    else
      _timeUnderMinRate = 0.0;

    if (_timeUnderMinRate > _timeout)
      ThrowError(ReasonCodes.CLIENT_UPLOAD_FILE_TIMED_OUT,
          "Upload of " + fileName + " failed due to timeout.");
  }

  void UpdateDeltaTime() {
    _deltaTime = DateTime.now()
        .difference(_lastTime)
        .inSeconds
        .toDouble(); //Subtract(_lastTime).TotalSeconds;
    _lastTime = DateTime.now();
  }

  void ThrowError(int reasonCode, String message) {
    Status = FileUploaderStatus.CompleteFailed;
    StatusCode = StatusCodes.CLIENT_NETWORK_ERROR;
    ReasonCode = reasonCode;
    Response = CreateErrorString(StatusCode, ReasonCode, message);
  }

  String CreateErrorString(int statusCode, int reasonCode, String message) {
    return JsonErrorMessage(statusCode, reasonCode, message).toString();
  }

  void CleanupRequest() {
    // if (_request == null) return;
    // _request.Dispose();
    // _request = null;
  }
}
