import 'dart:convert';
import 'dart:core';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:braincloud_dart/src/internal/enums/file_uploader_status.dart';
import 'package:braincloud_dart/src/internal/wrapper_auth_callback_object.dart';

import 'package:crypto/crypto.dart';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';

import 'package:braincloud_dart/src/internal/end_of_bundle_marker.dart';
import 'package:braincloud_dart/src/internal/file_uploader.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/request_state.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/reason_codes.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/status_codes.dart';
import 'package:mutex/mutex.dart';

part 'braincloud_comms.g.dart';

class ServerCallProcessed {
  late ServerCall serverCall;
  late String data;
}

class BrainCloudComms {
  bool _supportsCompression = true;

  final String JSON_ERROR_MESSAGE =
      "You have exceeded the max json depth, increase the MaxDepth using the MaxDepth variable in BrainCloudClient.dart";
  bool get SupportsCompression => _supportsCompression;

  void EnableCompression(bool compress) => _supportsCompression = compress;

  /// <summary>
  /// Byte size threshold that determines if the message size is something we want to compress or not. We make an initial value, but recevie the value for future calls based on the servers
  ///auth response
  /// </summary>
  int _clientSideCompressionThreshold = 50000;
  int get ClientSideCompressionThreshold => _clientSideCompressionThreshold;

  /// <summary>
  /// The id of _expectedIncomingPacketId when no packet expected
  /// </summary>
  static int NO_PACKET_EXPECTED = -1;

  /// <summary>
  /// Reference to the brainCloud client dynamic
  /// </summary>
  final BrainCloudClient _clientRef;

  /// <summary>
  /// Set to true once Initialize has been called.
  /// </summary>
  bool _initialized = false;

  /// <summary>
  /// Set to false if you want to shutdown processing on the Update.
  /// </summary>
  bool _enabled = true;

  /// <summary>
  /// The next packet id to send
  /// </summary>
  int _packetId = 1;

  /// <summary>
  /// The packet id we're expecting
  /// </summary>
  int _expectedIncomingPacketId = NO_PACKET_EXPECTED;

  /// <summary>
  /// The service calls that are waiting to be sent.
  /// </summary>
  List<ServerCall> _serviceCallsWaiting = [];
  final _serviceCallsWaitingLock = Mutex();

  /// <summary>
  /// The service calls that have been sent for which we are waiting for a reply
  /// </summary>
  List<ServerCall> _serviceCallsInProgress = [];
  final _serviceCallsInProgressLock = Mutex();

  /// <summary>
  /// The service calls in the timeout queue.
  /// </summary>
  List<ServerCall> _serviceCallsInTimeoutQueue = [];
  final _serviceCallsInTimeoutQueueLock = Mutex();

  /// <summary>
  /// The current request state. Null if no request is in progress.
  /// </summary>
  RequestState? _activeRequest;

  /// <summary>
  /// The last time a packet was sent
  /// </summary>
  late DateTime _lastTimePacketSent;

  /// <summary>
  /// How long we wait to send a heartbeat if no packets have been sent or received.
  /// This value is set to a percentage of the heartbeat timeout sent by the authenticate response.
  /// </summary>
  Duration _idleTimeout = Duration(seconds: 5 * 60);

  /// <summary>
  /// The maximum number of messages in a bundle.
  /// This is set to a value from the server on authenticate
  /// </summary>
  int _maxBundleMessages = 10;

  /// <summary>
  /// The maximum number of sequential errors before client lockout
  /// This is set to a value from the server on authenticate
  /// </summary>
  int _killSwitchThreshold = 11;

  ///<summary>
  ///The maximum number of attempts that the client can use
  ///while trying to successfully authenticate before the client
  ///is disabled.
  ///<summary>
  int _identicalFailedAuthAttemptThreshold = 3;

  ///<summary>
  ///The current number of identical failed attempts at authenticating. This
  ///will reset when a successful authentication is made.
  ///<summary>
  int _failedAuthenticationAttempts = 0;

  ///<summary>
  ///A blank reference for response data so we don't need to continually allocate new dictionaries when trying to
  ///make the data blank again.
  ///<summary>
  Map<String, dynamic> _blankResponseData = <String, dynamic>{};

  ///<summary>
  ///An array that stores the most recent response jsons as dictionaries.
  ///<summary>
  final List<Map<String, dynamic>> _recentResponseJsonData = [{}, {}];

  /// <summary>
  /// When we have too many authentication errors under the same credentials,
  /// the client will not be able to try and authenticate again until the timer is up.
  /// </summary>
  Duration _authenticationTimeoutDuration = Duration(seconds: 30);

  /// <summary>
  /// When the authentication timer began
  /// </summary>
  late DateTime _authenticationTimeoutStart;

  /// a checker to see what the packet Id we are receiving is
  int receivedPacketIdChecker = 0;

  /// <summary>
  /// Debug value to introduce packet loss for testing retries etc.
  /// </summary>
  //double _debugPacketLossRate = 0;

  /// <summary>
  /// The event handler callback method
  /// </summary>
  EventCallback? _eventCallback;

  /// <summary>
  /// The reward handler callback method
  /// </summary>
  RewardCallback? _rewardCallback;

  FileUploadSuccessCallback? _fileUploadSuccessCallback;

  FileUploadFailedCallback? _fileUploadFailedCallback;

  FailureCallback? _globalErrorCallback;

  NetworkErrorCallback? _networkErrorCallback;

  List<FileUploader> _fileUploads = [];

  //For handling local session errors
  late int _cachedStatusCode;
  late int _cachedReasonCode;
  late String _cachedStatusMessage;

  //For kill switch
  bool _killSwitchEngaged = false;
  int _killSwitchErrorCount = 0;
  String? _killSwitchService;
  String? _killSwitchOperation;

  bool _authInProgress = false;
  bool get AuthenticateInProgress => _authInProgress;
  set AuthenticateInProgress(bool value) => _authInProgress = value;

  bool _isAuthenticated = false;

  bool get Authenticated => _isAuthenticated;

  int GetReceivedPacketId() => receivedPacketIdChecker;

  void setAuthenticated() {
    _isAuthenticated = true;
  }

  String? _appId;
  String? _sessionId;

  String get AppId => _appId ?? "";
  String get SessionID => _sessionId ?? "";

  String get SecretKey {
    if (AppIdSecretMap.containsKey(AppId)) {
      return AppIdSecretMap[AppId]!;
    } else {
      return "NO SECRET DEFINED FOR '$AppId'";
    }
  }

  late Map<String, String> _appIdSecretMap;
  Map<String, String> get AppIdSecretMap => _appIdSecretMap;

  late String _serverURL;
  String get ServerURL => _serverURL;

  late String _uploadURL;
  String get UploadURL => _uploadURL;

  int UploadLowTransferRateTimeout = 120;

  int UploadLowTransferRateThreshold = 50;

  /// <summary>
  /// A list of packet timeouts. Index represents the packet attempt number.
  /// </summary>
  List<int> packetTimeouts = [15, 20, 35, 50];

  void SetPacketTimeoutsToDefault() {
    packetTimeouts = [15, 20, 35, 50];
  }

  List<int> _listAuthPacketTimeouts = [15, 30, 60];

  int AuthenticationPacketTimeoutSecs = 15;

  bool OldStyleStatusResponseInErrorCallback = false;

  bool _cacheMessagesOnNetworkError = false;
  void EnableNetworkErrorMessageCaching(bool enabled) {
    _cacheMessagesOnNetworkError = enabled;
  }

  bool _blockingQueue = false;

  BrainCloudComms(this._clientRef) {
    _appIdSecretMap = {};
    ResetErrorCache();
  }

  /// <summary>
  /// Initialize the communications library with the specified serverURL and secretKey.
  /// </summary>
  /// <param name="serverURL">Server URL.</param>
  /// /// <param name="appId">AppId</param>
  /// <param name="secretKey">Secret key.</param>
  void Initialize(String serverURL, String appId, String secretKey) {
    ResetCommunication(); //resets comms, packetId and SessionId
    _expectedIncomingPacketId = NO_PACKET_EXPECTED;

    _serverURL = serverURL;

    String suffix = "/dispatcherv2";
    String formatURL = _serverURL.endsWith(suffix)
        ? _serverURL.substring(0, ServerURL.length - suffix.length)
        : ServerURL;

    //get rid of trailing /
    while (formatURL.isNotEmpty && formatURL.endsWith("/")) {
      formatURL = formatURL.substring(0, formatURL.length - 1);
    }

    _uploadURL = formatURL;
    _uploadURL += "/uploader";

    AppIdSecretMap[appId] = secretKey;
    _appId = appId;

    _blockingQueue = false;
    _initialized = true;
  }

