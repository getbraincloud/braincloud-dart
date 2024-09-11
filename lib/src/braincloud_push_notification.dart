import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/common/platform.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudPushNotification {
  final BrainCloudClient _clientRef;

  BrainCloudPushNotification(this._clientRef);

  /// <summary>
  /// Registers the given device token with the server to enable this device
  /// to receive push notifications.
  /// </param>
  /// <param name="device">
  /// The device platform being registered.
  /// </param>
  /// <param name="token">
  /// The platform-dependant device token needed for push notifications.
  /// </param>
  Future<ServerResponse> registerPushNotificationDeviceToken(
      {required Platform platform, required String token}) {
    Completer<ServerResponse> completer = Completer();
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.register, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Deregisters all device tokens currently registered to the user.
  /// </param>
  Future<ServerResponse> deregisterAllPushNotificationDeviceTokens() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.deregisterAll, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Deregisters the given device token from the server to disable this device
  /// from receiving push notifications.
  /// </param>
  /// <param name="platform">
  /// The device platform being registered.
  /// </param>
  /// <param name="token">
  /// The platform-dependant device token needed for push notifications.
  /// </param>
  Future<ServerResponse> deregisterPushNotificationDeviceToken(
      {required Platform platform, required String token}) {
    Completer<ServerResponse> completer = Completer();
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.deregister, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a simple push notification based on the passed in message.
  /// NOTE: It is possible to send a push notification to oneself.
  /// </param>
  /// <param name="toProfileId">
  /// The braincloud profileId of the user to receive the notification
  /// </param>
  /// <param name="message">
  /// Text of the push notification
  /// </param>
  Future<ServerResponse> sendSimplePushNotification(
      {required String toProfileId, required String message}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.pushNotificationSendParamMessage.value] = message;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendSimple, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a notification to a user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  /// NOTE: It is possible to send a push notification to oneself.
  /// </param>
  /// <param name="toProfileId">
  /// The braincloud profileId of the user to receive the notification
  /// </param>
  /// <param name="notificationTemplateId">
  /// Id of the notification template
  /// </param>
  /// <param name="substitutionJson">
  /// JSON defining the substitution params to use with the template
  /// </param>
  Future<ServerResponse> sendRichPushNotificationWithParams(
      {required String toProfileId,
      required int notificationTemplateId,
      required String substitutionJson}) {
    return sendRichPushNotification(
        toProfileId: toProfileId,
        notificationTemplateId: notificationTemplateId,
        substitutionJson: substitutionJson);
  }

  /// <summary>
  /// Sends a notification to a "group" of user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  /// </param>
  /// <param name="groupId">
  /// Target group
  /// </param>
  /// <param name="notificationTemplateId">
  /// Id of the notification template
  /// </param>
  /// <param name="substitutionsJson">
  /// JSON defining the substitution params to use with the template
  /// </param>
  Future<ServerResponse> sendTemplatedPushNotificationToGroup(
      {required String groupId,
      required int notificationTemplateId,
      required String substitutionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          jsonDecode(substitutionsJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendTemplatedToGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a notification to a "group" of user based on a brainCloud portal configured notification template.
  /// Includes JSON defining the substitution params to use with the template.
  /// See the Portal documentation for more info.
  /// </param>
  /// <param name="groupId">
  /// Target group
  /// </param>
  /// <param name="alertContentJson">
  /// Body and title of alert
  /// </param>
  /// <param name="customDataJson">
  /// Optional custom data
  /// </param>
  Future<ServerResponse> sendNormalizedPushNotificationToGroup(
      {required String groupId,
      required String alertContentJson,
      String? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson!);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalizedToGroup, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Schedules raw notifications based on user local time.
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="fcmContent">
  /// Valid Fcm data content
  /// </param>
  /// <param name="iosContent">
  /// Valid ios data content
  /// </param>
  /// <param name="facebookContent">
  /// Facebook template String
  /// </param>
  /// <param name="startTimeUTC">
  /// Start time of sending the push notification
  /// </param>
  Future<ServerResponse> scheduleRawPushNotificationUTC(
      {required String profileId,
      required String fcmContent,
      required String iosContent,
      required String facebookContent,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profileId.value] = profileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          jsonDecode(facebookContent);
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Schedules raw notifications based on user local time.
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="fcmContent">
  /// Valid Fcm data content
  /// </param>
  /// <param name="iosContent">
  /// Valid ios data content
  /// </param>
  /// <param name="facebookContent">
  /// Facebook template String
  /// </param>
  /// <param name="minutesFromNow">
  /// Minutes from now to send the push notification
  /// </param>
  Future<ServerResponse> scheduleRawPushNotificationMinutes(
      {required String profileId,
      required String fcmContent,
      required String iosContent,
      required String facebookContent,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.profileId.value] = profileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          jsonDecode(facebookContent);
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a raw push notification to a target user.
  /// </param>
  /// <param name="toProfileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="fcmContent">
  /// Valid Fcm data content
  /// </param>
  /// <param name="iosContent">
  /// Valid ios data content
  /// </param>
  /// <param name="facebookContent">
  /// Facebook template String
  /// </param>
  Future<ServerResponse> sendRawPushNotification(
      {required String toProfileId,
      required String fcmContent,
      required String iosContent,
      required String facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.pushNotification, ServiceOperation.sendRaw, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a raw push notification to a target list of users.
  /// </param>
  /// <param name="profileIds">
  /// Collection of profile IDs to send the notification to
  /// </param>
  /// <param name="fcmContent">
  /// Valid Fcm data content
  /// </param>
  /// <param name="iosContent">
  /// Valid ios data content
  /// </param>
  /// <param name="facebookContent">
  /// Facebook template String
  /// </param>
  Future<ServerResponse> sendRawPushNotificationBatch(
      {required List<String> profileIds,
      required String fcmContent,
      required String iosContent,
      required String facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRawBatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a raw push notification to a target group.
  /// </param>
  /// <param name="groupId">
  /// Target group
  /// </param>
  /// <param name="fcmContent">
  /// Valid Fcm data content
  /// </param>
  /// <param name="iosContent">
  /// Valid ios data content
  /// </param>
  /// <param name="facebookContent">
  /// Facebook template String
  /// </param>
  Future<ServerResponse> sendRawPushNotificationToGroup(
      {required String groupId,
      required String fcmContent,
      required String iosContent,
      required String facebookContent}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.pushNotificationSendParamFcmContent.value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.pushNotificationSendParamIosContent.value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.pushNotificationSendParamFacebookContent.value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRawToGroup, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Schedules a normalized push notification to a user
  ///
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="alertContentJson">
  /// Body and title of alert
  /// </param>
  /// <param name="customDataJson">
  /// Optional custom data
  /// </param>
  /// <param name="startTimeUTC">
  /// Start time of sending the push notification
  /// </param>
  Future<ServerResponse> scheduleNormalizedPushNotificationUTC(
      {required String profileId,
      required String alertContentJson,
      String? customDataJson,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson!);
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Schedules a normalized push notification to a user
  ///
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="alertContentJson">
  /// Body and title of alert
  /// </param>
  /// <param name="customDataJson">
  /// Optional custom data
  /// </param>
  /// <param name="minutesFromNow">
  /// Minutes from now to send the push notification
  /// </param>
  Future<ServerResponse> scheduleNormalizedPushNotificationMinutes(
      {required String profileId,
      required String alertContentJson,
      String? customDataJson,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson!);
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Schedules a rich push notification to a user
  ///
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="notificationTemplateId">
  /// Body and title of alert
  /// </param>
  /// <param name="substitutionsJson">
  /// Optional custom data
  /// </param>
  /// <param name="startTimeUTC">
  /// Start time of sending the push notification
  /// </param>
  Future<ServerResponse> scheduleRichPushNotificationUTC(
      {required String profileId,
      required int notificationTemplateId,
      required String substitutionsJson,
      required int startTimeUTC}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          jsonDecode(substitutionsJson);
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Schedules a rich push notification to a user
  ///
  /// </param>
  /// <param name="profileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="notificationTemplateId">
  /// Body and title of alert
  /// </param>
  /// <param name="substitutionsJson">
  /// Optional custom data
  /// </param>
  /// <param name="minutesFromNow">
  /// Minutes from now to send the push notification
  /// </param>
  Future<ServerResponse> scheduleRichPushNotificationMinutes(
      {required String profileId,
      required int notificationTemplateId,
      required String substitutionsJson,
      required int minutesFromNow}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          jsonDecode(substitutionsJson);
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a notification to a user consisting of alert content and custom data.
  /// </param>
  /// <param name="toProfileId">
  /// The profileId of the user to receive the notification
  /// </param>
  /// <param name="alertContentJson">
  /// Body and title of alert
  /// </param>
  /// <param name="customDataJson">
  /// Optional custom data
  /// </param>
  Future<ServerResponse> sendNormalizedPushNotification(
      {required String toProfileId,
      required String alertContentJson,
      String? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson!);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalized, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Sends a notification to multiple users consisting of alert content and custom data.
  /// </param>
  /// <param name="profileIds">
  /// Collection of profile IDs to send the notification to
  /// </param>
  /// <param name="alertContentJson">
  /// Body and title of alert
  /// </param>
  /// <param name="customDataJson">
  /// Optional custom data
  /// </param>
  Future<ServerResponse> sendNormalizedPushNotificationBatch(
      {required List<String> profileIds,
      required String alertContentJson,
      String? customDataJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson!);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalizedBatch, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  Future<ServerResponse> sendRichPushNotification(
      {required String toProfileId,
      required int notificationTemplateId,
      required String substitutionJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionJson)) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          jsonDecode(substitutionJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.completeError(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRich, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
