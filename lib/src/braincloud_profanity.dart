// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudProfanity {
  final BrainCloudClient _clientRef;

  BrainCloudProfanity(this._clientRef);

  /// Checks supplied text for profanity.
  /// Service Name - Profanity
  /// Service Operation - ProfanityCheck
  ///
  /// @param in_text The text to check
  /// @param in_languages Optional comma delimited list of two character language codes
  /// @param in_flagEmail Optional processing of email addresses
  /// @param in_flagPhone Optional processing of phone numbers
  /// @param in_flagUrls Optional processing of urls
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.profanity, ServiceOperation.profanityCheck, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Replaces the characters of profanity text with a passed character(s).
  /// Service Name - Profanity
  /// Service Operation - ProfanityReplaceText
  ///
  /// @param in_text The text to check
  /// @param in_replaceSymbol The text to replace individual characters of profanity text with
  /// @param in_languages Optional comma delimited list of two character language codes
  /// @param in_flagEmail Optional processing of email addresses
  /// @param in_flagPhone Optional processing of phone numbers
  /// @param in_flagUrls Optional processing of urls
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.profanity,
        ServiceOperation.profanityReplaceText, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Checks supplied text for profanity and returns a list of bad wors.
  /// Service Name - Profanity
  /// Service Operation - ProfanityIdentifyBadWords
  ///
  /// @param in_text The text to check
  /// @param in_languages Optional comma delimited list of two character language codes
  /// @param in_flagEmail Optional processing of email addresses
  /// @param in_flagPhone Optional processing of phone numbers
  /// @param in_flagUrls Optional processing of urls
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.profanity,
        ServiceOperation.profanityIdentifyBadWords, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