  /// <summary>
  /// Initialize the communications library with the specified serverURL and secretKey.
  /// </summary>
  /// <param name="serverURL">Server URL.</param>
  /// <param name="defaultAppId">default appId </param>
  /// /// <param name="appIdSecretMap">map of appId -> secrets, to allow the client to safely switch between apps with secret being secure</param>
  void InitializeWithApps(String serverURL, String defaultAppId,
      Map<String, String> appIdSecretMap) {
    AppIdSecretMap.clear();
    _appIdSecretMap = appIdSecretMap;

    Initialize(serverURL, defaultAppId, AppIdSecretMap[defaultAppId]!);
  }

  void RegisterEventCallback(EventCallback cb) {
    _eventCallback = cb;
  }

  void DeregisterEventCallback() {
    _eventCallback = null;
  }

  void RegisterRewardCallback(RewardCallback cb) {
    _rewardCallback = cb;
  }

  void DeregisterRewardCallback() {
    _rewardCallback = null;
  }

  void RegisterFileUploadCallbacks(
      FileUploadSuccessCallback success, FileUploadFailedCallback failure) {
    _fileUploadSuccessCallback = success;
    _fileUploadFailedCallback = failure;
  }

  void DeregisterFileUploadCallbacks() {
    _fileUploadSuccessCallback = null;
    _fileUploadFailedCallback = null;
  }

  void RegisterGlobalErrorCallback(FailureCallback callback) {
    _globalErrorCallback = callback;
  }

  void DeregisterGlobalErrorCallback() {
    _globalErrorCallback = null;
  }

  void RegisterNetworkErrorCallback(NetworkErrorCallback callback) {
    _networkErrorCallback = callback;
  }

  void DeregisterNetworkErrorCallback() {
    _networkErrorCallback = null;
  }

