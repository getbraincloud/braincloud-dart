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
  void registerPushNotificationDeviceToken(Platform platform, String token,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void deregisterAllPushNotificationDeviceTokens(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void deregisterPushNotificationDeviceToken(Platform platform, String token,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    String devicePlatform = platform.toString();
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationRegisterParamDeviceType.value] =
        devicePlatform;
    data[OperationParam.pushNotificationRegisterParamDeviceToken.value] = token;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendSimplePushNotification(String toProfileId, String message,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.pushNotificationSendParamMessage.value] = message;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendRichPushNotificationWithParams(
      String toProfileId,
      int notificationTemplateId,
      String substitutionJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    sendRichPushNotification(toProfileId, notificationTemplateId,
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
  void sendTemplatedPushNotificationToGroup(
      String groupId,
      int notificationTemplateId,
      String substitutionsJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.pushNotificationSendParamNotificationTemplateId.value] =
        notificationTemplateId;

    if (Util.isOptionalParameterValid(substitutionsJson)) {
      data[OperationParam.pushNotificationSendParamSubstitutions.value] =
          jsonDecode(substitutionsJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendNormalizedPushNotificationToGroup(
      String groupId,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleRawPushNotificationUTC(
      String profileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleRawPushNotificationMinutes(
      String profileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendRawPushNotification(
      String toProfileId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.pushNotification, ServiceOperation.sendRaw, data, callback);
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
  void sendRawPushNotificationBatch(
      List<String> profileIds,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendRawPushNotificationToGroup(
      String groupId,
      String fcmContent,
      String iosContent,
      String facebookContent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleNormalizedPushNotificationUTC(
      String profileId,
      String alertContentJson,
      String customDataJson,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson);
    }

    data[OperationParam.startDateUTC.value] = startTimeUTC.toUnsigned(64);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleNormalizedPushNotificationMinutes(
      String profileId,
      String alertContentJson,
      String customDataJson,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileId.value] = profileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);

    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson);
    }

    data[OperationParam.minutesFromNow.value] = minutesFromNow;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleRichPushNotificationUTC(
      String profileId,
      int notificationTemplateId,
      String substitutionsJson,
      BigInt startTimeUTC,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void scheduleRichPushNotificationMinutes(
      String profileId,
      int notificationTemplateId,
      String substitutionsJson,
      int minutesFromNow,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendNormalizedPushNotification(
      String toProfileId,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamToPlayerId.value] =
        toProfileId;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
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
  void sendNormalizedPushNotificationBatch(
      List<String> profileIds,
      String alertContentJson,
      String customDataJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.pushNotificationSendParamProfileIds.value] = profileIds;
    data[OperationParam.alertContent.value] = jsonDecode(alertContentJson);
    if (Util.isOptionalParameterValid(customDataJson)) {
      data[OperationParam.customData.value] = jsonDecode(customDataJson);
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendNormalizedBatch, data, callback);
    _clientRef.sendRequest(sc);
  }

  void sendRichPushNotification(
      String toProfileId,
      int notificationTemplateId,
      String substitutionJson,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
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
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.pushNotification,
        ServiceOperation.sendRich, data, callback);
    _clientRef.sendRequest(sc);
  }
}
