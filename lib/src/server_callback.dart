import 'package:braincloud_dart/src/internal/wrapper_auth_callback_object.dart';

class ServerCallback {
  /// ServerCallback
  /// @param fnSuccessCallback : SuccessCallback
  /// @param fnFailureCallback : FailureCallback
  ServerCallback(this.fnSuccessCallback, this.fnFailureCallback, this.cbObject);

  SuccessCallback? fnSuccessCallback;
  FailureCallback? fnFailureCallback;
  dynamic cbObject;

  void onSuccessCallback(String jsonResponse) {
    fnSuccessCallback?.call(jsonResponse);
  }

  void onErrorCallback(int statusCode, int reasonCode, String statusMessage) {
    fnFailureCallback?.call(statusCode, reasonCode, statusMessage);
  }

  //This function can only add callbacks for Authenticate requests.
  void addAuthCallbacks(ServerCallback? inCallback) {
    if (inCallback != null) {
      WrapperAuthCallbackObject? callbackObject = inCallback.cbObject;

      if (callbackObject == null) {
        return;
      }

      //TODO: find a way to add events
      //fnSuccessCallback += callbackObject.successCallback!;
      //fnFailureCallback += callbackObject.failureCallback!;
    }
  }

  bool areCallbacksNull() {
    return fnSuccessCallback == null && fnFailureCallback == null;
  }
}

typedef SuccessCallback = void Function(String response);

/// @param int statusCode
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