  /// <summary>
  /// The update method needs to be called periodically to send/receive responses
  /// and run the associated callbacks.
  /// </summary>
  void Update() {
    // basic flow here is to:
    // 1- process existing requests
    // 2- send next request
    // 3- handle heartbeat/timeouts

    if (!_initialized) {
      return;
    }
    if (!_enabled) {
      return;
    }
    if (_blockingQueue) {
      return;
    }

    // process current request
    bool bypassTimeout = false;
    eWebRequestStatus status = eWebRequestStatus.STATUS_PENDING;
    if (_activeRequest != null) {
      status = GetWebRequestStatus(_activeRequest!);
      if (status == eWebRequestStatus.STATUS_ERROR) {
        // Force the timeout to be elapsed because we have completed the request with error
        // or else, do nothing with the error right now - let the timeout code handle it
        bypassTimeout = (_activeRequest!.Retries >=
            GetMaxRetriesForPacket(_activeRequest!));
      } else if (status == eWebRequestStatus.STATUS_DONE) {
        //HttpStatusCode.OK
        if (_activeRequest?.webRequest?.response?.statusCode == 200) {
          ResetIdleTimer();
          HandleResponseBundle(GetWebRequestResponse(_activeRequest));
          DisposeUploadHandler();
          _activeRequest = null;
        }
        //HttpStatusCode.ServiceUnavailable
        else if (_activeRequest?.webRequest?.response?.statusCode == 503 ||
            _activeRequest?.webRequest?.response?.statusCode == 502 ||
            _activeRequest?.webRequest?.response?.statusCode == 504) {
          //Packet in progress
          _clientRef.log("Packet in progress");
          RetryRequest(status, bypassTimeout);
          return;
        } else {
          //Error Callback
          var errorResponse = GetWebRequestResponse(_activeRequest);
          if (_serviceCallsInProgress.isNotEmpty) {
            ServerCall? sc = _serviceCallsInProgress[0];

            ServerCallback? callback = sc.GetCallback;
            if (callback != null) {
              callback.onErrorCallback(
                  404,
                  _activeRequest?.webRequest?.response?.statusCode ??
                      ReasonCodes.UNKNOWN_AUTH_ERROR,
                  errorResponse);
            }
          }
        }
// #elif DOT_NET || GODOT
        //HttpStatusCode.OK
        // if (_activeRequest?.WebRequest.Result.StatusCode == 200)
        // {
        //     ResetIdleTimer();
        //     HandleResponseBundle(GetWebRequestResponse(_activeRequest));
        //     _activeRequest = null;
        // }
        // //HttpStatusCode.ServiceUnavailable
        // else if (_activeRequest.WebRequest.Result.StatusCode == 503)
        // {
        //     //Packet in progress
        //     _clientRef.Log("Packet in progress");
        //     RetryRequest(status, bypassTimeout);
        //     return;
        // }
        // else
        // {
        //     //Error Callback
        //     var errorResponse = GetWebRequestResponse(_activeRequest);
        //     if (_serviceCallsInProgress.isNotEmpty)
        //     {
        //         ServerCallback? sc = _serviceCallsInProgress[0].GetCallback!;
        //         if (sc != null)
        //         {
        //             sc.onErrorCallback(404, _activeRequest.WebRequest.Result.StatusCode, errorResponse);
        //         }
        //     }
        // }
      }
    }

    // is it time for a retry?
    RetryRequest(status, bypassTimeout);

    // is it time for a heartbeat?
    if (_isAuthenticated && !_blockingQueue) {
      if (DateTime.now().difference(_lastTimePacketSent) >= _idleTimeout) {
        SendHeartbeat();
      }
    }

    //if the client is currently locked on authentication calls.
    if (tooManyAuthenticationAttempts()) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("TIMER ON");
        _clientRef.log(
            DateTime.now().difference(_authenticationTimeoutStart).toString());
      }
      //check the timeout, has enough time passed?
      if (DateTime.now().difference(_authenticationTimeoutStart) >=
          _authenticationTimeoutDuration) {
        if (_clientRef.loggingEnabled) {
          _clientRef.log("TIMER FINISHED");
        }
        //if the wait time is up they're free to make authentication calls again
        _killSwitchEngaged = false;
        ResetKillSwitch();
      }
    }

    RunFileUploadCallbacks();
  }

  /// <summary>
  /// Checks the status of active file uploads
  /// </summary>
  void RunFileUploadCallbacks() {
    for (int i = _fileUploads.length - 1; i >= 0; i--) {
      _fileUploads[i].Update();
      if (_fileUploads[i].Status == FileUploaderStatus.CompleteSuccess) {
        _fileUploadSuccessCallback!(
            _fileUploads[i].UploadId, _fileUploads[i].Response);

        if (_clientRef.loggingEnabled) {
          _clientRef.log(
              "Upload success: ${_fileUploads[i].UploadId}  | ${_fileUploads[i].StatusCode} \n ${_fileUploads[i].Response}");
        }
        _fileUploads.removeAt(i);
      } else if (_fileUploads[i].Status == FileUploaderStatus.CompleteFailed) {
        _fileUploadFailedCallback!(
            _fileUploads[i].UploadId,
            _fileUploads[i].StatusCode,
            _fileUploads[i].ReasonCode,
            _fileUploads[i].Response);

        if (_clientRef.loggingEnabled) {
          _clientRef.log(
              "Upload failed: ${_fileUploads[i].UploadId} | ${_fileUploads[i].StatusCode} \n ${_fileUploads[i].Response}");
        }
        _fileUploads.removeAt(i);
      }
    }
  }

  void CancelUpload(String uploadFileId) {
    FileUploader? uploader = GetFileUploader(uploadFileId);
    if (uploader != null) uploader.CancelUpload();
  }

  double GetUploadProgress(String uploadFileId) {
    FileUploader? uploader = GetFileUploader(uploadFileId);
    if (uploader != null)
      return uploader.Progress;
    else
      return -1;
  }

  double GetUploadBytesTransferred(String uploadFileId) {
    FileUploader? uploader = GetFileUploader(uploadFileId);
    if (uploader != null) {
      return uploader.BytesTransferred;
    } else {
      return -1;
    }
  }

  int GetUploadTotalBytesToTransfer(String uploadFileId) {
    FileUploader? uploader = GetFileUploader(uploadFileId);
    if (uploader != null) {
      return uploader.TotalBytesToTransfer;
    } else {
      return -1;
    }
  }

  FileUploader? GetFileUploader(String uploadId) {
    for (int i = 0; i < _fileUploads.length; i++) {
      if (_fileUploads[i].UploadId == uploadId) return _fileUploads[i];
    }

    if (_clientRef.loggingEnabled) {
      _clientRef.log("GetUploadProgress could not find upload ID $uploadId");
    }
    return null;
  }

  /// <summary>
  /// Method fakes a json error from the server and sends
  /// it along to the response callbacks.
  /// </summary>
  /// <param name="status">status.</param>
  /// <param name="reasonCode">reason code.</param>
  /// <param name="statusMessage">status message.</param>
  void TriggerCommsError(int status, int reasonCode, String statusMessage) {
    // error json format is
    // {
    // "reason_code": 40316,
    // "status": 403,
    // "status_message": "Processing exception: Invalid game ID in authentication request",
    // "severity": "ERROR"
    // }

    int numMessagesToReturn = 0;

    _serviceCallsInProgressLock.acquire();
    try {
      numMessagesToReturn = _serviceCallsInProgress.length;
    } finally {
      _serviceCallsInProgressLock.release();
    }

    if (numMessagesToReturn <= 0) {
      numMessagesToReturn =
          1; // for when we want to send to only global error callback
    }

    JsonResponseErrorBundleV2 bundleObj =
        JsonResponseErrorBundleV2(_expectedIncomingPacketId, []);

    for (int i = 0; i < numMessagesToReturn; ++i) {
      bundleObj.responses
          .add(JsonErrorMessage(status, reasonCode, statusMessage));
    }
    String jsonError = _clientRef.serializeJson(bundleObj);
    HandleResponseBundle(jsonError);
  }

  /// <summary>
  /// Shuts down the communications layer.
  /// Make sure to only call this from the main thread!
  /// </summary>
  void ShutDown() {
    _serviceCallsWaitingLock.acquire();
    try {
      _serviceCallsWaiting.clear();
    } finally {
      _serviceCallsWaitingLock.release();
    }

    DisposeUploadHandler();
    _activeRequest = null;

    // and then dump the comms layer
    ResetCommunication();
  }

  // see BrainCloudClient.RetryCachedMessages() docs
  void RetryCachedMessages() {
    if (_blockingQueue) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Retrying cached messages");
      }

      if (_activeRequest != null) {
        // this is definitely an error in the comms lib if it happens.
        // we attempt to cancel it but this is uncharted territory.

        if (_clientRef.loggingEnabled) {
          _clientRef.log(
              "ERROR - retrying cached messages but there is an active request!");
        }
        _activeRequest?.CancelRequest();
        DisposeUploadHandler();
        _activeRequest = null;
      }

      --_packetId;
      _activeRequest = CreateAndSendNextRequestBundle();
      _blockingQueue = false;
    }
  }

  // see BrainCloudClient.FlushCachedMessages() docs
  void FlushCachedMessages(bool sendApiErrorCallbacks) {
    if (_blockingQueue) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Flushing cached messages");
      }

      // try to cancel if request is in progress (shouldn't happen)
      if (_activeRequest != null) {
        _activeRequest?.CancelRequest();
        DisposeUploadHandler();
        _activeRequest = null;
      }

      // then flush the message queues
      List<ServerCall> callsToProcess = [];
      _serviceCallsInTimeoutQueueLock.acquire();
      try {
        for (int i = 0, isize = _serviceCallsInTimeoutQueue.length;
            i < isize;
            ++i) {
          callsToProcess.add(_serviceCallsInTimeoutQueue[i]);
        }
        _serviceCallsInTimeoutQueue.clear();
      } finally {
        _serviceCallsInTimeoutQueueLock.release();
      }

      _serviceCallsWaitingLock.acquire();
      try {
        for (int i = 0, isize = _serviceCallsWaiting.length; i < isize; ++i) {
          callsToProcess.add(_serviceCallsWaiting[i]);
        }
        _serviceCallsWaiting.clear();
      } finally {
        _serviceCallsWaitingLock.release();
      }

      _serviceCallsInProgressLock.acquire();
      try {
        _serviceCallsInProgress.clear(); // shouldn't be anything in here...
      } finally {
        _serviceCallsInProgressLock.release();
      }

      // and send api error callbacks if required
      if (sendApiErrorCallbacks) {
        for (int i = 0, isize = callsToProcess.length; i < isize; ++i) {
          ServerCall sc = callsToProcess[i];
          if (sc.GetCallback != null) {
            sc.GetCallback?.onErrorCallback(
                StatusCodes.CLIENT_NETWORK_ERROR,
                ReasonCodes.CLIENT_NETWORK_ERROR_TIMEOUT,
                "Timeout trying to reach brainCloud server, please check the URL and/or certificates for server");
          }
        }
      }
      _blockingQueue = false;
    }
  }

  void InsertEndOfMessageBundleMarker() {
    AddToQueue(EndOfBundleMarker());
  }

  /// <summary>
  /// Resets the idle timer.
  /// </summary>
  void ResetIdleTimer() {
    _lastTimePacketSent = DateTime.now();
  }

  /// <summary>
  /// Starts timeout of authentication calls.
  /// </summary>
  void ResetAuthenticationTimer() {
    _authenticationTimeoutStart = DateTime.now();
  }

  ///<summary>
  ///keeps track of if the client has made too many authentication attempts.
  ///<summary>
  bool tooManyAuthenticationAttempts() {
    return _failedAuthenticationAttempts >=
        _identicalFailedAuthAttemptThreshold;
  }

  //save profileid and sessionId of response
  void SaveProfileAndSessionIds(
      Map<String, dynamic> responseData, String data) {
    // save the session ID
    String? sessionId = GetJsonString(
        responseData, OperationParam.ServiceMessageSessionId.Value, null);
    if (!sessionId.isEmptyOrNull) {
      _sessionId = sessionId;
      _isAuthenticated = true;
      _authInProgress = false;
    }

    // save the profile Id
    String? profileId =
        GetJsonString(responseData, OperationParam.ProfileId.Value, null);
    if (profileId != null) {
      _clientRef.authenticationService?.profileId = profileId;
    }
  }

  void restoreProfileAndSessionIds(WrapperData data) {
    _sessionId = data.sessionId;
    if (SessionID.isNotEmpty) {
      _isAuthenticated = true;
      _authInProgress = false;
    }
    _clientRef.authenticationService?.profileId = data.profileId;
    _packetId = data.lastPacketId;
    ResetIdleTimer();
  }

  /// <summary>
  /// Handles the response bundle and calls registered callbacks.
  /// </summary>
  /// <param name="jsonData">The received message bundle.</param>
  void HandleResponseBundle(String jsonData) {
    if (_clientRef.loggingEnabled) {
      _clientRef.log("RESPONSE ${DateTime.now()}\n $jsonData");
    }

    JsonResponseBundleV2? bundleObj;

    try {
      bundleObj = JsonResponseBundleV2.fromJson(jsonDecode(jsonData));
    } catch (e) {
      bundleObj = null;
    }

    if (bundleObj == null) {
      _cachedReasonCode = ReasonCodes.JSON_PARSING_ERROR;
      _cachedStatusCode = StatusCodes.CLIENT_NETWORK_ERROR;
      _cachedStatusMessage =
          "Received an invalid json format response, check your network settings.";
      _cacheMessagesOnNetworkError = true;

      _serviceCallsWaitingLock.acquire();
      try {
        if (_serviceCallsInProgress.isNotEmpty) {
          var serverCall = _serviceCallsInProgress[0];
          if (serverCall.GetCallback != null) {
            serverCall.GetCallback?.onErrorCallback(
                _cachedStatusCode, _cachedReasonCode, _cachedStatusMessage);
            _serviceCallsInProgress.removeAt(0);
          }
        }
      } finally {
        _serviceCallsWaitingLock.release();
      }
      _clientRef.log(_cachedStatusMessage);
      return;
    }

    List<Map<String, dynamic>> responseBundle = bundleObj.responses ?? [];
    Map<String, dynamic>? response;
    int receivedPacketId = bundleObj.packetId;
    receivedPacketIdChecker = receivedPacketId;

    // if the receivedPacketId is NO_PACKET_EXPECTED (-1), its a serious error, which cannot be retried
    // errors for whcih NO_PACKET_EXPECTED are:
    // json parsing error, missing packet id, app secret changed via the portal
    if (receivedPacketId != NO_PACKET_EXPECTED &&
        (_expectedIncomingPacketId == NO_PACKET_EXPECTED ||
            _expectedIncomingPacketId != receivedPacketId)) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Dropping duplicate packet");
      }

      for (int j = 0; j < responseBundle.length; ++j) {
        _serviceCallsInProgressLock.acquire();
        try {
          if (_serviceCallsInProgress.isNotEmpty) {
            _serviceCallsInProgress.removeAt(0);
          }
        } finally {
          _serviceCallsInProgressLock.release();
        }
      }
      return;
    }

    _expectedIncomingPacketId = NO_PACKET_EXPECTED;
    List<Object> exceptions = [];

    String data = "";
    ServerCall? sc;
    ServerCallback? callback;
    String service = "";
    String operation = "";
    Map<String, dynamic>? responseData;
    for (int j = 0; j < responseBundle.length; ++j) {
      response = responseBundle[j];
      int statusCode = response["status"];
      data = "";
      responseData = null;
      sc = null;
      callback = null;
      service = "";
      operation = "";
      //
      // It's important to note here that a user error callback *might* call
      // ResetCommunications() based on the error being returned.
      // ResetCommunications will clear the _serviceCallsInProgress List
      // effectively removing all registered callbacks for this message bundle.
      // It's also likely that the developer will want to call authenticate next.
      // We need to ensure that this is supported as it's the best way to
      // reset the brainCloud communications after a session invalid or network
      // error is triggered.
      //
      // This is safe to do from the main thread but just in case someone
      // calls this method from another thread, we lock on _serviceCallsWaiting
      //
      _serviceCallsWaitingLock.acquire();
      try {
        if (_serviceCallsInProgress.isNotEmpty) {
          sc = _serviceCallsInProgress[0];
          _serviceCallsInProgress.removeAt(0);
        }
      } finally {
        _serviceCallsWaitingLock.release();
      }

      // its a success response
      if (statusCode == 200) {
        ResetKillSwitch();
        service = sc!.GetService.Value;
        if (response[OperationParam.ServiceMessageData.Value] != null) {
          responseData = response[OperationParam.ServiceMessageData.Value];
          // send the data back as not formatted
          data = SerializeJson(response);

          if (service == ServiceName.Authenticate.Value ||
              service == ServiceName.Identity.Value) {
            //Reset authenticate timeout
            AuthenticationPacketTimeoutSecs = _listAuthPacketTimeouts[0];
            SaveProfileAndSessionIds(responseData!, data);
          }
        } else {
          data = SerializeJson(response);
        }

        // now try to execute the callback
        callback = sc.GetCallback;
        operation = sc.GetOperation.value;
        bool bIsPeerScriptUploadCall = false;
        try {
          bIsPeerScriptUploadCall = operation ==
                  ServiceOperation.runPeerScript.value &&
              response.containsKey(OperationParam.ServiceMessageData.Value) &&
              (response[OperationParam.ServiceMessageData.Value] as Map)
                  .containsKey("response") &&
              (response[OperationParam.ServiceMessageData.Value]["response"]
                      as Map)
                  .containsKey(OperationParam.ServiceMessageData.Value) &&
              (((response[OperationParam.ServiceMessageData.Value])[
                          "response"])[OperationParam.ServiceMessageData.Value]
                      as Map)
                  .containsKey("fileDetails");
        } on Exception {
          //TODO: debug here: lib/BrainCloud/Internal/braincloud_comms.dart Line 949
          debugPrint(
              "Exception lib/BrainCloud/Internal/braincloud_comms.dart Line 949");
        }

        if (operation == ServiceOperation.fullReset.value ||
            operation == ServiceOperation.logout.value) {
          // we reset the current player or logged out
          // we are no longer authenticated
          _isAuthenticated = false;
          _sessionId = "";
          _clientRef.authenticationService?.clearSavedProfileID();
          ResetErrorCache();
        }
        //either off of authenticate or identity call, be sure to save the profileId and sessionId
        else if (operation == ServiceOperation.authenticate.value) {
          ProcessAuthenticate(responseData!);
        }
        // switch to child
        else if (operation == ServiceOperation.switchToChildProfile.value ||
            operation == ServiceOperation.switchToParentProfile.value) {
          ProcessSwitchResponse(responseData!);
        } else if (operation == ServiceOperation.prepareUserUpload.value ||
            bIsPeerScriptUploadCall) {
          String peerCode =
              bIsPeerScriptUploadCall && sc.GetJsonData!.containsKey("peer")
                  ? sc.GetJsonData!["peer"]
                  : "";
          Map<String, dynamic> fileData = peerCode == ""
              ? responseData!["fileDetails"]
              : responseData!["response"]
                  [OperationParam.ServiceMessageData.Value]["fileDetails"];

          if (fileData.containsKey("uploadId") &&
              fileData.containsKey("localPath")) {
            String uploadId = fileData["uploadId"];
            String guid = fileData["localPath"];
            String fileName = fileData["cloudFilename"];
            var uploader = FileUploader(
                uploadId,
                guid,
                UploadURL,
                SessionID,
                UploadLowTransferRateTimeout,
                UploadLowTransferRateThreshold,
                _clientRef,
                peerCode);

            uploader.fileName = fileName;
            if (_clientRef.fileService.fileStorage.containsKey(guid)) {
              uploader.TotalBytesToTransfer =
                  _clientRef.fileService.fileStorage[guid]?.length ?? 0;
            }

            //TODO:
            //uploader.HttpClient = _httpClient;

            _fileUploads.add(uploader);
            uploader.Start();
          }
        }

        // // only process callbacks that are real
        if (callback != null) {
          try {
            callback.onSuccessCallback(data);
          } catch (e) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log(e.toString());
            }
            exceptions.add(e);
          }
        }

        _failedAuthenticationAttempts = 0;

        // now deal with rewards
        if (_rewardCallback != null && responseData != null) {
          try {
            Map<String, dynamic>? rewards;

            // it's an operation that return a reward
            if (operation == ServiceOperation.authenticate.value) {
              dynamic objRewards;
              if (responseData.containsKey("rewards")) {
                objRewards = responseData["rewards"];
                Map<String, dynamic> outerRewards = objRewards;

                if (outerRewards.containsKey("rewards")) {
                  objRewards = outerRewards["rewards"];
                  Map<String, dynamic> innerRewards = objRewards;
                  if (innerRewards.isNotEmpty) {
                    // we found rewards
                    rewards = outerRewards;
                  }
                }
              }
            } else if (operation == ServiceOperation.update.value ||
                operation == ServiceOperation.trigger.value ||
                operation == ServiceOperation.triggerMultiple.value) {
              dynamic objRewards;
              if (responseData.containsKey("rewards")) {
                objRewards = responseData["rewards"];
                Map<String, dynamic> innerRewards = objRewards;
                if (innerRewards.isNotEmpty) {
                  // we found rewards
                  rewards = responseData;
                }
              }
            }

            if (rewards != null) {
              Map<String, dynamic> theReward = new Map<String, dynamic>();
              theReward["rewards"] = rewards;
              theReward["service"] = service;
              theReward["operation"] = operation;
              Map<String, dynamic> apiRewards = new Map<String, dynamic>();
              List<dynamic> rewardList = [];
              rewardList.add(theReward);
              apiRewards["apiRewards"] = rewardList;

              String rewardsAsJson = _clientRef.serializeJson(apiRewards);

              _rewardCallback!(rewardsAsJson);
            }
          } catch (e, s) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log(s.toString());
            }
            exceptions.add(e);
          }
        }
      } else //if non-200
      {
        String statusMessageObj;
        int reasonCode = 0;
        String errorJson = "";
        callback = sc?.GetCallback;
        operation = sc?.GetOperation.value ?? "";

        //if it was an authentication call
        if (operation == ServiceOperation.authenticate.value) {
          //if we haven't already gone above the threshold and are waiting for the timer or a 200 response to reset things
          if (!tooManyAuthenticationAttempts()) {
            _failedAuthenticationAttempts++;
            if (tooManyAuthenticationAttempts()) {
              ResetAuthenticationTimer();
            }
          }

          _authInProgress = false;
        }

        if (response.containsKey("reason_code")) {
          reasonCode = response["reason_code"];
        }

        if (OldStyleStatusResponseInErrorCallback) {
          if (response.containsKey("status_message")) {
            statusMessageObj = response["status_message"];
            errorJson = statusMessageObj;
          }
        } else {
          errorJson = SerializeJson(response);
        }

        if (reasonCode == ReasonCodes.PLAYER_SESSION_EXPIRED ||
            reasonCode == ReasonCodes.NO_SESSION ||
            reasonCode == ReasonCodes.PLAYER_SESSION_LOGGED_OUT) {
          _isAuthenticated = false;
          _sessionId = "";

          if (_clientRef.loggingEnabled) {
            _clientRef.log(
                "Received session expired or not found, need to re-authenticate");
          }

          // cache error if session related
          _cachedStatusCode = statusCode;
          _cachedReasonCode = reasonCode;

          if (response.containsKey("status_message")) {
            _cachedStatusMessage = response["status_message"];
          }
        }

        if (operation == ServiceOperation.logout.value) {
          if (reasonCode == ReasonCodes.CLIENT_NETWORK_ERROR_TIMEOUT) {
            _isAuthenticated = false;
            _sessionId = "";
            if (_clientRef.loggingEnabled) {
              _clientRef.log(
                  "Could not communicate with the server on logout due to network timeout");
            }
          }
        }

        // now try to execute the callback
        if (callback != null) {
          try {
            callback.onErrorCallback(statusCode, reasonCode, errorJson);
          } catch (e, s) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log(s.toString());
            }
            exceptions.add(e);
          }
        }

        if (_globalErrorCallback != null) {
          dynamic cbObject;
          if (callback != null) {
            cbObject = callback.cbObject;
            // if this is the internal BrainCloudWrapper callback dynamic return the user-supplied
            // callback dynamic instead
            if (cbObject != null && cbObject is WrapperAuthCallbackObject) {
              cbObject = cbObject.cbObject;
            }
          }

          _globalErrorCallback!(statusCode, reasonCode, errorJson);
        }

        if (sc != null) {
          UpdateKillSwitch(
              sc.GetService.Value, sc.GetOperation.value, statusCode);
        }
      }
    }

    if (bundleObj.events != null && _eventCallback != null) {
      Map<String, List<Map<String, dynamic>>> eventsJsonObj = {};
      eventsJsonObj["events"] = bundleObj.events!;
      String eventsAsJson = _clientRef.serializeJson(eventsJsonObj);
      try {
        _eventCallback!(eventsAsJson);
      } catch (e) {
        if (_clientRef.loggingEnabled) {
          _clientRef.log(e.toString());
        }
        exceptions.add(e);
      }
    }

    if (exceptions.isNotEmpty) {
      DisposeUploadHandler();
      _activeRequest = null; // to make sure we don't reprocess this message

      throw Exception(
          "User callback handlers threw ${exceptions.length} exception(s). See the log for callstacks or inner exception for first exception thrown. ${exceptions[0]}");
    }
  }

  void UpdateKillSwitch(String service, String operation, int statusCode) {
    if (statusCode == StatusCodes.CLIENT_NETWORK_ERROR) return;

    if (_killSwitchService == null) {
      _killSwitchService = service;
      _killSwitchOperation = operation;
      _killSwitchErrorCount++;
    } else if (service == _killSwitchService &&
        operation == _killSwitchOperation) _killSwitchErrorCount++;

    if (!_killSwitchEngaged && _killSwitchErrorCount >= _killSwitchThreshold) {
      _killSwitchEngaged = true;
      if (_clientRef.loggingEnabled) {
        _clientRef.log(
            "Client disabled due to repeated errors from a single API call: $service | $operation");
      }
    }

    //Authentication check for kill switch.
    //did the client make an authentication call?
    if (operation == ServiceOperation.authenticate.value) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Failed Authentication Call");
      }

      String num;
      num = _failedAuthenticationAttempts.toString();
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Current number of failed authentications: $num");
      }

      //have the attempts gone beyond the threshold?
      if (tooManyAuthenticationAttempts()) {
        //we have a problem now, it seems they are contiuously trying to authenticate and sending us too many errors.
        //we are going to now engage the killswitch and disable the client. This will act differently however. client will not
        //be able to send an authentication request for a time.
        if (_clientRef.loggingEnabled) {
          _clientRef.log("Too many repeat authentication failures");
        }
        _killSwitchEngaged = true;
        ResetAuthenticationTimer();
      }
    }
  }

  void ResetKillSwitch() {
    _killSwitchErrorCount = 0;
    _killSwitchService = null;
    _killSwitchOperation = null;

    //reset the amount of failed attempts upon a successful attempt
    _failedAuthenticationAttempts = 0;
    _recentResponseJsonData[0] = _blankResponseData;
    _recentResponseJsonData[1] = _blankResponseData;
  }

  /// <summary>
  /// Creates the request state dynamic and sends the message bundle
  /// </summary>
  /// <returns>The and send next request bundle.</returns>
  RequestState? CreateAndSendNextRequestBundle() {
    RequestState? requestState;
    _serviceCallsWaitingLock.acquire();
    try {
      if (_blockingQueue) {
        _serviceCallsInProgress.insertAll(0, _serviceCallsInTimeoutQueue);
        _serviceCallsInTimeoutQueue.clear();
      } else {
        if (_serviceCallsWaiting.isNotEmpty) {
          //put auth first
          ServerCall? call;
          int numMessagesWaiting = _serviceCallsWaiting.length;
          for (int i = 0; i < _serviceCallsWaiting.length; ++i) {
            call = _serviceCallsWaiting[i];
            if (call.runtimeType == EndOfBundleMarker) {
              // if the first message is marker, just throw it away
              if (i == 0) {
                _serviceCallsWaiting.removeAt(0);
                --i;
                --numMessagesWaiting;
                continue;
              } else // otherwise cut off the bundle at the marker and toss marker away
              {
                numMessagesWaiting = i;
                _serviceCallsWaiting.removeAt(i);
                break;
              }
            }

            if (call.GetOperation == ServiceOperation.authenticate) {
              if (i != 0) {
                _serviceCallsWaiting.removeAt(i);
                _serviceCallsWaiting.insert(0, call);
              }

              numMessagesWaiting = 1;
              break;
            }
          }

          if (numMessagesWaiting > _maxBundleMessages) {
            numMessagesWaiting = _maxBundleMessages;
          }

          if (numMessagesWaiting <= 0) {
            return null;
          }

          if (_serviceCallsInProgress.isNotEmpty) {
            // this should never happen
            if (_clientRef.loggingEnabled) {
              _clientRef.log(
                  "ERROR - in progress queue is not empty but we're ready for the next message!");
            }
            _serviceCallsInProgress.clear();
          }

          _serviceCallsInProgress =
              _serviceCallsWaiting.getRange(0, numMessagesWaiting).toList();
          _serviceCallsWaiting.removeRange(0, numMessagesWaiting);
        }
      }

      if (_serviceCallsInProgress.isNotEmpty) {
        requestState = RequestState();

        // prepare json data for server
        List<dynamic> messageList = [];
        bool isAuth = false;

        ServerCall scIndex;
        ServiceOperation? operation;
        ServiceName? service;
        for (int i = 0; i < _serviceCallsInProgress.length; ++i) {
          scIndex = _serviceCallsInProgress[i];
          operation = scIndex.GetOperation;
          service = scIndex.GetService;
          // don't send heartbeat if it was generated by comms (null callbacks)
          // and there are other messages in the bundle - it's unnecessary
          if (service == ServiceName.HeartBeat &&
              operation == ServiceOperation.read &&
              (scIndex.GetCallback == null ||
                  scIndex.GetCallback!.areCallbacksNull())) {
            if (_serviceCallsInProgress.length > 1) {
              _serviceCallsInProgress.removeAt(i);
              --i;
              continue;
            }
          }

          Map<String, dynamic> message = {};
          message[OperationParam.ServiceMessageService.Value] =
              scIndex.GetService.Value;
          message[OperationParam.ServiceMessageOperation.Value] =
              scIndex.GetOperation.value;
          message[OperationParam.ServiceMessageData.Value] =
              scIndex.GetJsonData;

          messageList.add(message);

          if (operation == ServiceOperation.authenticate) {
            requestState.PacketNoRetry = true;
          }

          if (operation == ServiceOperation.authenticate ||
              operation == ServiceOperation.resetEmailPassword ||
              operation == ServiceOperation.resetEmailPasswordAdvanced ||
              operation == ServiceOperation.resetUniversalIdPassword ||
              operation == ServiceOperation.resetUniversalIdPasswordAdvanced) {
            isAuth = true;
          }

          if (operation == ServiceOperation.fullReset ||
              operation == ServiceOperation.logout) {
            requestState.PacketRequiresLongTimeout = true;
          }
        }

        requestState.PacketId = _packetId;
        _expectedIncomingPacketId = _packetId;
        requestState.MessageList = messageList;
        ++_packetId;

        if (!_killSwitchEngaged && !tooManyAuthenticationAttempts()) {
          if (_isAuthenticated || isAuth) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log("SENDING REQUEST");
            }
            InternalSendMessage(requestState);
          } else {
            FakeErrorResponse(requestState, _cachedStatusCode,
                _cachedReasonCode, _cachedStatusMessage);
            requestState = null;
          }
        } else {
          if (tooManyAuthenticationAttempts()) {
            FakeErrorResponse(
                requestState,
                StatusCodes.CLIENT_NETWORK_ERROR,
                ReasonCodes.CLIENT_DISABLED_FAILED_AUTH,
                "Client has been disabled due to identical repeat Authentication calls that are throwing errors. Authenticating with the same credentials is disabled for 30 seconds");
            requestState = null;
          } else {
            FakeErrorResponse(
                requestState,
                StatusCodes.CLIENT_NETWORK_ERROR,
                ReasonCodes.CLIENT_DISABLED,
                "Client has been disabled due to repeated errors from a single API call");
            requestState = null;
          }
        }
      }
    } finally {
      _serviceCallsWaitingLock.release();
    } // unlock _serviceCallsWaiting

    return requestState;
  }

  /// <summary>
  /// Creates a fake response to stop packets being sent to the server without a valid session.
  /// </summary>
  void FakeErrorResponse(RequestState requestState, int statusCode,
      int reasonCode, String statusMessage) {
    Map<String, dynamic> packet = {};
    packet[OperationParam.ServiceMessagePacketId.Value] = requestState.PacketId;
    packet[OperationParam.ServiceMessageSessionId.Value] = SessionID;
    if (AppId.isNotEmpty) {
      packet[OperationParam.ServiceMessageGameId.Value] = AppId;
    }
    packet[OperationParam.ServiceMessageMessages.Value] =
        requestState.MessageList;

    String jsonRequestString = SerializeJson(packet);

    if (_clientRef.loggingEnabled) {
      _clientRef.log(
          "REQUEST Retry( ${requestState.Retries} - ${DateTime.now()}\n $jsonRequestString");
    }

    ResetIdleTimer();

    TriggerCommsError(statusCode, reasonCode, statusMessage);
    DisposeUploadHandler();
    _activeRequest = null;
  }

  String SerializeJson(dynamic payload) {
    return jsonEncode(payload);
    // //Unity doesn't like when we create a new StringBuilder outside of this method.
    // _StringBuilderOutput = new StringBuilder();
    // using (JsonWriter writer = new JsonWriter(_StringBuilderOutput, _writerSettings))
    // {
    //     try
    //     {
    //         writer.Write(payload);
    //     }
    //     catch (JsonSerializationException exception)
    //     {
    //         //Contains will fail if one input is off, so I had to break it up like this for more consistency
    //         //IE: The maxiumum depth of 24 was exceeded. Check forJsonResponseErrorBundleV2 cycles in dynamic graph.
    //         if (exception.Message.Contains("The maxiumum depth") &&
    //             exception.Message.Contains("exceeded"))
    //         {
    //             lock (_serviceCallsInProgress)
    //             {
    //                 if(_serviceCallsInProgress.length> 0)
    //                 {
    //                     for (int i = _serviceCallsInProgress.length- 1; i < 0; --i)
    //                     {
    //                         var serviceCall = _serviceCallsInProgress[i];
    //                         if (serviceCall?.GetCallback() != null)
    //                         {
    //                             serviceCall.GetCallback().OnErrorCallback(900, ReasonCodes.JSON_REQUEST_MAXDEPTH_EXCEEDS_LIMIT, JSON_ERROR_MESSAGE);
    //                             _serviceCallsInProgress.RemoveAt(i);
    //                         }
    //                         else
    //                         {
    //                             _clientRef.Log("JSON Exception: " + JSON_ERROR_MESSAGE, true);
    //                         }
    //                     }
    //                 }
    //                 else
    //                 {
    //                     _clientRef.Log("JSON Exception: " + JSON_ERROR_MESSAGE, true);
    //                 }
    //             }
    //         }
    //         _clientRef.Log("JSON Exception: " + exception.Message, true);
    //     }
    // }

    // return _StringBuilderOutput.ToString();
  }

  Map<String, dynamic> DeserializeJson(String jsonData) {
    // JsonResponseBundleV2 responseBundle = DeserializeJsonBundle(jsonData);
    // if (responseBundle?.responses == null ||
    //     responseBundle.responses.Length == 0)
    // {
    //     return null;
    // }
    // return responseBundle.responses[0];

    return jsonDecode(jsonData);
  }

  /// <summary>
  /// Method creates the web request and sends it immediately.
  /// Relies upon the requestState PacketId and MessageList being
  /// set appropriately.
  /// </summary>
  /// <param name="requestState">Request state.</param>
  Future<void> InternalSendMessage(RequestState requestState) async {
    // #if DOT_NET || GODOT
    //             // During retry, the RequestState is reused so we have to make sure its state goes back to PENDING.
    //             // Unity uses the info stored in the WWW dynamic and it's recreated here so it's not an issue.
    //             requestState.DotNetRequestStatus = RequestState.eWebRequestStatus.STATUS_PENDING;
    // #endif

    // bundle up the data into a String
    Map<String, dynamic> packet = {};
    packet[OperationParam.ServiceMessagePacketId.Value] = requestState.PacketId;
    packet[OperationParam.ServiceMessageSessionId.Value] = SessionID;
    if (AppId.isNotEmpty) {
      packet[OperationParam.ServiceMessageGameId.Value] = AppId;
    }
    packet[OperationParam.ServiceMessageMessages.Value] =
        requestState.MessageList;

    String jsonRequestString = SerializeJson(packet);
    String sig = CalculateMD5Hash("$jsonRequestString$SecretKey");

    Uint8List byteArray = utf8.encode(jsonRequestString);

    requestState.Signature = sig;

    bool compressMessage = SupportsCompression && // compression enabled
        ClientSideCompressionThreshold >= 0 && // server says we can compress
        byteArray.length >=
            ClientSideCompressionThreshold; // and byte array is greater or equal to the threshold

    //if the packet we're sending is larger than the size before compressing, then we want to compress it otherwise we're good to send it. AND we have to support compression
    if (compressMessage) {
      byteArray = Compress(byteArray);
    }

    requestState.ByteArray = byteArray;

    Map<String, String>? headers = {};
    headers["Content-Type"] = "application/json;charset=utf-8";
    headers["X-SIG"] = sig;

    if (AppId.isNotEmpty) {
      headers["X-APPID"] = AppId;
    }

    WebRequest req = WebRequest("POST", Uri.parse(_serverURL));
    req.headers.addAll(headers);
    req.body = jsonRequestString;

    requestState.webRequest = req;

    requestState.webRequest
        ?.send()
        .then((result) => http.Response.fromStream(result).then((response) {
              requestState.webRequest?.response = response;
            }))
        .catchError((e) {
      requestState.webRequest?.error = JsonErrorMessage(StatusCodes.BAD_REQUEST,
              ReasonCodes.INVALID_REQUEST, e.toString())
          .toString();
    });

    // var maps = {
    //   "packetId": 0,
    //   "responses": [
    //     {
    //       "status_message":
    //           "Internal server error (bundle): Index 0 out of bounds for length 0",
    //       "severity": "ERROR",
    //       "status": 500
    //     }
    //   ]
    // };

    requestState.RequestString = jsonRequestString;
    requestState.TimeSent = DateTime.now();

    ResetIdleTimer();

    if (_clientRef.loggingEnabled) {
      _clientRef.log(
          "REQUEST - ${DateTime.now()}\n$jsonRequestString Retry(${requestState.Retries})");
    }
  }

  Uint8List Compress(Uint8List raw) {
    // var outputStream = new MemoryStream();
    // using (var stream = new GZipStream(outputStream, CompressionMode.Compress, true))
    // {
    //     stream.Write(raw, 0, raw.Length);
    // }
    // return outputStream.ToArray();

    // TODO: port this
    return raw;
  }

  Uint8List Decompress(Uint8List compressedBytes) {
    // using (var inputStream = new MemoryStream(compressedBytes))
    // using (var gZipStream = new GZipStream(inputStream, CompressionMode.Decompress))
    // using (var outputStream = new MemoryStream())
    // {
    //     gZipStream.CopyTo(outputStream);
    //     outputStream.Read(compressedBytes, 0, compressedBytes.Length);
    //     return outputStream.ToArray();
    // }

    // TODO: port this
    return compressedBytes;
  }

  /// <summary>
  /// Resends a message bundle. Returns true if sent or
  /// false if max retries has been reached.
  /// </summary>
  /// <returns><c>true</c>, if message was resent, <c>false</c> if max retries hit.</returns>
  /// <param name="requestState">Request state.</param>
  bool ResendMessage(RequestState requestState) {
    if (_activeRequest!.Retries >= GetMaxRetriesForPacket(requestState)) {
      return false;
    }
    ++_activeRequest!.Retries;
    InternalSendMessage(requestState);
    return true;
  }

  /// <summary>
  /// Gets the web request status.
  /// </summary>
  /// <returns>The web request status.</returns>
  /// <param name="requestState">request state.</param>
  eWebRequestStatus GetWebRequestStatus(RequestState requestState) {
    eWebRequestStatus status = eWebRequestStatus.STATUS_PENDING;

    // for testing packet loss, some packets are flagged to be lost
    // and should always return status pending no matter what the real
    // status is
    if (_activeRequest!.LoseThisPacket) {
      return status;
    }

    String error = _activeRequest?.webRequest?.error ?? "";

    if (!error.isEmptyOrNull) {
      status = eWebRequestStatus.STATUS_ERROR;
    } else if (_activeRequest?.webRequest?.downloadHandler?.isDone ?? false) {
      status = eWebRequestStatus.STATUS_DONE;
    } else if (_activeRequest?.webRequest?.isDone ?? false) {
      status = eWebRequestStatus.STATUS_DONE;
    }
    return status;
  }

