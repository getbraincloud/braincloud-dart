import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/foundation.dart';

import 'package:crypto/crypto.dart';
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

part 'braincloud_comms.g.dart';

class ServerCallProcessed {
  late ServerCall serverCall;
  late String data;
}

class BrainCloudComms {
  bool _supportsCompression = true;

  final String jsonErrorMessage =
      "You have exceeded the max json depth, increase the MaxDepth using the MaxDepth variable in BrainCloudClient.dart";
  bool get supportsCompression => _supportsCompression;

  void enableCompression(bool compress) => _supportsCompression = compress;

  /// Byte size threshold that determines if the message size is something we want to compress or not. We make an initial value, but recevie the value for future calls based on the servers
  ///auth response

  int _clientSideCompressionThreshold = 50000;
  int get clientSideCompressionThreshold => _clientSideCompressionThreshold;

  /// The id of _expectedIncomingPacketId when no packet expected
  static int noPacketExpected = -1;

  /// Reference to the brainCloud client dynamic
  final BrainCloudClient _clientRef;

  /// Set to true once Initialize has been called.
  bool _initialized = false;

  /// Set to false if you want to shutdown processing on the Update.
  bool _enabled = true;

  /// The next packet id to send
  int _packetId = 1;

  /// The packet id we're expecting
  int _expectedIncomingPacketId = noPacketExpected;

  /// The service calls that are waiting to be sent.
  final List<ServerCall> _serviceCallsWaiting = [];

  /// The service calls that have been sent for which we are waiting for a reply
  List<ServerCall> _serviceCallsInProgress = [];

  /// The service calls in the timeout queue.
  final List<ServerCall> _serviceCallsInTimeoutQueue = [];

  /// The current request state. Null if no request is in progress.
  RequestState? _activeRequest;

  /// The last time a packet was sent
  late DateTime _lastTimePacketSent;

  /// How long we wait to send a heartbeat if no packets have been sent or received.
  /// This value is set to a percentage of the heartbeat timeout sent by the authenticate response.
  Duration _idleTimeout = const Duration(seconds: 5 * 60);

  /// The maximum number of messages in a bundle.
  /// This is set to a value from the server on authenticate
  int _maxBundleMessages = 10;

  /// The maximum number of sequential errors before client lockout
  /// This is set to a value from the server on authenticate
  int _killSwitchThreshold = 11;

  ///The maximum number of attempts that the client can use
  ///while trying to successfully authenticate before the client
  ///is disabled.
  final int _identicalFailedAuthAttemptThreshold = 3;

  ///The current number of identical failed attempts at authenticating. This
  ///will reset when a successful authentication is made.
  int _failedAuthenticationAttempts = 0;

  ///A blank reference for response data so we don't need to continually allocate new dictionaries when trying to
  ///make the data blank again.
  final Map<String, dynamic> _blankResponseData = {};

  ///An array that stores the most recent response jsons as dictionaries.
  final List<Map<String, dynamic>> _recentResponseJsonData = [{}, {}];

  /// When we have too many authentication errors under the same credentials,
  /// the client will not be able to try and authenticate again until the timer is up.
  final Duration _authenticationTimeoutDuration = const Duration(seconds: 30);

  /// When the authentication timer began
  late DateTime _authenticationTimeoutStart;

  /// a checker to see what the packet Id we are receiving is
  int receivedPacketIdChecker = 0;

  /// Debug value to introduce packet loss for testing retries etc.
  //double _debugPacketLossRate = 0;

  /// The event handler callback method
  EventCallback? _eventCallback;

  /// The reward handler callback method
  RewardCallback? _rewardCallback;

  FileUploadSuccessCallback? _fileUploadSuccessCallback;

  FileUploadFailedCallback? _fileUploadFailedCallback;

  FailureGlobalCallback? _globalErrorCallback;

  NetworkErrorCallback? _networkErrorCallback;

  final List<FileUploader> _fileUploads = [];

  //For handling local session errors
  late int _cachedStatusCode;
  late int _cachedReasonCode;
  late String _cachedStatusMessage;

  //For kill switch
  bool _killSwitchEngaged = false;
  int _killSwitchErrorCount = 0;
  String? _killSwitchService;
  String? _killSwitchOperation;

  bool authenticateInProgress = false;

  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  int getReceivedPacketId() => receivedPacketIdChecker;

  void setAuthenticated() {
    _isAuthenticated = true;
  }

  String? _appId;
  String? _sessionId;

  String get getAppId => _appId ?? "";
  String get getSessionID => _sessionId ?? "";

  String get getSecretKey {
    if (getAppIdSecretMap.containsKey(getAppId)) {
      return getAppIdSecretMap[getAppId]!;
    } else {
      return "NO SECRET DEFINED FOR '$getAppId'";
    }
  }

  late Map<String, String> _appIdSecretMap;
  Map<String, String> get getAppIdSecretMap => _appIdSecretMap;

  late String _serverURL;
  String get getServerURL => _serverURL;

  late String _uploadURL;
  String get uploadURL => _uploadURL;

  int uploadLowTransferRateTimeout = 120;

  int uploadLowTransferRateThreshold = 50;

