import 'package:braincloud_dart/src/server_callback.dart';

class WrapperAuthCallbackObject {
  dynamic cbObject;
  SuccessCallback? successCallback;
  FailureCallback? failureCallback;

  WrapperAuthCallbackObject(this.successCallback, this.failureCallback,
      {this.cbObject});
}