//         /// <summary>
//         /// Gets the web request response.
//         /// </summary>
//         /// <returns>The web request response.</returns>
//         /// <param name="requestState">request state.</param>
  String GetWebRequestResponse(RequestState? requestState) {
    return requestState?.webRequest?.response?.body ?? "";

//             String response = "";
// #if USE_WEB_REQUEST
//             #if UNITY_2018 || UNITY_2019
//             if (_activeRequest.WebRequest.isNetworkError)
//             {
//                 Debug.LogWarning("Failed to communicate with the server. For example, the request couldn't connect or it could not establish a secure channel");
//             }
//             else if (_activeRequest.WebRequest.isHttpError)
//             {
//                 Debug.LogWarning("Something went wrong, received a isHttpError flag. Examples for this to happen are: failure to resolve a DNS entry, a socket error or a redirect limit being exceeded. When this property returns true, the error property will contain a human-readable String describing the error.");
//             }
//             #elif UNITY_2020_1_OR_NEWER
//             if (_activeRequest.WebRequest.result == UnityWebRequest.Result.ConnectionError)
//             {
//                 Debug.LogWarning("Failed to communicate with the server. For example, the request couldn't connect or it could not establish a secure channel");
//             }
//             else if (_activeRequest.WebRequest.result == UnityWebRequest.Result.ProtocolError)
//             {
//                 Debug.LogWarning("The server returned an error response. The request succeeded in communicating with the server, but received an error as defined by the connection protocol.");
//             }
//             else if (_activeRequest.WebRequest.result == UnityWebRequest.Result.DataProcessingError)
//             {
//                 Debug.LogWarning("Error processing data. The request succeeded in communicating with the server, but encountered an error when processing the received data. For example, the data was corrupted or not in the correct format.");
//             }
//             #endif
//             if (!String.IsNullOrEmpty(_activeRequest.WebRequest.error))
//             {
//                 response = _activeRequest.WebRequest.error;
//             }

//             response = _activeRequest.WebRequest.downloadHandler.text;

//             if (response.Contains("Security violation 47") ||
//                 response.StartsWith("<"))
//             {
//                 Debug.LogWarning("Please re-select app in brainCloud settings, something went wrong");
//             }
// #elif DOT_NET || GODOT
//             response = _activeRequest.DotNetResponseString;
// #endif
  }

  /// <summary>
  /// Method returns the maximum retries for the given packet
  /// </summary>
  /// <returns>The maximum retries for the given packet.</returns>
  /// <param name="requestState">The active request.</param>
  int GetMaxRetriesForPacket(RequestState requestState) {
    if (requestState.PacketNoRetry) {
      return 0;
    }
    return packetTimeouts.length;
  }

  /// <summary>
  /// Method staggers the packet timeout value based on the currentRetry
  /// </summary>
  /// <returns>The packet timeout.</returns>
  /// <param name="requestState">The active request.</param>
  Duration GetPacketTimeout(RequestState requestState) {
    if (requestState.PacketNoRetry) {
      if (DateTime.now().difference(_activeRequest!.TimeSent) >
          Duration(seconds: AuthenticationPacketTimeoutSecs)) {
        for (int i = 0; i < _listAuthPacketTimeouts.length; i++) {
          if (_listAuthPacketTimeouts[i] == AuthenticationPacketTimeoutSecs) {
            if (i + 1 < _listAuthPacketTimeouts.length) {
              AuthenticationPacketTimeoutSecs = _listAuthPacketTimeouts[i + 1];
              break;
            }
          }
        }
      }
      return Duration(seconds: AuthenticationPacketTimeoutSecs);
    }

    int currentRetry = requestState.Retries;
    Duration ret;

    // if this is a delete player, or logout we change the
    // timeout behaviour
    if (requestState.PacketRequiresLongTimeout) {
      // unused as default timeouts are now quite long
    }

    if (currentRetry >= packetTimeouts.length) {
      int secs = 10;
      if (packetTimeouts.isNotEmpty) {
        secs = packetTimeouts[packetTimeouts.length - 1];
      }
      ret = Duration(seconds: secs);
    } else {
      ret = Duration(seconds: packetTimeouts[currentRetry]);
    }

    return ret;
  }

  /// <summary>
  /// Sends the heartbeat.
  /// </summary>
  void SendHeartbeat() {
    ServerCall sc =
        ServerCall(ServiceName.HeartBeat, ServiceOperation.read, null, null);
    AddToQueue(sc);
  }

  /// <summary>
  /// Adds a server call to the internal queue.
  /// </summary>
  /// <param name="call">The server call to execute</param>
  void AddToQueue(ServerCall call) {
    _serviceCallsWaitingLock.acquire();
    try {
      _serviceCallsWaiting.add(call);
    } finally {
      _serviceCallsWaitingLock.release();
    }
  }

  /// <summary>
  /// Enables the communications layer.
  /// </summary>
  /// <param name="value">If set to <c>true</c> value.</param>
  void EnableComms(bool value) {
    _enabled = value;
  }

  /// <summary>
  /// Checks if json is valid then returns json dynamic
  /// </summary>
  /// <param name="jsonData"></param>
  /// <returns></returns>
  JsonResponseBundleV2? DeserializeJsonBundle(String jsonData) {
    if (jsonData.isNullOrWhiteSpace) {
      return null;
    }

    if (jsonData.isEmptyOrNull) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log(
            "ERROR - Incoming packet data was null or empty! This is probably a network issue.");
      }
      return null;
    }

    jsonData = jsonData.trim();
    if ((jsonData.startsWith("{") && jsonData.endsWith("}")) || //For dynamic
        (jsonData.startsWith("[") && jsonData.endsWith("]"))) //For array
    {
      try {
        var obj = jsonDecode(jsonData);

        return JsonResponseBundleV2.fromJson(obj);
      } catch (e) //some other exception
      {
        var ex = e;
        var message = ex.toString();

        //Contains will fail if one input is off, so I had to break it up like this for more consistency
        //IE: The maxiumum depth of 24 was exceeded. Check for cycles in dynamic graph.
        if (message.contains("The maxiumum depth") &&
            message.contains("exceeded")) {
          _serviceCallsInProgressLock.acquire();
          try {
            if (_serviceCallsInProgress.isNotEmpty) {
              for (int i = _serviceCallsInProgress.length - 1; i < 0; --i) {
                var serviceCall = _serviceCallsInProgress[i];
                if (serviceCall.GetCallback != null) {
                  serviceCall.GetCallback?.onErrorCallback(
                      900,
                      ReasonCodes.JSON_RESPONSE_MAXDEPTH_EXCEEDS_LIMIT,
                      JSON_ERROR_MESSAGE);
                  _serviceCallsInProgress.removeAt(i);
                }
              }
            }
          } finally {
            _serviceCallsInProgressLock.release();
          }
        } else {
          ResendMessage(_activeRequest!);
        }
        _clientRef.log(message);
        return null;
      }
    }
    return null;
  }

  /// <summary>
  /// Resets the communication layer. Clients will need to
  /// reauthenticate after this method is called.
  /// </summary>
  void ResetCommunication() {
    _serviceCallsWaitingLock.acquire();
    try {
      _isAuthenticated = false;
      _blockingQueue = false;
      _serviceCallsWaiting.clear();
      _serviceCallsInProgress.clear();
      _serviceCallsInTimeoutQueue.clear();
      DisposeUploadHandler();
      _activeRequest = null;
      _clientRef.authenticationService?.profileId = "";
      _sessionId = "";
      _packetId = 0;
    } finally {
      _serviceCallsWaitingLock.release();
    }
  }