  /// A list of packet timeouts. Index represents the packet attempt number.
  List<int> packetTimeouts = [15, 20, 35, 50];

  void setPacketTimeoutsToDefault() {
    packetTimeouts = [15, 20, 35, 50];
  }

  final List<int> _listAuthPacketTimeouts = [15, 30, 60];

  int authenticationPacketTimeoutSecs = 15;

  bool _cacheMessagesOnNetworkError = false;
  void enableNetworkErrorMessageCaching(bool enabled) {
    _cacheMessagesOnNetworkError = enabled;
  }

  bool _blockingQueue = false;

  BrainCloudComms(this._clientRef) {
    _appIdSecretMap = {};
    resetErrorCache();
  }

  /// Initialize the communications library with the specified serverURL and secretKey.
  ///
  /// @param serverURLServer URL.
  ///
  /// @param appIdAppId
  ///
  /// @param secretKeySecret key.
  void initialize(String serverURL, String appId, String secretKey) {
    resetCommunication(); //resets comms, packetId and SessionId
    _expectedIncomingPacketId = noPacketExpected;

    _serverURL = serverURL;

    String suffix = "/dispatcherv2";
    String formatURL = _serverURL.endsWith(suffix)
        ? _serverURL.substring(0, getServerURL.length - suffix.length)
        : getServerURL;

    //get rid of trailing /
    while (formatURL.isNotEmpty && formatURL.endsWith("/")) {
      formatURL = formatURL.substring(0, formatURL.length - 1);
    }

    _uploadURL = formatURL;
    _uploadURL += "/uploader";

    getAppIdSecretMap[appId] = secretKey;
    _appId = appId;

    _blockingQueue = false;
    _initialized = true;
  }

  /// Initialize the communications library with the specified serverURL and secretKey.
  ///
  /// @param serverURLServer URL.
  ///
  /// @param defaultAppIddefault appId
  ///
  /// @param appIdSecretMapmap of appId -> secrets, to allow the client to safely switch between apps with secret being secure
  void initializeWithApps(String serverURL, String defaultAppId,
      Map<String, String> appIdSecretMap) {
    getAppIdSecretMap.clear();
    _appIdSecretMap = appIdSecretMap;


    initialize(serverURL, defaultAppId, getAppIdSecretMap[defaultAppId] ?? "");
  }

  void registerEventCallback(EventCallback cb) {
    _eventCallback = cb;
  }

  void deregisterEventCallback() {
    _eventCallback = null;
  }

  void registerRewardCallback(RewardCallback cb) {
    _rewardCallback = cb;
  }

  void deregisterRewardCallback() {
    _rewardCallback = null;
  }

  void registerFileUploadCallbacks(
      FileUploadSuccessCallback success, FileUploadFailedCallback failure) {
    _fileUploadSuccessCallback = success;
    _fileUploadFailedCallback = failure;
  }

  void deregisterFileUploadCallbacks() {
    _fileUploadSuccessCallback = null;
    _fileUploadFailedCallback = null;
  }

  void registerGlobalErrorCallback(FailureGlobalCallback callback) {
    _globalErrorCallback = callback;
  }

  void deregisterGlobalErrorCallback() {
    _globalErrorCallback = null;
  }

  void registerNetworkErrorCallback(NetworkErrorCallback callback) {
    _networkErrorCallback = callback;
  }

  void deregisterNetworkErrorCallback() {
    _networkErrorCallback = null;
  }

  /// The update method needs to be called periodically to send/receive responses
  /// and run the associated callbacks.
  void update() {
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
    WebRequestStatus status = WebRequestStatus.pending;
    if (_activeRequest != null) {
      status = getWebRequestStatus(_activeRequest!);
      if (status == WebRequestStatus.error) {
        // Force the timeout to be elapsed because we have completed the request with error
        // or else, do nothing with the error right now - let the timeout code handle it
        bypassTimeout = (_activeRequest!.retries >=
            getMaxRetriesForPacket(_activeRequest!));
      } else if (status == WebRequestStatus.done) {
        //HttpStatusCode.OK
        if (_activeRequest?.webRequest?.response?.statusCode == 200) {
          resetIdleTimer();
          var resp = _getWebRequestResponse(_activeRequest);
          handleResponseBundle(resp);
          disposeUploadHandler();
          _activeRequest = null;
        }
        //HttpStatusCode.ServiceUnavailable
        else if (_activeRequest?.webRequest?.response?.statusCode == 503 ||
            _activeRequest?.webRequest?.response?.statusCode == 502 ||
            _activeRequest?.webRequest?.response?.statusCode == 504) {
          //Packet in progress
          _clientRef.log("Packet in progress");
          retryRequest(status, bypassTimeout);
          return;
        } else {
          //Error Callback
          var errorResponse = _getWebRequestResponse(_activeRequest);
          if (_serviceCallsInProgress.isNotEmpty) {
            ServerCall? sc = _serviceCallsInProgress[0];

            ServerCallback? callback = sc.getCallback;
            if (callback != null) {
                triggerCommsError(404,  _activeRequest?.webRequest?.response?.statusCode ??
                        ReasonCodes.unknownAuthError, errorResponse);
              _activeRequest = null;
            }
          }
        }
      }
    }

    // is it time for a retry?
    retryRequest(status, bypassTimeout);

    // is it time for a heartbeat?
    if (_isAuthenticated && !_blockingQueue) {
      if (DateTime.now().difference(_lastTimePacketSent) >= _idleTimeout) {
        sendHeartbeat();
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
        resetKillSwitch();
      }
    }

    runFileUploadCallbacks();
  }

