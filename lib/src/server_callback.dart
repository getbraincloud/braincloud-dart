import 'dart:typed_data';

import 'package:braincloud_dart/braincloud_dart.dart';

class ServerCallback {
  /// ServerCallback
  ///
  /// @param fnSuccessCallback : SuccessCallback
  ///
  /// @param fnFailureCallback : FailureCallback
  ServerCallback(this.fnSuccessCallback, this.fnFailureCallback);

  SuccessCallback? fnSuccessCallback;
  FailureCallback? fnFailureCallback;

  void onSuccessCallback(Map<String, dynamic> jsonResponse) {
    fnSuccessCallback?.call(jsonResponse);
  }

  void onErrorCallback(int statusCode, int reasonCode, dynamic statusMessage) {
    fnFailureCallback?.call(statusCode, reasonCode, statusMessage);
  }

  bool areCallbacksNull() {
    return fnSuccessCallback == null && fnFailureCallback == null;
  }
}

/// @param Map<String, dynamic> response
typedef SuccessCallback = void Function(Map<String, dynamic> response);

/// FailureCallback
/// 
/// @param int statusCode
///
/// @param int reasonCode
///
/// @param String statusMessage
typedef FailureCallback = void Function(
    int statusCode, int reasonCode, dynamic statusMessage);

typedef FailureGlobalCallback = void Function(
    String serviceName, String serviceOperation, 
    int statusCode, int reasonCode, dynamic statusMessage);

typedef NetworkErrorCallback = void Function();

typedef EventCallback = void Function(Map<String, dynamic>?  jsonResponse);

typedef LogCallback = void Function(Map<String, dynamic>?  jsonResponse);

typedef RewardCallback = void Function(Map<String, dynamic>?  jsonResponse);

typedef RTTCallback = void Function(RTTCommandResponse rttResponse);

typedef RelayCallback = void Function(int netId, Uint8List data);

typedef RelaySystemCallback = void Function(Map<String, dynamic>?  jsonResponse);

typedef FileUploadSuccessCallback = void Function(
    String fileUploadId, String jsonResponse);

typedef FileUploadFailedCallback = void Function(
    String fileUploadId, int statusCode, int reasonCode, String jsonResponse);