// #if (DOT_NET || GODOT)
//         async Task AsyncHttpTaskCallback(Task<HttpResponseMessage> asyncResult, RequestState requestState)
//         {
//             if (asyncResult.IsCanceled) return;

//             HttpResponseMessage message = null;

//             try
//             {
//                 message = asyncResult.Result;
//                 HttpContent content = message.Content;

//                 //if its gzipped, the message is compressed
//                 if(content.Headers.ContentEncoding.ToString() != "gzip")
//                 {
//                     requestState.DotNetResponseString = await content.ReadAsStringAsync();
//                 }
//                 else
//                 {
//                     var byteArray = await content.ReadAsByteArrayAsync();
//                     var decompressedByteArray = Decompress(byteArray);
//                     requestState.DotNetResponseString = Encoding.UTF8.GetString(decompressedByteArray, 0, decompressedByteArray.Length);
//                 }

//                 // End the operation
//                 requestState.DotNetRequestStatus = message.IsSuccessStatusCode ?
//                     RequestState.eWebRequestStatus.STATUS_DONE : RequestState.eWebRequestStatus.STATUS_ERROR;
//             }

//             catch (WebException wex)
//             {
//                 if (_clientRef.LoggingEnabled)
//                 {
//                     _clientRef.Log("GetResponseCallback - WebException: " + wex.ToString());
//                 }
//                 requestState.DotNetRequestStatus = RequestState.eWebRequestStatus.STATUS_ERROR;
//             }
//             catch (Exception ex)
//             {
//                 if (_clientRef.LoggingEnabled)
//                 {
//                     _clientRef.Log("GetResponseCallback - Exception: " + ex.ToString());
//                 }
//                 requestState.DotNetRequestStatus = RequestState.eWebRequestStatus.STATUS_ERROR;
//             }