  /// Checks the status of active file uploads
  void runFileUploadCallbacks() {
    for (int i = _fileUploads.length - 1; i >= 0; i--) {
      _fileUploads[i].update();
      if (_fileUploads[i].status == FileUploaderStatus.completeSuccess) {
        _fileUploadSuccessCallback!(
            _fileUploads[i].uploadId, _fileUploads[i].response);

        if (_clientRef.loggingEnabled) {
          _clientRef.log(
              "Upload success: ${_fileUploads[i].uploadId}  | ${_fileUploads[i].statusCode} \n ${_fileUploads[i].response}");
        }
        _fileUploads.removeAt(i);
      } else if (_fileUploads[i].status == FileUploaderStatus.completeFailed) {
        _fileUploadFailedCallback!(
            _fileUploads[i].uploadId,
            _fileUploads[i].statusCode,
            _fileUploads[i].reasonCode,
            _fileUploads[i].response);

        if (_clientRef.loggingEnabled) {
          _clientRef.log(
              "Upload failed: ${_fileUploads[i].uploadId} | ${_fileUploads[i].statusCode} \n ${_fileUploads[i].response}");
        }
        _fileUploads.removeAt(i);
      }
    }
  }

  void cancelUpload(String uploadFileId) {
    FileUploader? uploader = getFileUploader(uploadFileId);
    if (uploader != null) uploader.cancelUpload();
  }

  double getUploadProgress(String uploadFileId) {
    FileUploader? uploader = getFileUploader(uploadFileId);
    if (uploader != null) {
      return uploader.progress;
    } else {
      return -1;
    }
  }

  int getUploadBytesTransferred(String uploadFileId) {
    FileUploader? uploader = getFileUploader(uploadFileId);
    if (uploader != null) {
      return uploader.bytesTransferred;
    } else {
      return -1;
    }
  }

  int getUploadTotalBytesToTransfer(String uploadFileId) {
    FileUploader? uploader = getFileUploader(uploadFileId);
    if (uploader != null) {
      return uploader.totalBytesToTransfer;
    } else {
      return -1;
    }
  }

  FileUploader? getFileUploader(String uploadId) {
    for (int i = 0; i < _fileUploads.length; i++) {
      if (_fileUploads[i].uploadId == uploadId) return _fileUploads[i];
    }

    if (_clientRef.loggingEnabled) {
      _clientRef.log("GetUploadProgress could not find upload ID $uploadId");
    }
    return null;
  }

  /// Method fakes a json error from the server and sends
  /// it along to the response callbacks.
  ///
  /// @param statusstatus.
  ///
  /// @param reasonCodereason code.
  ///
  /// @param statusMessagestatus message.
  void triggerCommsError(int status, int reasonCode, String statusMessage) {
    // error json format is
    // {
    // "reason_code": 40316,
    // "status": 403,
    // "status_message": "Processing exception: Invalid game ID in authentication request",
    // "severity": "ERROR"
    // }

    int numMessagesToReturn = 0;

    numMessagesToReturn = _serviceCallsInProgress.length;

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
    handleResponseBundle(jsonError);
  }

  /// Shuts down the communications layer.  
  void shutDown() {
    _serviceCallsWaiting.clear();

    disposeUploadHandler();
    _activeRequest = null;

    // and then dump the comms layer
    resetCommunication();
  }

  // see BrainCloudClient.RetryCachedMessages() docs
  void retryCachedMessages() {
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
        _activeRequest?.cancelRequest();
        disposeUploadHandler();
        _activeRequest = null;
      }

