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
  ///
  /// Service Name - Profanity
  /// Service Operation - ProfanityCheck
  ///
  /// @param textThe text to check
  ///
  /// @param languagesOptional comma delimited list of two character language codes
  ///
  /// @param flagEmailOptional processing of email addresses
  ///
  /// @param flagPhoneOptional processing of phone numbers
  ///
  /// @param flagUrlsOptional processing of urls
  ///
  /// returns `Future<ServerResponse>`
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
  ///
  /// Service Name - Profanity
  /// Service Operation - ProfanityReplaceText
  ///
  /// @param textThe text to check
  ///
  /// @param replaceSymbolThe text to replace individual characters of profanity text with
  ///
  /// @param languagesOptional comma delimited list of two character language codes
  ///
  /// @param flagEmailOptional processing of email addresses
  ///
  /// @param flagPhoneOptional processing of phone numbers
  ///
  /// @param flagUrlsOptional processing of urls
  ///
  /// returns `Future<ServerResponse>`
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
  ///
  /// Service Name - Profanity
  /// Service Operation - ProfanityIdentifyBadWords
  ///
  /// @param textThe text to check
  ///
  /// @param languagesOptional comma delimited list of two character language codes
  ///
  /// @param flagEmailOptional processing of email addresses
  ///
  /// @param flagPhoneOptional processing of phone numbers
  ///
  /// @param flagUrlsOptional processing of urls
  ///
  /// returns `Future<ServerResponse>`
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
