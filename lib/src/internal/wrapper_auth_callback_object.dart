// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import '/src/server_callback.dart';

class WrapperAuthCallbackObject {
  SuccessCallback? successCallback;
  FailureCallback? failureCallback;

  WrapperAuthCallbackObject(this.successCallback, this.failureCallback);
}
