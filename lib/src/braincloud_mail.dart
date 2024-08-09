import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudMail {
  final BrainCloudClient _clientRef;

  BrainCloudMail(this._clientRef);

  /// <summary>
  /// Sends a simple text email to the specified user
  /// </summary>
  /// <remarks>
  /// Service Name - mail
  /// Service Operation - SEND_BASIC_EMAIL
  /// </remarks>
  /// <param name="toProfileId">
  /// The user to send the email to
  /// </param>
  /// <param name="subject">
  /// The email subject
  /// </param>
  /// <param name="body">
  /// The email body
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void sendBasicEmail(String profileId, String subject, String body,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.ProfileId.Value] = profileId;
    data[OperationParam.Subject.Value] = subject;
    data[OperationParam.Body.Value] = body;

    _sendMessage(ServiceOperation.sendBasicEmail, data, success, failure,
        cbObject: cbObject);
  }

  /// <summary>
  /// Sends an advanced email to the specified user
  /// </summary>
  /// <remarks>
  /// Service Name - mail
  /// Service Operation - SEND_ADVANCED_EMAIL
  /// </remarks>
  /// <param name="toProfileId">
  /// The user to send the email to
  /// </param>
  /// <param name="jsonServiceParams">
  /// Parameters to send to the email service. See the documentation for
  /// a full list. http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void sendAdvancedEmail(String profileId, String jsonServiceParams,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.ProfileId.Value] = profileId;
    data[OperationParam.ServiceParams.Value] = jsonDecode(jsonServiceParams);

    _sendMessage(ServiceOperation.sendAdvancedEmail, data, success, failure,
        cbObject: cbObject);
  }

  /// <summary>
  /// Sends an advanced email to the specified email address
  /// </summary>
  /// <remarks>
  /// Service Name - mail
  /// Service Operation - SEND_ADVANCED_EMAIL_BY_EMAIL
  /// </remarks>
  /// <param name="emailAddress">
  /// The address to send the email to
  /// </param>
  /// <param name="jsonServiceParams">
  /// Parameters to send to the email service. See the documentation for
  /// a full list. http://getbraincloud.com/apidocs/apiref/#capi-mail
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void sendAdvancedEmailByAddress(String emailAddress, String jsonServiceParams,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.EmailAddress.Value] = emailAddress;
    data[OperationParam.ServiceParams.Value] = jsonDecode(jsonServiceParams);

    _sendMessage(
        ServiceOperation.sendAdvancedEmailByAddress, data, success, failure,
        cbObject: cbObject);
  }

  // Private
  void _sendMessage(ServiceOperation operation, Map<String, dynamic> data,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    _clientRef
        .sendRequest(ServerCall(ServiceName.mail, operation, data, callback));
  }
}
