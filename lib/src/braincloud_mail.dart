import 'dart:async';

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

  /// Sends a simple text email to the specified user
  ///
  /// Service Name - mail
  /// Service Operation - SEND_BASIC_EMAIL
  ///
  /// @param toProfileId
  /// The user to send the email to
  ///
  /// @param subject
  /// The email subject
  ///
  /// @param body
  /// The email body
  ///
  /// returns `Future<ServerResponse>`
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

  /// Sends an advanced email to the specified user
  ///
  /// Service Name - mail
  /// Service Operation - SEND_ADVANCED_EMAIL
  ///
  /// @param toProfileId
  /// The user to send the email to
  ///
  /// @param jsonServiceParams
  /// Parameters to send to the email service. See the documentation for
  /// a full list. http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> sendAdvancedEmail(
      {required String profileId,
      required Map<String, dynamic> serviceParams}) {
    Map<String, dynamic> data = {};

    data[OperationParam.profileId.value] = profileId;
    data[OperationParam.serviceParams.value] = serviceParams;

    return _sendMessage(
      ServiceOperation.sendAdvancedEmail,
      data,
    );
  }

  /// Sends an advanced email to the specified email address
  ///
  /// Service Name - mail
  /// Service Operation - SEND_ADVANCED_EMAIL_BY_EMAIL
  ///
  /// @param emailAddress
  /// The address to send the email to
  ///
  /// @param jsonServiceParams
  /// Parameters to send to the email service. See the documentation for
  /// a full list. http://getbraincloud.com/apidocs/apiref/#capi-mail
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> sendAdvancedEmailByAddress(
      {required String emailAddress,
      required Map<String, dynamic> serviceParams}) {
    Map<String, dynamic> data = {};

    data[OperationParam.emailAddress.value] = emailAddress;
    data[OperationParam.serviceParams.value] = serviceParams;

    return _sendMessage(ServiceOperation.sendAdvancedEmailByAddress, data);
  }

  /// returns `Future<ServerResponse>`
  Future<ServerResponse> _sendMessage(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    _clientRef
        .sendRequest(ServerCall(ServiceName.mail, operation, data, callback));

    return completer.future;
  }
}
