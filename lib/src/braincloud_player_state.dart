import 'dart:convert';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudPlayerState {
  final BrainCloudClient _clientRef;

  BrainCloudPlayerState(this._clientRef);

  /// <summary>
  /// Read the state of the currently logged in user.
  /// This method returns a JSON object describing most of the
  /// player's data: entities, statistics, level, currency.
  /// Apps will typically call this method after authenticating to get an
  /// up-to-date view of the user's data.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - Read
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readUserState(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerState, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Completely deletes the user record and all data fully owned
  /// by the user. After calling this method, the user will need
  /// to re-authenticate and create a new profile.
  /// This is mostly used for debugging/qa.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - FullReset
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void deleteUser(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    mergedCallback(String response) {
      if (success != null) {
        success(response);
      }
      _clientRef.wrapper.resetStoredAnonymousId();
      _clientRef.wrapper.resetStoredProfileId();
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        mergedCallback, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerState, ServiceOperation.fullReset, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// This method will delete *most* data for the currently logged in user.
  /// Data which is not deleted includes: currency, credentials, and
  /// purchase transactions. ResetUser is different from DeleteUser in that
  /// the player record will continue to exist after the reset (so the user
  /// does not need to re-authenticate).
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - DataReset
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void resetUser(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerState, ServiceOperation.dataReset, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Logs user out of server.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - Logout
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void logout(SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerState, ServiceOperation.logout, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Sets the user name.
  /// </summary>
  /// <remarks>
  /// Service Name - playerState
  /// Service Operation - UPDATE_NAME
  /// </remarks>
  /// <param name="userName">
  /// The name of the user
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
  void updateName(String userName, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceUpdateNameData.Value] = userName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PlayerState, ServiceOperation.updateName, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Updates the "friend summary data" associated with the logged in user.
  /// Some operations will return this summary data. For instance the social
  /// leaderboards will return the player's score in the leaderboard along
  /// with the friend summary data. Generally this data is used to provide
  /// a quick overview of the player without requiring a separate API call
  /// to read their stats or entity data.
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UpdateSummary
  /// </remarks>
  /// <param name="jsonSummaryData">
  /// A JSON String defining the summary data.
  /// For example:
  /// {
  ///   "xp":123,
  ///   "level":12,
  ///   "highScore":45123
  /// }
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  ///
  /// </param>
  void updateSummaryFriendData(String jsonSummaryData, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic>? data = {};
    if (Util.isOptionalParameterValid(jsonSummaryData)) {
      Map<String, dynamic> summaryData = jsonDecode(jsonSummaryData);
      data[OperationParam.PlayerStateServiceUpdateSummaryFriendData.Value] =
          summaryData;
    } else {
      data = null;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updateSummary, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieve the user's attributes.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - GetAttributes
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getAttributes(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.getAttributes, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update user's attributes.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UpdateAttributes
  /// </remarks>
  /// <param name="jsonAttributes">
  /// Single layer json String that is a set of key-value pairs
  /// </param>
  /// <param name="wipeExisting">
  /// Whether to wipe existing attributes prior to update.
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
  void updateAttributes(String jsonAttributes, bool wipeExisting,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    Map<String, dynamic> attributes = jsonDecode(jsonAttributes);
    data[OperationParam.PlayerStateServiceAttributes.Value] = attributes;
    data[OperationParam.PlayerStateServiceWipeExisting.Value] = wipeExisting;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updateAttributes, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Remove user's attributes.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - RemoveAttributes
  /// </remarks>
  /// <param name="attributeNames">
  /// List of attribute names.
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
  void removeAttributes(List<String> attributeNames, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceAttributes.Value] = attributeNames;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.removeAttributes, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Updates player's picture URL.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UPDATE_PICTURE_URL
  /// </remarks>
  /// <param name="pictureUrl">
  /// URL to apply.
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
  void updateUserPictureUrl(String pictureUrl, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServicePlayerPictureUrl.Value] = pictureUrl;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updatePictureUrl, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Update the user's contact email.
  /// Note this is unrelated to email authentication.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UPDATE_CONTACT_EMAIL
  /// </remarks>
  /// <param name="contactEmail">
  /// Updated email
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
  void updateContactEmail(String contactEmail, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceContactEmail.Value] = contactEmail;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updateContactEmail, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Clear the user's status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - ClearUserStatus
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void clearUserStatus(String statusName, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceStatusName.Value] = statusName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.clearUserStatus, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Extends the Status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - ExtendUserStatus
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="additionalSecs">
  /// The number of seconds to add.
  /// <param name="details">
  /// The details of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void extendUserStatus(String statusName, int additionalSecs, String details,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> detailsInfo = jsonDecode(details);
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceStatusName.Value] = statusName;
    data[OperationParam.PlayerStateServiceAdditionalSecs.Value] =
        additionalSecs;
    data[OperationParam.PlayerStateServiceDetails.Value] = detailsInfo;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.extendUserStatus, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the Status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - GetUserStatus
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getUserStatus(String statusName, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceStatusName.Value] = statusName;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.getUserStatus, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Sets the Status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - SetUserStatus
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="durationSecs">
  /// The number of seconds to add.
  /// <param name="details">
  /// The details of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void setUserStatus(String statusName, int durationSecs, String details,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> detailsInfo = jsonDecode(details);
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceStatusName.Value] = statusName;
    data[OperationParam.PlayerStateServiceDurationSecs.Value] = durationSecs;
    data[OperationParam.PlayerStateServiceDetails.Value] = detailsInfo;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.setUserStatus, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the Status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UpdateLanguageCode
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateLanguageCode(String languageCode, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceLanguageCode.Value] = languageCode;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updateLanguageCode, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the Status.
  /// </summary>
  /// <remarks>
  /// Service Name - PlayerState
  /// Service Operation - UpdateLanguageCode
  /// </remarks>
  /// <param name="statusName">
  /// The name of the status.
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateTimeZoneOffset(String timeZoneOffset, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PlayerStateServiceTimeZoneOffset.Value] =
        timeZoneOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PlayerState,
        ServiceOperation.updateTimeZoneOffset, data, callback);
    _clientRef.sendRequest(sc);
  }
}
