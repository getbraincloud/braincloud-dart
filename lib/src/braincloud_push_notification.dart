// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/common/platform.dart';
import '/src/braincloud_client.dart';

import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudPushNotification {
  final BrainCloudClient _clientRef;

  BrainCloudPushNotification(this._clientRef);

  /// Registers the given device token with the server to enable this device
  /// to receive push notifications.
  ///
  /// @param in_platform The device platform
  /// @param in_deviceToken The platform-dependent device token needed for push notifications.
  ///        On IOS, this is obtained using the application:didRegisterForRemoteNotificationsWithDeviceToken callback
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> registerPushNotificationDeviceToken(
      {required PlatformID platform, required String token}) {
    Completer<ServerResponse> completer = Completer();
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.register, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deregisters all device tokens currently registered to the user.
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> deregisterAllPushNotificationDeviceTokens() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.deregisterAll, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deregisters the given device token from the server to disable this device
  /// from receiving push notifications.
  ///
  /// @param in_device The device platform being deregistered.
  /// @param in_token The platform-dependent device token needed for push notifications.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> deregisterPushNotificationDeviceToken(
      {required PlatformID platform, required String token}) {
    Completer<ServerResponse> completer = Completer();
    String devicePlatform = platform.value;
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.deregister, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a simple push notification based on the passed in message.
  /// NOTE: It is possible to send a push notification to oneself.
  ///
  /// @param in_toProfileId The braincloud profileId of the user to receive the notification
  /// @param in_message Text of the push notification
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendSimplePushNotification(
      {required String profileId, required String message}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] = profileId;
    data[OperationParam.pushNotificationSendParamMessage.value] = message;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendSimple, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a notification to a user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  /// NOTE: It is possible to send a push notification to oneself.
  ///
  /// @param in_toProfileId The braincloud profileId of the user to receive the notification
  /// @param in_notificationTemplateId Id of the notification template
  /// @param in_substitutionJson JSON defining the substitution params to use with the template
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendRichPushNotificationWithParams(
      {required String profileId,
      required int notificationTemplateId,
      required Map<String, dynamic> substitutions}) {
    return sendRichPushNotification(
        profileId: profileId,
        notificationTemplateId: notificationTemplateId,
        substitutionJson: substitutions);
  }

  /// Sends a notification to a "group" of user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  ///
  /// @param in_groupId Target group
  /// @param in_notificationTemplateId Template to use
  /// @param in_substitutionsJson Map of substitution positions to strings
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendTemplatedPushNotificationToGroup(
      {required String groupId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutionsJson != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutionsJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendTemplatedToGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a notification to a "group" of user consisting of alert content and custom data.
  /// See the Portal documentation for more info.
  ///
  /// @param in_groupId Target group
  /// @param in_alertContentJson Body and title of alert
  /// @param in_customDataJson Optional custom data
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendNormalizedPushNotificationToGroup(
      {required String groupId,
      required Map<String, dynamic> alertContent,
      Map<String, dynamic>? customData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.alertContent.value] = alertContent;
    if (customData != null) {
      data[OperationParam.customData.value] = customData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalizedToGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Schedules a normalized push notification to a user
  ///
  /// @param in_profileId The profileId of the user to receive the notification
  /// @param in_fcmContent Valid Fcm data content
  /// @param in_iosContent Valid ios data content
  /// @param in_facebookContent Facebook template string
  /// @param in_startTimeUTC Start time of sending the push notification in milliseconds, use UTC time in milliseconds since epoch
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRawPushNotificationUTC(
      {required String profileId,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profileId.value] = profileId;

    if (fcmContent != null) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          fcmContent;
    }

    if (iosContent != null) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          iosContent;
    }

    if (facebookContent != null) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          facebookContent;
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Schedules a normalized push notification to a user
  ///
  /// @param in_profileId The profileId of the user to receive the notification
  /// @param in_fcmContent Valid Fcm data content
  /// @param in_iosContent Valid ios data content
  /// @param in_facebookContent Facebook template string
  /// @param minutesFromNow Minutes from now to send the push notification
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRawPushNotificationMinutes(
      {required String profileId,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profileId.value] = profileId;

    if (fcmContent != null) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          fcmContent;
    }

    if (iosContent != null) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          iosContent;
    }

    if (facebookContent != null) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          facebookContent;
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a raw push notification to a target user.
  ///
  /// @param toProfileId The profileId of the user to receive the notification
  /// @param fcmContent Valid Fcm data content
  /// @param iosContent Valid ios data content
  /// @param facebookContent Facebook template string
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendRawPushNotification(
      {required String profileId,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] = profileId;

    if (fcmContent != null) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          fcmContent;
    }

    if (iosContent != null) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          iosContent;
    }

    if (facebookContent != null) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          facebookContent;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.pushNotification, ServiceOperation.sendRaw, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a raw push notification to a target list of users.
  ///
  /// @param in_profileIds Collection of profile IDs to send the notification to
  /// @param in_fcmContent Valid Fcm data content
  /// @param in_iosContent Valid ios data content
  /// @param in_facebookContent Facebook template string
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendRawPushNotificationBatch(
      {required List<String> profileIds,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;

    if (fcmContent != null) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          fcmContent;
    }

    if (iosContent != null) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          iosContent;
    }

    if (facebookContent != null) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          facebookContent;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRawBatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a raw push notification to a target group.
  ///
  /// @param in_groupId Target group
  /// @param in_fcmContent Valid Fcm data content
  /// @param in_iosContent Valid ios data content
  /// @param in_facebookContent Facebook template stringn
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendRawPushNotificationToGroup(
      {required String groupId,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    if (fcmContent != null) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          fcmContent;
    }

    if (iosContent != null) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          iosContent;
    }

    if (facebookContent != null) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          facebookContent;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRawToGroup, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Schedules a normalized push notification to a user
  ///
  /// @param in_toProfileId The profileId of the user to receive the notification
  /// @param in_alertContentJson Body and title of alert
  /// @param in_customDataJson Optional custom data
  /// @param in_startTimeUTC Start time of sending the push notification in milliseconds, use UTC time in milliseconds since epoch
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleNormalizedPushNotificationUTC(
      {required String profileId,
      required Map<String, dynamic> alertContent,
      Map<String, dynamic>? customData,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = alertContent;

    if (customData != null) {
      data[OperationParam.customData.value] = customData;
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Schedules a normalized push notification to a user
  ///
  /// @param in_toProfileId The profileId of the user to receive the notification
  /// @param in_alertContentJson Body and title of alert
  /// @param in_customDataJson Optional custom data
  /// @param in_minutesFromNow Minutes from now to send the push notification
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleNormalizedPushNotificationMinutes(
      {required String profileId,
      required Map<String, dynamic> alertContent,
      Map<String, dynamic>? customData,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = alertContent;

    if (customData != null) {
      data[OperationParam.customData.value] = customData;
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Schedules a rich push notification to a user
  ///
  /// @param in_toProfileId The profileId of the user to receive the notification
  /// @param in_notificationTemplateId Body and title of alert
  /// @param in_substitutionsJson Map of substitution positions to strings
  /// @param in_startTimeUTC Start time of sending the push notification in milliseconds, use UTC time in milliseconds since epoch
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRichPushNotificationUTC(
      {required String profileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutions,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutions != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutions;
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Schedules a rich push notification to a user
  ///
  /// @param in_toProfileId The profileId of the user to receive the notification
  /// @param in_notificationTemplateId Body and title of alert
  /// @param in_substitutionsJson Map of substitution positions to strings
  /// @param in_minutesFromNow Minutes from now to send the push notification
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> scheduleRichPushNotificationMinutes(
      {required String profileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutions,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutions != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutions;
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a notification to a user consisting of alert content and custom data.
  ///
  /// @param in_toProfileId The profileId of the user to receive the notification
  /// @param in_alertContent Body and title of alert
  /// @param in_customData Optional custom data
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendNormalizedPushNotification(
      {required String profileId,
      required Map<String, dynamic> alertContent,
      Map<String, dynamic>? customData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] = profileId;
    data[OperationParam.alertContent.value] = alertContent;
    if (customData != null) {
      data[OperationParam.customData.value] = customData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalized, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a notification to multiple users consisting of alert content and custom data.
  ///
  /// @param in_profileIds Collection of profile IDs to send the notification to
  /// @param in_alertContent Body and title of alert
  /// @param in_customData Optional custom data
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendNormalizedPushNotificationBatch(
      {required List<String> profileIds,
      required Map<String, dynamic> alertContent,
      Map<String, dynamic>? customData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;
    data[OperationParam.alertContent.value] = alertContent;
    if (customData != null) {
      data[OperationParam.customData.value] = customData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalizedBatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// returns `Future<ServerResponse>`
  Future<ServerResponse> sendRichPushNotification(
      {required String profileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutionJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutionJson != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutionJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRich, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
