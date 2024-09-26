import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudProfanity {
  final BrainCloudClient _clientRef;

  BrainCloudProfanity(this._clientRef);

  /// <summary>
  /// Checks supplied text for profanity.
  /// </summary>
  /// <remarks>
  /// Service Name - Profanity
  /// Service Operation - ProfanityCheck
  /// </remarks>
  /// <param name="text">The text to check</param>
  /// <param name="languages">Optional comma delimited list of two character language codes</param>
  /// <param name="flagEmail">Optional processing of email addresses</param>
  /// <param name="flagPhone">Optional processing of phone numbers</param>
  /// <param name="flagUrls">Optional processing of urls</param>
  Future<ServerResponse> profanityCheck(
      {required String text,
      String? languages,
      required bool flagEmail,
      required bool flagPhone,
      required bool flagUrls}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profanityText.value] = text;
    if (languages != null) {
      data[OperationParam.profanityLanguages.value] = languages;
    }
    data[OperationParam.profanityFlagEmail.value] = flagEmail;
    data[OperationParam.profanityFlagPhone.value] = flagPhone;
    data[OperationParam.profanityFlagUrls.value] = flagUrls;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.profanity, ServiceOperation.profanityCheck, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Replaces the characters of profanity text with a passed character(s).
  /// </summary>
  /// <remarks>
  /// Service Name - Profanity
  /// Service Operation - ProfanityReplaceText
  /// </remarks>
  /// <param name="text">The text to check</param>
  /// <param name="replaceSymbol">The text to replace individual characters of profanity text with</param>
  /// <param name="languages">Optional comma delimited list of two character language codes</param>
  /// <param name="flagEmail">Optional processing of email addresses</param>
  /// <param name="flagPhone">Optional processing of phone numbers</param>
  /// <param name="flagUrls">Optional processing of urls</param>
  Future<ServerResponse> profanityReplaceText(
      {required String text,
      required String replaceSymbol,
      String? languages,
      required bool flagEmail,
      required bool flagPhone,
      required bool flagUrls}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profanityText.value] = text;
    data[OperationParam.profanityReplaceSymbol.value] = replaceSymbol;
    if (languages != null) {
      data[OperationParam.profanityLanguages.value] = languages;
    }
    data[OperationParam.profanityFlagEmail.value] = flagEmail;
    data[OperationParam.profanityFlagPhone.value] = flagPhone;
    data[OperationParam.profanityFlagUrls.value] = flagUrls;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.profanity,
        ServiceOperation.profanityReplaceText, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Checks supplied text for profanity and returns a list of bad wors.
  /// </summary>
  /// <remarks>
  /// Service Name - Profanity
  /// Service Operation - ProfanityIdentifyBadWords
  /// </remarks>
  /// <param name="text">The text to check</param>
  /// <param name="languages">Optional comma delimited list of two character language codes</param>
  /// <param name="flagEmail">Optional processing of email addresses</param>
  /// <param name="flagPhone">Optional processing of phone numbers</param>
  /// <param name="flagUrls">Optional processing of urls</param>
  Future<ServerResponse> profanityIdentifyBadWords(
      {required String text,
      String? languages,
      required bool flagEmail,
      required bool flagPhone,
      required bool flagUrls}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profanityText.value] = text;
    if (languages != null) {
      data[OperationParam.profanityLanguages.value] = languages;
    }
    data[OperationParam.profanityFlagEmail.value] = flagEmail;
    data[OperationParam.profanityFlagPhone.value] = flagPhone;
    data[OperationParam.profanityFlagUrls.value] = flagUrls;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.profanity,
        ServiceOperation.profanityIdentifyBadWords, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
