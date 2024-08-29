import 'package:braincloud_dart/src/server_callback.dart';

class WrapperAuthCallbackObject {
  SuccessCallback? successCallback;
  FailureCallback? failureCallback;

  WrapperAuthCallbackObject(this.successCallback, this.failureCallback);
}
