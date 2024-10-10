import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudPlayerState {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerState(this._clientRef);

  /// Read the state of the currently logged in user.
  /// This method returns a JSON object describing most of the
  /// player's data: entities, statistics, level, currency.
  /// Apps will typically call this method after authenticating to get an
  /// up-to-date view of the user's data.

  /// Service Name - PlayerState
  /// Service Operation - Read

  /// @returns Future<ServerResponse>
  Future<ServerResponse> readUserState() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playerState, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Completely deletes the user record and all data fully owned
  /// by the user. After calling this method, the user will need
  /// to re-authenticate and create a new profile.
  /// This is mostly used for debugging/qa.

  /// Service Name - PlayerState
  /// Service Operation - FullReset

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteUser() {
    Completer<ServerResponse> completer = Completer();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) {
        _clientRef.wrapper.resetStoredAnonymousId();
        _clientRef.wrapper.resetStoredProfileId();
        completer.complete(ServerResponse.fromJson(response));
      },
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playerState, ServiceOperation.fullReset, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// This method will delete *most* data for the currently logged in user.
  /// Data which is not deleted includes: currency, credentials, and
  /// purchase transactions. ResetUser is different from DeleteUser in that
  /// the player record will continue to exist after the reset (so the user
  /// does not need to re-authenticate).

  /// Service Name - PlayerState
  /// Service Operation - DataReset

  /// @returns Future<ServerResponse>
  Future<ServerResponse> resetUser() {
    Completer<ServerResponse> completer = Completer();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playerState, ServiceOperation.dataReset, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Logs user out of server.

  /// Service Name - PlayerState
  /// Service Operation - Logout

  /// @returns Future<ServerResponse>
  Future<ServerResponse> logout() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playerState, ServiceOperation.logout, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sets the user name.

  /// Service Name - playerState
  /// Service Operation - UPDATE_NAME

  /// @param userName
  /// The name of the user

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateName({required String userName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceUpdateNameData.value] = userName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.playerState, ServiceOperation.updateName, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates the "friend summary data" associated with the logged in user.
  /// Some operations will return this summary data. For instance the social
  /// leaderboards will return the player's score in the leaderboard along
  /// with the friend summary data. Generally this data is used to provide
  /// a quick overview of the player without requiring a separate API call
  /// to read their stats or entity data.
  ///

  /// Service Name - PlayerState
  /// Service Operation - UpdateSummary

  /// @param jsonSummaryData
  /// A JSON String defining the summary data.
  /// For example:
  /// {
  ///   "xp":123,
  ///   "level":12,
  ///   "highScore":45123
  /// }

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateSummaryFriendData(
      {required String jsonSummaryData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic>? data = {};
    if (Util.isOptionalParameterValid(jsonSummaryData)) {
      Map<String, dynamic> summaryData = jsonDecode(jsonSummaryData);
      data[OperationParam.playerStateServiceUpdateSummaryFriendData.value] =
          summaryData;
    } else {
      data = null;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updateSummary, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve the user's attributes.

  /// Service Name - PlayerState
  /// Service Operation - GetAttributes

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getAttributes() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.getAttributes, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Update user's attributes.

  /// Service Name - PlayerState
  /// Service Operation - UpdateAttributes

  /// @param jsonAttributes
  /// Single layer json String that is a set of key-value pairs

  /// @param wipeExisting
  /// Whether to wipe existing attributes prior to update.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateAttributes(
      {required String jsonAttributes, required bool wipeExisting}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    Map<String, dynamic> attributes = jsonDecode(jsonAttributes);
    data[OperationParam.playerStateServiceAttributes.value] = attributes;
    data[OperationParam.playerStateServiceWipeExisting.value] = wipeExisting;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updateAttributes, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Remove user's attributes.

  /// Service Name - PlayerState
  /// Service Operation - RemoveAttributes

  /// @param attributeNames
  /// List of attribute names.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> removeAttributes(
      {required List<String> attributeNames}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceAttributes.value] = attributeNames;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.removeAttributes, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates player's picture URL.

  /// Service Name - PlayerState
  /// Service Operation - UPDATE_PICTURE_URL

  /// @param pictureUrl
  /// URL to apply.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateUserPictureUrl({required String pictureUrl}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServicePlayerPictureUrl.value] = pictureUrl;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updatePictureUrl, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Update the user's contact email.
  /// Note this is unrelated to email authentication.

  /// Service Name - PlayerState
  /// Service Operation - UPDATE_CONTACT_EMAIL

  /// @param contactEmail
  /// Updated email

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateContactEmail({required String contactEmail}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceContactEmail.value] = contactEmail;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updateContactEmail, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Clear the user's status.

  /// Service Name - PlayerState
  /// Service Operation - ClearUserStatus

  /// @param statusName
  /// The name of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> clearUserStatus({required String statusName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceStatusName.value] = statusName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.clearUserStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Extends the Status.

  /// Service Name - PlayerState
  /// Service Operation - ExtendUserStatus

  /// @param statusName
  /// The name of the status.
  /// @param additionalSecs
  /// The number of seconds to add.
  /// @param details
  /// The details of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> extendUserStatus(
      {required String statusName,
      required int additionalSecs,
      required String details}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> detailsInfo = jsonDecode(details);
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceStatusName.value] = statusName;
    data[OperationParam.playerStateServiceAdditionalSecs.value] =
        additionalSecs;
    data[OperationParam.playerStateServiceDetails.value] = detailsInfo;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.extendUserStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the Status.

  /// Service Name - PlayerState
  /// Service Operation - GetUserStatus

  /// @param statusName
  /// The name of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getUserStatus({required String statusName}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceStatusName.value] = statusName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.getUserStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sets the Status.

  /// Service Name - PlayerState
  /// Service Operation - SetUserStatus

  /// @param statusName
  /// The name of the status.
  /// @param durationSecs
  /// The number of seconds to add.
  /// @param details
  /// The details of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> setUserStatus(
      {required String statusName,
      required int durationSecs,
      required String details}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> detailsInfo = jsonDecode(details);
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceStatusName.value] = statusName;
    data[OperationParam.playerStateServiceDurationSecs.value] = durationSecs;
    data[OperationParam.playerStateServiceDetails.value] = detailsInfo;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.setUserStatus, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the Status.

  /// Service Name - PlayerState
  /// Service Operation - UpdateLanguageCode

  /// @param statusName
  /// The name of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateLanguageCode({required String languageCode}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceLanguageCode.value] = languageCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updateLanguageCode, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the Status.

  /// Service Name - PlayerState
  /// Service Operation - UpdateLanguageCode

  /// @param statusName
  /// The name of the status.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateTimeZoneOffset(
      {required String timeZoneOffset}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.playerStateServiceTimeZoneOffset.value] =
        timeZoneOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.playerState,
        ServiceOperation.updateTimeZoneOffset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