      --_packetId;
      _activeRequest = createAndSendNextRequestBundle();
      _blockingQueue = false;
    }
  }

  // see BrainCloudClient.FlushCachedMessages() docs
  void flushCachedMessages(bool sendApiErrorCallbacks) {
    if (_blockingQueue) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Flushing cached messages");
      }

      // try to cancel if request is in progress (shouldn't happen)
      if (_activeRequest != null) {
        _activeRequest?.cancelRequest();
        disposeUploadHandler();
        _activeRequest = null;
      }

      // then flush the message queues
      List<ServerCall> callsToProcess = [];
      for (int i = 0, isize = _serviceCallsInTimeoutQueue.length;
          i < isize;
          ++i) {
        callsToProcess.add(_serviceCallsInTimeoutQueue[i]);
      }
      _serviceCallsInTimeoutQueue.clear();

      for (int i = 0, isize = _serviceCallsWaiting.length; i < isize; ++i) {
        callsToProcess.add(_serviceCallsWaiting[i]);
      }
      _serviceCallsWaiting.clear();

      _serviceCallsInProgress.clear(); // shouldn't be anything in here...

      // and send api error callbacks if required
      if (sendApiErrorCallbacks) {
        for (int i = 0, isize = callsToProcess.length; i < isize; ++i) {
          ServerCall sc = callsToProcess[i];
          if (sc.getCallback != null) {
            sc.getCallback?.onErrorCallback(
                StatusCodes.clientNetworkError,
                ReasonCodes.clientNetworkErrorTimeout,
                "Timeout trying to reach brainCloud server, please check the URL and/or certificates for server");
          }
        }
      }
      _blockingQueue = false;
    }
  }

  void insertEndOfMessageBundleMarker() {
    addToQueue(EndOfBundleMarker());
  }

  /// Resets the idle timer.
  void resetIdleTimer() {
    _lastTimePacketSent = DateTime.now();
  }

  /// Starts timeout of authentication calls.
  void resetAuthenticationTimer() {
    _authenticationTimeoutStart = DateTime.now();
  }

  ///keeps track of if the client has made too many authentication attempts.
  bool tooManyAuthenticationAttempts() {
    return _failedAuthenticationAttempts >=
        _identicalFailedAuthAttemptThreshold;
  }

  //save profileid and sessionId of response
  void saveProfileAndSessionIds(Map<String, dynamic> responseData) {
    // save the session ID
    String? sessionId = getJsonString(
        responseData, OperationParam.serviceMessageSessionId.value, null);
    if (!sessionId.isEmptyOrNull) {
      _sessionId = sessionId;
      _isAuthenticated = true;
      authenticateInProgress = false;
    }

    // save the profile Id
    String? profileId =
        getJsonString(responseData, OperationParam.profileId.value, null);
    if (profileId != null) {
      _clientRef.authenticationService.profileId = profileId;
    }
  }

  /// Handles the response bundle and calls registered callbacks.
  ///
  /// @param jsonDataThe received message bundle.
  void handleResponseBundle(String jsonData) {
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
      _cachedReasonCode = ReasonCodes.jsonParsingError;
      _cachedStatusCode = StatusCodes.clientNetworkError;
      _cachedStatusMessage =
          "Received an invalid json format response, check your network settings.";
      _cacheMessagesOnNetworkError = true;

      if (_serviceCallsInProgress.isNotEmpty) {
        var serverCall = _serviceCallsInProgress[0];
        if (serverCall.getCallback != null) {
          serverCall.getCallback?.onErrorCallback(
              _cachedStatusCode, _cachedReasonCode, _cachedStatusMessage);
          _serviceCallsInProgress.removeAt(0);
        }
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
    if (receivedPacketId != noPacketExpected &&
        (_expectedIncomingPacketId == noPacketExpected ||
            _expectedIncomingPacketId != receivedPacketId)) {
      if (_clientRef.loggingEnabled) {
        _clientRef.log("Dropping duplicate packet");
      }

      for (int j = 0; j < responseBundle.length; ++j) {
        if (_serviceCallsInProgress.isNotEmpty) {
          _serviceCallsInProgress.removeAt(0);
        }
      }
      return;
    }

    _expectedIncomingPacketId = noPacketExpected;
    List<Object> exceptions = [];

    Map<String, dynamic> data = {};
    ServerCall? sc;
    ServerCallback? callback;
    String service = "";
    String operation = "";
    Map<String, dynamic>? responseData;
    for (int j = 0; j < responseBundle.length; ++j) {
      response = responseBundle[j];
      int statusCode = response["status"];
      data = {};
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
      if (_serviceCallsInProgress.isNotEmpty) {
        sc = _serviceCallsInProgress[0];
        _serviceCallsInProgress.removeAt(0);
      }

      // its a success response
      if (statusCode == 200) {
        resetKillSwitch();
        service = sc?.getService.value ?? "";
        if (response[OperationParam.serviceMessageData.value] != null) {
          responseData = response[OperationParam.serviceMessageData.value];
          // send the data back as not formatted
          data = response;

          if (service == ServiceName.authenticate.value ||
              service == ServiceName.identity.value) {
            //Reset authenticate timeout
            authenticationPacketTimeoutSecs = _listAuthPacketTimeouts[0];
            saveProfileAndSessionIds(responseData ?? {});
          }
        } else {
          data = response;
        }

        if (sc != null) {
          // now try to execute the callback
          callback = sc.getCallback;
          operation = sc.getOperation.value;
          bool bIsPeerScriptUploadCall = false;
          try {
            bIsPeerScriptUploadCall = operation ==
                    ServiceOperation.runPeerScript.value &&
                response.containsKey(OperationParam.serviceMessageData.value) &&
                (response[OperationParam.serviceMessageData.value] as Map)
                    .containsKey("response") &&
                (response[OperationParam.serviceMessageData.value]["response"]
                        as Map)
                    .containsKey(OperationParam.serviceMessageData.value) &&
                (((response[OperationParam.serviceMessageData.value])[
                            "response"])[OperationParam.serviceMessageData.value]
                        as Map)
                    .containsKey("fileDetails");
          } on Exception {
            debugPrint(
                "Exception lib/BrainCloud/Internal/braincloud_comms.dart Line 949");
          }

          if (operation == ServiceOperation.fullReset.value ||
              operation == ServiceOperation.logout.value) {
            // we reset the current player or logged out
            // we are no longer authenticated
            _isAuthenticated = false;
            _sessionId = "";
            _clientRef.authenticationService.clearSavedProfileID();
            resetErrorCache();
          }
          //either off of authenticate or identity call, be sure to save the profileId and sessionId
          else if (operation == ServiceOperation.authenticate.value) {
            processAuthenticate(responseData!);
          }
          // switch to child
          else if (operation == ServiceOperation.switchToChildProfile.value ||
              operation == ServiceOperation.switchToParentProfile.value) {
            processSwitchResponse(responseData!);
          } else if (operation == ServiceOperation.prepareUserUpload.value ||
              bIsPeerScriptUploadCall) {
            String peerCode =
                bIsPeerScriptUploadCall && sc.getJsonData!.containsKey("peer")
                    ? sc.getJsonData!["peer"]
                    : "";
            Map<String, dynamic> fileData = peerCode == ""
                ? responseData!["fileDetails"]
                : responseData!["response"]
                    [OperationParam.serviceMessageData.value]["fileDetails"];

            if (fileData.containsKey("uploadId") &&
                fileData.containsKey("localPath")) {
              String uploadId = fileData["uploadId"];
              String guid = fileData["localPath"];
              String fileName = fileData["cloudFilename"];
              var uploader = FileUploader(
                  uploadId: uploadId,
                  guidLocalPath: guid,
                  serverUrl: uploadURL,
                  sessionId: getSessionID,
                  clientRef: _clientRef,
                  peerCode: peerCode,
                  fileName: fileName,
                  timeout: uploadLowTransferRateTimeout,
                  timeoutThreshold: uploadLowTransferRateThreshold);

              if (_clientRef.fileService.fileStorage.containsKey(guid)) {
                uploader.totalBytesToTransfer =
                    _clientRef.fileService.fileStorage[guid]?.length ?? 0;
              }
              _fileUploads.add(uploader);
              uploader.start();
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
                Map<String, dynamic> theReward = {};
                theReward["rewards"] = rewards;
                theReward["service"] = service;
                theReward["operation"] = operation;
                Map<String, dynamic> apiRewards = {};
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
        }
      } else //if non-200
      {
        int reasonCode = 0;
        dynamic errorJson = "";
        callback = sc?.getCallback;
        operation = sc?.getOperation.value ?? "";

        //if it was an authentication call
        if (operation == ServiceOperation.authenticate.value) {
          //if we haven't already gone above the threshold and are waiting for the timer or a 200 response to reset things
          if (!tooManyAuthenticationAttempts()) {
            _failedAuthenticationAttempts++;
            if (tooManyAuthenticationAttempts()) {
              resetAuthenticationTimer();
            }
          }

          authenticateInProgress = false;
        }

        if (response.containsKey("reason_code")) {
          reasonCode = response["reason_code"];
        }

        errorJson = response;

        if (reasonCode == ReasonCodes.playerSessionExpired ||
            reasonCode == ReasonCodes.noSession ||
            reasonCode == ReasonCodes.playerSessionLoggedOut) {
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
          if (reasonCode == ReasonCodes.clientNetworkErrorTimeout) {
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
          String svc = sc?.getService.value ?? service; 
          String op = sc?.getOperation.value ?? operation; 
          _globalErrorCallback!(svc, op, statusCode, reasonCode, errorJson);
        }

        if (sc != null) {
          updateKillSwitch(
              sc.getService.value, sc.getOperation.value, statusCode);
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
      disposeUploadHandler();
      _activeRequest = null; // to make sure we don't reprocess this message

      throw Exception(
          "User callback handlers threw ${exceptions.length} exception(s). See the log for callstacks or inner exception for first exception thrown. ${exceptions[0]}");
    }
  }

  void updateKillSwitch(String service, String operation, int statusCode) {
    if (statusCode == StatusCodes.clientNetworkError) return;

    if (_killSwitchService == null) {
      _killSwitchService = service;
      _killSwitchOperation = operation;
      _killSwitchErrorCount++;
    } else if (service == _killSwitchService &&
        operation == _killSwitchOperation) {
      _killSwitchErrorCount++;
    }

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

      if (_clientRef.loggingEnabled) {
        _clientRef.log("Current number of failed authentications: $_failedAuthenticationAttempts");
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
        resetAuthenticationTimer();
      }
    }
  }

  void resetKillSwitch() {
    _killSwitchErrorCount = 0;
    _killSwitchService = null;
    _killSwitchOperation = null;

    //reset the amount of failed attempts upon a successful attempt
    _failedAuthenticationAttempts = 0;
    _recentResponseJsonData[0] = _blankResponseData;
    _recentResponseJsonData[1] = _blankResponseData;
  }

  /// Creates the request state dynamic and sends the message bundle

  /// returns The and send next request bundle.
  RequestState? createAndSendNextRequestBundle() {
    RequestState? requestState;
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

          if (call.getOperation == ServiceOperation.authenticate) {
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
        operation = scIndex.getOperation;
        service = scIndex.getService;
        // don't send heartbeat if it was generated by comms (null callbacks)
        // and there are other messages in the bundle - it's unnecessary
        if (service == ServiceName.heartBeat &&
            operation == ServiceOperation.read &&
            (scIndex.getCallback == null ||
                scIndex.getCallback!.areCallbacksNull())) {
          if (_serviceCallsInProgress.length > 1) {
            _serviceCallsInProgress.removeAt(i);
            --i;
            continue;
          }
        }

        Map<String, dynamic> message = {};
        message[OperationParam.serviceMessageService.value] =
            scIndex.getService.value;
        message[OperationParam.serviceMessageOperation.value] =
            scIndex.getOperation.value;
        message[OperationParam.serviceMessageData.value] =
            scIndex.getJsonData;

        messageList.add(message);

        if (operation == ServiceOperation.authenticate) {
          requestState.packetNoRetry = true;
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
          requestState.packetRequiresLongTimeout = true;
        }
      }

      requestState.packetId = _packetId;
      _expectedIncomingPacketId = _packetId;
      requestState.messageList = messageList;
      ++_packetId;

      if (!_killSwitchEngaged && !tooManyAuthenticationAttempts()) {
        if (_isAuthenticated || isAuth) {
          if (_clientRef.loggingEnabled) {
            _clientRef.log("SENDING REQUEST");
          }
          internalSendMessage(requestState);
        } else {
          _fakeErrorResponse(requestState, _cachedStatusCode,
              _cachedReasonCode, _cachedStatusMessage);
          requestState = null;
        }
      } else {
        if (tooManyAuthenticationAttempts()) {
          _fakeErrorResponse(
              requestState,
              StatusCodes.clientNetworkError,
              ReasonCodes.clientDisabledFailedAuth,
              "Client has been disabled due to identical repeat Authentication calls that are throwing errors. Authenticating with the same credentials is disabled for 30 seconds");
          requestState = null;
        } else {
          _fakeErrorResponse(
              requestState,
              StatusCodes.clientNetworkError,
              ReasonCodes.clientDisabled,
              "Client has been disabled due to repeated errors from a single API call");
          requestState = null;
        }
      }
    }

    return requestState;
  }

  /// Creates a fake response to stop packets being sent to the server without a valid session.
  void _fakeErrorResponse(RequestState requestState, int statusCode,
      int reasonCode, String statusMessage) {
    Map<String, dynamic> packet = {};
    packet[OperationParam.serviceMessagePacketId.value] = requestState.packetId;
    packet[OperationParam.serviceMessageSessionId.value] = getSessionID;
    if (getAppId.isNotEmpty) {
      packet[OperationParam.serviceMessageGameId.value] = getAppId;
    }
    packet[OperationParam.serviceMessageMessages.value] =
        requestState.messageList;

    String jsonRequestString = serializeJson(packet);

    if (_clientRef.loggingEnabled) {
      _clientRef.log(
          "REQUEST Retry( ${requestState.retries} - ${DateTime.now()}\n $jsonRequestString");
    }

    resetIdleTimer();

    triggerCommsError(statusCode, reasonCode, statusMessage);
    disposeUploadHandler();
    _activeRequest = null;
  }

  String serializeJson(dynamic payload) {
    return jsonEncode(payload);
  }

  Map<String, dynamic> deserializeJson(String jsonData) {
    return jsonDecode(jsonData);
  }

  /// Method creates the web request and sends it immediately.
  /// Relies upon the requestState PacketId and MessageList being
  /// set appropriately.
  ///
  /// @param requestStateRequest state.
  Future<dynamic> internalSendMessage(RequestState requestState) async {
    // bundle up the data into a String
    Map<String, dynamic> packet = {};
    packet[OperationParam.serviceMessagePacketId.value] = requestState.packetId;
    packet[OperationParam.serviceMessageSessionId.value] = getSessionID;
    if (getAppId.isNotEmpty) {
      packet[OperationParam.serviceMessageGameId.value] = getAppId;
    }
    packet[OperationParam.serviceMessageMessages.value] =
        requestState.messageList;

    String jsonRequestString = serializeJson(packet);
    String sig = calculateMD5Hash("$jsonRequestString$getSecretKey");

    Uint8List byteArray = utf8.encode(jsonRequestString);

    requestState.signature = sig;

    bool compressMessage = supportsCompression && // compression enabled
        clientSideCompressionThreshold >= 0 && // server says we can compress
        byteArray.length >=
            clientSideCompressionThreshold; // and byte array is greater or equal to the threshold

    //if the packet we're sending is larger than the size before compressing, then we want to compress it otherwise we're good to send it. AND we have to support compression
    if (compressMessage) {
      byteArray = compress(byteArray);
    }

    requestState.byteArray = byteArray;

    Map<String, String>? headers = {};
    headers["Content-Type"] = "application/json;charset=utf-8";
    headers["X-SIG"] = sig;

    if (getAppId.isNotEmpty) {
      headers["X-APPID"] = getAppId;
    }

    WebRequest req = WebRequest("POST", Uri.parse(_serverURL));
    req.headers.addAll(headers);
    req.body = jsonRequestString;

    requestState.webRequest = req;

    requestState.requestString = jsonRequestString;
    requestState.timeSent = DateTime.now();

    resetIdleTimer();

    if (_clientRef.loggingEnabled) {
      _clientRef.log(
          "REQUEST - ${DateTime.now()}\n$jsonRequestString Retry(${requestState.retries})");
    }

    return requestState.webRequest
        ?.send()
        .then((result) => http.Response.fromStream(result).then((response) {
              requestState.webRequest?.response = response;
            }))
        .catchError((e) {
      requestState.webRequest?.error = e.message ?? e.toString();
    });
  }

  Uint8List compress(Uint8List raw) {
    return Uint8List.fromList(gzip.encode(raw));
  }

  Uint8List decompress(Uint8List compressedBytes) {
    return Uint8List.fromList(gzip.decode(compressedBytes.toList()));
  }

  /// Resends a message bundle. Returns true if sent or
  /// false if max retries has been reached.
  ///
  /// returns __true__, if message was resent, __false__ if max retries hit.
  ///
  /// @param requestStateRequest state.
  bool resendMessage(RequestState requestState) {
    if (_activeRequest!.retries >= getMaxRetriesForPacket(requestState)) {
      return false;
    }
    ++_activeRequest!.retries;
    internalSendMessage(requestState);
    return true;
  }

  /// Gets the web request status.
  ///
  /// returns The web request status.
  /// @param requestStaterequest state.
  WebRequestStatus getWebRequestStatus(RequestState requestState) {
    WebRequestStatus status = WebRequestStatus.pending;

    // for testing packet loss, some packets are flagged to be lost
    // and should always return status pending no matter what the real
    // status is
    if (_activeRequest!.loseThisPacket) {
      return status;
    }

    String error = _activeRequest?.webRequest?.error ?? "";

    if (!error.isEmptyOrNull) {
      status = WebRequestStatus.error;
    } else if (_activeRequest?.webRequest?.downloadHandler?.isDone ?? false) {
      status = WebRequestStatus.done;
    } else if (_activeRequest?.webRequest?.isDone ?? false) {
      status = WebRequestStatus.done;
    }
    return status;
  }

  /// Gets the web request response.
  ///
  /// returns The web request response.
  ///
  /// @param requestStaterequest state.
  String _getWebRequestResponse(RequestState? requestState) {
    return requestState?.webRequest?.response?.body ?? "";
  }

  /// Method returns the maximum retries for the given packet
  ///
  /// returns The maximum retries for the given packet.
  ///
  /// @param requestStateThe active request.
  int getMaxRetriesForPacket(RequestState requestState) {
    if (requestState.packetNoRetry) {
      return 0;
    }
    return packetTimeouts.length;
  }

  /// Method staggers the packet timeout value based on the currentRetry
  ///
  /// returns The packet timeout.
  ///
  /// @param requestStateThe active request.
  Duration getPacketTimeout(RequestState requestState) {
    if (requestState.packetNoRetry) {
      if (DateTime.now().difference(_activeRequest!.timeSent) >
          Duration(seconds: authenticationPacketTimeoutSecs)) {
        for (int i = 0; i < _listAuthPacketTimeouts.length; i++) {
          if (_listAuthPacketTimeouts[i] == authenticationPacketTimeoutSecs) {
            if (i + 1 < _listAuthPacketTimeouts.length) {
              authenticationPacketTimeoutSecs = _listAuthPacketTimeouts[i + 1];
              break;
            }
          }
        }
      }
      return Duration(seconds: authenticationPacketTimeoutSecs);
    }

    int currentRetry = requestState.retries;
    Duration ret;

    // if this is a delete player, or logout we change the
    // timeout behaviour
    if (requestState.packetRequiresLongTimeout) {
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

  /// Sends the heartbeat.
  void sendHeartbeat() {
    ServerCall sc =
        ServerCall(ServiceName.heartBeat, ServiceOperation.read, null, null);
    addToQueue(sc);
  }

  /// Adds a server call to the internal queue.
  ///
  /// @param call The server call to execute
  void addToQueue(ServerCall call) {
    if (_initialized)
       _serviceCallsWaiting.add(call);
    else 
      call.getCallback?.onErrorCallback(900, ReasonCodes.clientNotInitialized, "Client not Initialized");
  }

  /// Enables the communications layer.
  ///
  /// @param valueIf set to __true__ value.
  void enableComms(bool value) {
    _enabled = value;
  }

  /// Resets the communication layer. Clients will need to
  /// reauthenticate after this method is called.
  void resetCommunication() {
    _isAuthenticated = false;
    _blockingQueue = false;
    _serviceCallsWaiting.clear();
    _serviceCallsInProgress.clear();
    _serviceCallsInTimeoutQueue.clear();
    disposeUploadHandler();
    _activeRequest = null;
    _clientRef.authenticationService.profileId = "";
    _sessionId = "";
    _packetId = 0;
  }

  String calculateMD5Hash(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  /// Handles authenticate-specific data from successful request
  ///
  /// @param jsonData
  void processAuthenticate(Map<String, dynamic> jsonData) {
    //we want to extract the compressIfLarger amount
    if (jsonData.containsKey("compressIfLarger")) {
      _clientSideCompressionThreshold = jsonData["compressIfLarger"];
    }

    int playerSessionExpiry = getJsonLong(jsonData,
        OperationParam.authenticateServicePlayerSessionExpiry.value, 5 * 60);
    double idleTimeout = (playerSessionExpiry * 0.85);

    _idleTimeout = Duration(seconds: idleTimeout.toInt());

    _maxBundleMessages = jsonData.containsKey("maxBundleMsgs")
        ? jsonData["maxBundleMsgs"]
        : null;
    _killSwitchThreshold =
        jsonData.containsKey("maxKillCount") ? jsonData["maxKillCount"] : null;

    resetErrorCache();
    _isAuthenticated = true;
  }

  void processSwitchResponse(Map<String, dynamic> jsonData) {
    if (jsonData.containsKey("switchToAppId")) {
      String switchToAppId = jsonData["switchToAppId"];
      _appId = switchToAppId;
    }
  }

  static String? getJsonString(
      Map<String, dynamic> jsonData, String key, String? defaultReturn) {
    dynamic retVal;

    if (jsonData.containsKey(key)) {
      retVal = jsonData[key];
    }

    return retVal != null ? retVal as String : defaultReturn;
  }

  static int getJsonLong(
      Map<String, dynamic> jsonData, String key, int defaultReturn) {
    dynamic retVal;
    if (jsonData.containsKey(key)) {
      retVal = jsonData[key];
    }

    return retVal ?? defaultReturn;
  }

  /// Attempts to create and send next request bundle.
  /// If to many attempts have been made, the request becomes an error
  ///
  /// @param statusCurrent Request Status
  ///
  /// @param bypassTimeoutWas there an error on the request?
  Future<void> retryRequest(WebRequestStatus status, bool bypassTimeout) async {
    if (_activeRequest != null) {
      if (bypassTimeout ||
          DateTime.now().difference(_activeRequest!.timeSent) >=
              getPacketTimeout(_activeRequest!)) {
        if (_clientRef.loggingEnabled) {
          String errorResponse = "";
          // we've reached the retry limit - send timeout error to all client callbacks
          if (status == WebRequestStatus.error) {
            errorResponse = _getWebRequestResponse(_activeRequest);
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
        if (!resendMessage(_activeRequest!)) {
          disposeUploadHandler();
          String errorResponse = _activeRequest?.webRequest?.error ?? _getWebRequestResponse(_activeRequest);
          _activeRequest = null;

          // if we're doing caching of messages on timeout, kick it in now!
          if (_cacheMessagesOnNetworkError && _networkErrorCallback != null) {
            if (_clientRef.loggingEnabled) {
              _clientRef.log("Caching messages");
            }
            _blockingQueue = true;

            // and insert the inProgress messages into head of wait queue
            _serviceCallsInTimeoutQueue.insertAll(0, _serviceCallsInProgress);
            _serviceCallsInProgress.clear();

            if (_networkErrorCallback != null) {
              _networkErrorCallback!();
            }
          } else {
            // Fake a message bundle to keep the callback logic in one place
            triggerCommsError(
                StatusCodes.clientNetworkError,
                ReasonCodes.clientNetworkErrorTimeout,
                "Timeout trying to reach brainCloud server ${errorResponse.isNotEmpty ? ": " + errorResponse:""}");
          }
        }
      }
    } else // send the next message if we're ready
    {
      _activeRequest = createAndSendNextRequestBundle();
    }
  }

  /// Resets the cached error message for local session error handling to default
  void resetErrorCache() {
    _cachedStatusCode = StatusCodes.forbidden;
    _cachedReasonCode = ReasonCodes.noSession;
    _cachedStatusMessage = "No session";
  }

  void disposeUploadHandler() {
    if (_activeRequest != null &&
        _activeRequest?.webRequest != null &&
        _activeRequest?.webRequest?.uploadHandler != null) {
      _activeRequest?.webRequest = null;
    }
  }

  //TODO: Need to confirm this is not needed.
  // void addCallbackToAuthenticateRequest(ServerCallback? inCallback) {
  //   bool inProgress = false;
  //   for (int i = 0; i < _serviceCallsInProgress.length && !inProgress; ++i) {
  //     if (_serviceCallsInProgress[i].getOperation == ServiceOperation.authenticate) {
  //         _serviceCallsInProgress[i].getCallback?.addAuthCallbacks(inCallback);
  //       inProgress = true;
  //     }
  //   }
  // }

  bool isAuthenticateRequestInProgress() {
    bool inProgress = false;
    for (int i = 0; i < _serviceCallsInProgress.length && !inProgress; ++i) {
      if (_serviceCallsInProgress[i].getOperation ==
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
  @JsonKey(name: 'reason_code')
  int reasonCode;
  int status;
  @JsonKey(name: 'status_message')
  String statusMessage;
  String severity = "ERROR";

  JsonErrorMessage(this.status, this.reasonCode, this.statusMessage);

  factory JsonErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$JsonErrorMessageFromJson(json);
  Map<String, dynamic> toJson() => _$JsonErrorMessageToJson(this);
}
// end BrainCloud JSON
