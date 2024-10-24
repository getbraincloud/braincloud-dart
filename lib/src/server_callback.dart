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

  void onErrorCallback(int statusCode, int reasonCode, String statusMessage) {
    fnFailureCallback?.call(statusCode, reasonCode, statusMessage);
  }

  bool areCallbacksNull() {
    return fnSuccessCallback == null && fnFailureCallback == null;
  }
}

/// @param Map<String, dynamic> response
typedef SuccessCallback = void Function(Map<String, dynamic> response);

/// @param int statusCode
///
///  @param int reasonCode
///
/// @param String statusMessage
typedef FailureCallback = void Function(
    int statusCode, int reasonCode, String statusMessage);

typedef NetworkErrorCallback = void Function();

typedef EventCallback = void Function(String jsonResponse);

typedef LogCallback = void Function(String jsonResponse);

typedef RewardCallback = void Function(String jsonResponse);

typedef RTTCallback = void Function(String jsonResponse);

typedef RelayCallback = void Function(int netId, List<int> data);

typedef RelaySystemCallback = void Function(String jsonResponse);

typedef FileUploadSuccessCallback = void Function(
    String fileUploadId, String jsonResponse);

typedef FileUploadFailedCallback = void Function(
    String fileUploadId, int statusCode, int reasonCode, String jsonResponse);