//             // Release the HttpResponseMessage
//             if (message != null) message.Dispose();
//         }
// #endif

  String CalculateMD5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// <summary>
  /// Handles authenticate-specific data from successful request
  /// </summary>
  /// <param name="jsonString"></param>
  void ProcessAuthenticate(Map<String, dynamic> jsonData) {
    //we want to extract the compressIfLarger amount
    if (jsonData.containsKey("compressIfLarger")) {
      _clientSideCompressionThreshold = jsonData["compressIfLarger"];
    }

    int playerSessionExpiry = GetJsonLong(jsonData,
        OperationParam.AuthenticateServicePlayerSessionExpiry.Value, 5 * 60);
    double idleTimeout = (playerSessionExpiry * 0.85);

    _idleTimeout = Duration(seconds: idleTimeout as int);

    _maxBundleMessages = jsonData.containsKey("maxBundleMsgs")
        ? jsonData["maxBundleMsgs"]
        : null;
    _killSwitchThreshold =
        jsonData.containsKey("maxKillCount") ? jsonData["maxKillCount"] : null;

    ResetErrorCache();
    _isAuthenticated = true;
  }

  void ProcessSwitchResponse(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey("switchToAppId")) {
      String switchToAppId = jsonData["switchToAppId"];
      _appId = switchToAppId;
    }
  }

  static String? GetJsonString(
      Map<String, dynamic> jsonData, String key, String? defaultReturn) {
    dynamic retVal;

    if (jsonData.containsKey(key)) {
      retVal = jsonData[key];
    }

    return retVal != null ? retVal as String : defaultReturn;
  }

  static int GetJsonLong(
      Map<String, dynamic> jsonData, String key, int defaultReturn) {
    dynamic retVal;
    if (jsonData.containsKey(key)) {
      retVal = jsonData[key];
    }

    return retVal ?? defaultReturn;
  }

  /// <summary>
  /// Attempts to create and send next request bundle.
  /// If to many attempts have been made, the request becomes an error
  /// </summary>
  /// <param name="status">Current Request Status</param>
  /// <param name="bypassTimeout">Was there an error on the request?</param>
  Future<void> RetryRequest(
      eWebRequestStatus status, bool bypassTimeout) async {
    if (_activeRequest != null) {
      if (bypassTimeout ||
          DateTime.now().difference(_activeRequest!.TimeSent) >=
              GetPacketTimeout(_activeRequest!)) {
        if (_clientRef.loggingEnabled) {
          String errorResponse = "";
          // we've reached the retry limit - send timeout error to all client callbacks
          if (status == eWebRequestStatus.STATUS_ERROR) {
            errorResponse = GetWebRequestResponse(_activeRequest);
            if (!errorResponse.isEmptyOrNull) {
              _clientRef.log("Timeout with network error: $errorResponse");
            } else {
              _clientRef.log(
                  "Timeout with network error: Please check the URL and/or certificates for server");
            }
          } else {
            _clientRef.log("Timeout no reply from server");
          }
        }
        if (!ResendMessage(_activeRequest!)) {
          DisposeUploadHandler();
          _activeRequest = null;

          // if we're doing caching of messages on timeout, kick it in now!
          if (_cacheMessagesOnNetworkError && _networkErrorCallback != null) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log("Caching messages");
            }
            _blockingQueue = true;

            // and insert the inProgress messages into head of wait queue
            _serviceCallsInTimeoutQueueLock.acquire();
            try {
              _serviceCallsInTimeoutQueue.insertAll(0, _serviceCallsInProgress);
              _serviceCallsInProgress.clear();
            } finally {
              _serviceCallsInTimeoutQueueLock.release();
            }

            if (_networkErrorCallback != null) {
              _networkErrorCallback!();
            }
          } else {
            // Fake a message bundle to keep the callback logic in one place
            TriggerCommsError(
                StatusCodes.CLIENT_NETWORK_ERROR,
                ReasonCodes.CLIENT_NETWORK_ERROR_TIMEOUT,
                "Timeout trying to reach brainCloud server");
          }
        }
      }
    } else // send the next message if we're ready
    {
      _activeRequest = CreateAndSendNextRequestBundle();
    }
  }

  /// <summary>
  /// Resets the cached error message for local session error handling to default
  /// </summary>
  void ResetErrorCache() {
    _cachedStatusCode = StatusCodes.FORBIDDEN;
    _cachedReasonCode = ReasonCodes.NO_SESSION;
    _cachedStatusMessage = "No session";
  }

  void DisposeUploadHandler() {
// #if USE_WEB_REQUEST
//             if (_activeRequest != null &&
//                 _activeRequest.WebRequest != null &&
//                 _activeRequest.WebRequest.uploadHandler != null)
//             {
//                 _activeRequest.WebRequest.Dispose();
//             }
// #endif
  }

  void AddCallbackToAuthenticateRequest(ServerCallback? in_callback) {
    bool inProgress = false;
    for (int i = 0; i < _serviceCallsInProgress.length && !inProgress; ++i) {
      if (_serviceCallsInProgress[i].GetOperation ==
          ServiceOperation.authenticate) {
        inProgress = true;
        _serviceCallsInProgress[i].GetCallback?.addAuthCallbacks(in_callback);
      }
    }
  }

  bool IsAuthenticateRequestInProgress() {
    bool inProgress = false;
    for (int i = 0; i < _serviceCallsInProgress.length && !inProgress; ++i) {
      if (_serviceCallsInProgress[i].GetOperation ==
          ServiceOperation.authenticate) {
        inProgress = true;
      }
    }
    return inProgress;
  }
}

