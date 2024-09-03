import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

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
  Future<ServerResponse> sendBasicEmail(
      {required String profileId,
      required String subject,
      required String body}) {
    Map<String, dynamic> data = {};

    data[OperationParam.profileId.value] = profileId;
    data[OperationParam.subject.value] = subject;
    data[OperationParam.body.value] = body;

    return _sendMessage(ServiceOperation.sendBasicEmail, data);
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
  Future<ServerResponse> sendAdvancedEmail(
      {required String profileId, required String jsonServiceParams}) {
    Map<String, dynamic> data = {};

    data[OperationParam.profileId.value] = profileId;
    data[OperationParam.serviceParams.value] = jsonDecode(jsonServiceParams);

    return _sendMessage(
      ServiceOperation.sendAdvancedEmail,
      data,
    );
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
  Future<ServerResponse> sendAdvancedEmailByAddress(
      {required String emailAddress, required String jsonServiceParams}) {
    Map<String, dynamic> data = {};

    data[OperationParam.emailAddress.value] = emailAddress;
    data[OperationParam.serviceParams.value] = jsonDecode(jsonServiceParams);

    return _sendMessage(ServiceOperation.sendAdvancedEmailByAddress, data);
  }

  // Private
  Future<ServerResponse> _sendMessage(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    _clientRef
        .sendRequest(ServerCall(ServiceName.mail, operation, data, callback));

    return completer.future;
  }
}
