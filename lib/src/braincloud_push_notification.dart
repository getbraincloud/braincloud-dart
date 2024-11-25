import 'dart:async';

import 'package:braincloud_dart/src/common/platform.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudPushNotification {
  final BrainCloudClient _clientRef;

  BrainCloudPushNotification(this._clientRef);

  /// Registers the given device token with the server to enable this device
  /// to receive push notifications.
  ///
  /// @param device
  /// The device platform being registered.
  ///
  /// @param token
  /// The platform-dependant device token needed for push notifications.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> registerPushNotificationDeviceToken(
      {required Platform platform, required String token}) {
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
  /// returns Future<ServerResponse>
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
  /// @param platform
  /// The device platform being registered.
  ///
  /// @param token
  /// The platform-dependant device token needed for push notifications.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deregisterPushNotificationDeviceToken(
      {required Platform platform, required String token}) {
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
        ServiceOperation.deregister, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sends a simple push notification based on the passed in message.
  /// NOTE: It is possible to send a push notification to oneself.
  ///
  /// @param toProfileId
  /// The braincloud profileId of the user to receive the notification
  ///
  /// @param message
  /// Text of the push notification
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendSimplePushNotification(
      {required String toProfileId, required String message}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
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
  /// @param toProfileId
  /// The braincloud profileId of the user to receive the notification
  ///
  /// @param notificationTemplateId
  /// Id of the notification template
  ///
  /// @param substitutionJson
  /// JSON defining the substitution params to use with the template
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendRichPushNotificationWithParams(
      {required String toProfileId,
      required int notificationTemplateId,
      required Map<String, dynamic> substitutionJson}) {
    return sendRichPushNotification(
        toProfileId: toProfileId,
        notificationTemplateId: notificationTemplateId,
        substitutionJson: substitutionJson);
  }

  /// Sends a notification to a "group" of user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  ///
  /// @param groupId
  /// Target group
  ///
  /// @param notificationTemplateId
  /// Id of the notification template
  ///
  /// @param substitutionsJson
  /// JSON defining the substitution params to use with the template
  ///
  /// returns Future<ServerResponse>
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

  /// Sends a notification to a "group" of user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  ///
  /// @param groupId
  /// Target group
  ///
  /// @param alertContentJson
  /// Body and title of alert
  ///
  /// @param customDataJson
  /// Optional custom data
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendNormalizedPushNotificationToGroup(
      {required String groupId,
      required Map<String, dynamic> alertContentJson,
      Map<String, dynamic>? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.alertContent.value] = alertContentJson;
    if (customDataJson != null) {
      data[OperationParam.customData.value] = customDataJson;
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

  /// Schedules raw notifications based on user local time.
  ///
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param fcmContent
  /// Valid Fcm data content
  ///
  /// @param iosContent
  /// Valid ios data content
  ///
  /// @param facebookContent
  /// Facebook template String
  ///
  /// @param startTimeUTC
  /// Start time of sending the push notification
  ///
  /// returns Future<ServerResponse>
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

  /// Schedules raw notifications based on user local time.
  ///
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param fcmContent
  /// Valid Fcm data content
  ///
  /// @param iosContent
  /// Valid ios data content
  ///
  /// @param facebookContent
  /// Facebook template String
  ///
  /// @param minutesFromNow
  /// Minutes from now to send the push notification
  ///
  /// returns Future<ServerResponse>
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
  /// @param toProfileId
  /// The profileId of the user to receive the notification
  ///
  /// @param fcmContent
  /// Valid Fcm data content
  ///
  /// @param iosContent
  /// Valid ios data content
  ///
  /// @param facebookContent
  /// Facebook template String
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendRawPushNotification(
      {required String profileId,
      Map<String, dynamic>? fcmContent,
      Map<String, dynamic>? iosContent,
      Map<String, dynamic>? facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        profileId;

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
  /// @param profileIds
  /// Collection of profile IDs to send the notification to
  ///
  /// @param fcmContent
  /// Valid Fcm data content
  ///
  /// @param iosContent
  /// Valid ios data content
  ///
  /// @param facebookContent
  /// Facebook template String
  ///
  /// returns Future<ServerResponse>
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
  /// @param groupId
  /// Target group
  ///
  /// @param fcmContent
  /// Valid Fcm data content
  ///
  /// @param iosContent
  /// Valid ios data content
  ///
  /// @param facebookContent
  /// Facebook template String
  ///
  /// returns Future<ServerResponse>
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
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param alertContentJson
  /// Body and title of alert
  ///
  /// @param customDataJson
  /// Optional custom data
  ///
  /// @param startTimeUTC
  /// Start time of sending the push notification
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleNormalizedPushNotificationUTC(
      {required String profileId,
      required Map<String, dynamic> alertContentJson,
      Map<String, dynamic>? customDataJson,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = alertContentJson;

    if (customDataJson != null) {
      data[OperationParam.customData.value] = customDataJson;
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
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param alertContentJson
  /// Body and title of alert
  ///
  /// @param customDataJson
  /// Optional custom data
  ///
  /// @param minutesFromNow
  /// Minutes from now to send the push notification
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleNormalizedPushNotificationMinutes(
      {required String profileId,
      required Map<String, dynamic> alertContentJson,
      Map<String, dynamic>? customDataJson,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = alertContentJson;

    if (customDataJson != null) {
      data[OperationParam.customData.value] = customDataJson;
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
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param notificationTemplateId
  /// Body and title of alert
  ///
  /// @param substitutionsJson
  /// Optional custom data
  ///
  /// @param startTimeUTC
  /// Start time of sending the push notification
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleRichPushNotificationUTC(
      {required String profileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutionsJson,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutionsJson != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutionsJson;
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
  /// @param profileId
  /// The profileId of the user to receive the notification
  ///
  /// @param notificationTemplateId
  /// Body and title of alert
  ///
  /// @param substitutionsJson
  /// Optional custom data
  ///
  /// @param minutesFromNow
  /// Minutes from now to send the push notification
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> scheduleRichPushNotificationMinutes(
      {required String profileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutionsJson,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (substitutionsJson != null) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          substitutionsJson;
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
  /// @param toProfileId
  /// The profileId of the user to receive the notification
  ///
  /// @param alertContentJson
  /// Body and title of alert
  ///
  /// @param customDataJson
  /// Optional custom data
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendNormalizedPushNotification(
      {required String toProfileId,
      required Map<String, dynamic> alertContentJson,
      Map<String, dynamic>? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.alertContent.value] = alertContentJson;
    if (customDataJson != null) {
      data[OperationParam.customData.value] = customDataJson;
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
  /// @param profileIds
  /// Collection of profile IDs to send the notification to
  ///
  /// @param alertContentJson
  /// Body and title of alert
  ///
  /// @param customDataJson
  /// Optional custom data
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> sendNormalizedPushNotificationBatch(
      {required List<String> profileIds,
      required Map<String, dynamic> alertContentJson,
      Map<String, dynamic>? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;
    data[OperationParam.alertContent.value] = alertContentJson;
    if (customDataJson != null) {
      data[OperationParam.customData.value] = customDataJson;
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

  /// returns Future<ServerResponse>
  Future<ServerResponse> sendRichPushNotification(
      {required String toProfileId,
      required int notificationTemplateId,
      Map<String, dynamic>? substitutionJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
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