//BrainCloud JSON

@JsonSerializable()
class JsonResponseBundleV2 {
  int packetId = 0;
  List<Map<String, dynamic>>? responses;
  List<Map<String, dynamic>>? events;

  JsonResponseBundleV2(this.packetId, this.responses, this.events);

  factory JsonResponseBundleV2.fromJson(Map<String, dynamic> json) =>
      _$JsonResponseBundleV2FromJson(json);
  Map<String, dynamic> toJson() => _$JsonResponseBundleV2ToJson(this);
}

@JsonSerializable()
class JsonResponseErrorBundleV2 {
  int packetId;
  List<JsonErrorMessage> responses;

  JsonResponseErrorBundleV2(this.packetId, this.responses);

  factory JsonResponseErrorBundleV2.fromJson(Map<String, dynamic> json) =>
      _$JsonResponseErrorBundleV2FromJson(json);
  Map<String, dynamic> toJson() => _$JsonResponseErrorBundleV2ToJson(this);
}

@JsonSerializable()
class JsonErrorMessage {
  int reason_code;
  int status;
  String status_message;
  String severity = "ERROR";

  JsonErrorMessage(this.status, this.reason_code, this.status_message);

  factory JsonErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonErrorMessageFromJson(json);
  Map<String, dynamic> toJson() => _$JsonErrorMessageToJson(this);
}
// end BrainCloud JSON
