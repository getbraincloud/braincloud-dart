import 'dart:convert';

import 'package:braincloud_dart/src/Common/platform.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void RegisterPushNotificationDeviceToken(Platform platform, String token,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationRegisterParamDeviceType.Value] =
        devicePlatform;
    data[OperationParam.PushNotificationRegisterParamDeviceToken.Value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.register, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Deregisters all device tokens currently registered to the user.
  /// </param>
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void DeregisterAllPushNotificationDeviceTokens(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.deregisterAll, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void DeregisterPushNotificationDeviceToken(Platform platform, String token,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationRegisterParamDeviceType.Value] =
        devicePlatform;
    data[OperationParam.PushNotificationRegisterParamDeviceToken.Value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.deregister, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendSimplePushNotification(String toProfileId, String message,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamToPlayerId.Value] =
        toProfileId;
    data[OperationParam.PushNotificationSendParamMessage.Value] = message;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendSimple, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendRichPushNotificationWithParams(
      String toProfileId,
      int notificationTemplateId,
      String substitutionJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    SendRichPushNotification(toProfileId, notificationTemplateId,
        substitutionJson, success, failure, cbObject);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendTemplatedPushNotificationToGroup(
      String groupId,
      int notificationTemplateId,
      String substitutionsJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.PushNotificationSendParamNotificationTemplateId.Value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.PushNotificationSendParamSubstitutions.Value] =
          jsonDecode(substitutionsJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendTemplatedToGroup, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendNormalizedPushNotificationToGroup(
      String groupId,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.AlertContent.Value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.CustomData.Value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendNormalizedToGroup, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleRawPushNotificationUTC(
      String profileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.ProfileId.Value] = profileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.PushNotificationSendParamFcmContent.Value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.PushNotificationSendParamIosContent.Value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.PushNotificationSendParamFacebookContent.Value] =
          jsonDecode(facebookContent);
    }

    data[OperationParam.StartDateUTC.Value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleRawPushNotificationMinutes(
      String profileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.ProfileId.Value] = profileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.PushNotificationSendParamFcmContent.Value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.PushNotificationSendParamIosContent.Value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.PushNotificationSendParamFacebookContent.Value] =
          jsonDecode(facebookContent);
    }

    data[OperationParam.MinutesFromNow.Value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleRawNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendRawPushNotification(
      String toProfileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamToPlayerId.Value] =
        toProfileId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.PushNotificationSendParamFcmContent.Value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.PushNotificationSendParamIosContent.Value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.PushNotificationSendParamFacebookContent.Value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.PushNotification, ServiceOperation.sendRaw, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendRawPushNotificationBatch(
      List<String> profileIds,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.PushNotificationSendParamProfileIds.Value] = profileIds;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.PushNotificationSendParamFcmContent.Value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.PushNotificationSendParamIosContent.Value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.PushNotificationSendParamFacebookContent.Value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendRawBatch, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendRawPushNotificationToGroup(
      String groupId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;

    if (Util.isOptionalParameterValid(fcmContent)) {
      data[OperationParam.PushNotificationSendParamFcmContent.Value] =
          jsonDecode(fcmContent);
    }

    if (Util.isOptionalParameterValid(iosContent)) {
      data[OperationParam.PushNotificationSendParamIosContent.Value] =
          jsonDecode(iosContent);
    }

    if (Util.isOptionalParameterValid(facebookContent)) {
      data[OperationParam.PushNotificationSendParamFacebookContent.Value] =
          jsonDecode(facebookContent);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendRawToGroup, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleNormalizedPushNotificationUTC(
      String profileId,
      String alertContentJson,
      String customDataJson,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamProfileId.Value] = profileId;
    data[OperationParam.AlertContent.Value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.CustomData.Value] = jsonDecode(customDataJson);
    }

    data[OperationParam.StartDateUTC.Value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleNormalizedPushNotificationMinutes(
      String profileId,
      String alertContentJson,
      String customDataJson,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamProfileId.Value] = profileId;
    data[OperationParam.AlertContent.Value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.CustomData.Value] = jsonDecode(customDataJson);
    }

    data[OperationParam.MinutesFromNow.Value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleNormalizedNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleRichPushNotificationUTC(
      String profileId,
      int notificationTemplateId,
      String substitutionsJson,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamProfileId.Value] = profileId;
    data[OperationParam.PushNotificationSendParamNotificationTemplateId.Value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.PushNotificationSendParamSubstitutions.Value] =
          jsonDecode(substitutionsJson);
    }

    data[OperationParam.StartDateUTC.Value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void ScheduleRichPushNotificationMinutes(
      String profileId,
      int notificationTemplateId,
      String substitutionsJson,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamProfileId.Value] = profileId;
    data[OperationParam.PushNotificationSendParamNotificationTemplateId.Value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.PushNotificationSendParamSubstitutions.Value] =
          jsonDecode(substitutionsJson);
    }

    data[OperationParam.MinutesFromNow.Value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.scheduleRichNotification, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendNormalizedPushNotification(
      String toProfileId,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamToPlayerId.Value] =
        toProfileId;
    data[OperationParam.AlertContent.Value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.CustomData.Value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendNormalized, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback
  /// </param>
  /// <param name="failure">
  /// The failure callback
  /// </param>
  /// <param name="cbObject">
  /// The callback object
  /// </param>
  void SendNormalizedPushNotificationBatch(
      List<String> profileIds,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamProfileIds.Value] = profileIds;
    data[OperationParam.AlertContent.Value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.CustomData.Value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendNormalizedBatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  void SendRichPushNotification(
      String toProfileId,
      int notificationTemplateId,
      String substitutionJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.PushNotificationSendParamToPlayerId.Value] =
        toProfileId;
    data[OperationParam.PushNotificationSendParamNotificationTemplateId.Value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionJson)) {
      data[OperationParam.PushNotificationSendParamSubstitutions.Value] =
          jsonDecode(substitutionJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.PushNotification,
        ServiceOperation.sendRich, data, callback);
    _clientRef.sendRequest(sc);
  }
}
