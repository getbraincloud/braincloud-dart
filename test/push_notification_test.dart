import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/src/common/platform.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stored_ids.dart';
import 'test_users.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });

  group("Test Push Notifications", () {
    TestUser userA = TestUser("userA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));

    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        ServerResponse userA_response = await bcWrapper.authenticateUniversal(
            username: userA.name, password: userA.password, forceCreate: true);

        userA.profileId = userA_response.body?["profileId"];

        ServerResponse userB_response = await bcWrapper.authenticateUniversal(
            username: userB.name, password: userB.password, forceCreate: true);

        userB.profileId = userB_response.body?["profileId"];
      }
    });

    test("deregisterAllPushNotificationDeviceTokens()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .deregisterAllPushNotificationDeviceTokens();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("registerPushNotificationDeviceToken()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .registerPushNotificationDeviceToken(
              platform: Platform.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deregisterPushNotificationDeviceToken()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .deregisterPushNotificationDeviceToken(
              platform: Platform.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendSimplePushNotification()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendSimplePushNotification(
              toProfileId: userA.profileId as String, message: "Test message.");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotification()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendRichPushNotification(
              toProfileId: userA.profileId as String,
              notificationTemplateId: 1,
              substitutionJson: "");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotificationWithParams()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendRichPushNotificationWithParams(
              toProfileId: userA.profileId as String,
              notificationTemplateId: 1,
              substitutionJson: jsonEncode({"1": userA.name}));
      expect(response.statusCode, StatusCodes.ok);
    });

    String groupId = "";

    test("createGroup()", () async {
      ServerResponse response = await bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          jsonData: jsonEncode({"test": "asdf"}));

      expect(response.statusCode, StatusCodes.ok);
      groupId = response.body?["data"]["groupId"];
    });

    test("sendTemplatedPushNotificationToGroup()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendTemplatedPushNotificationToGroup(
              groupId: groupId,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationToGroup()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationToGroup(
        groupId: groupId,
        alertContentJson: jsonEncode(
            {"body": "content of message", "title": "message title"}),
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationUTC()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationUTC(
              profileId: userA.profileId as String,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}),
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationMinutes()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationMinutes(
              profileId: userA.profileId as String,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}),
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationUTC()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .scheduleRichPushNotificationUTC(
              profileId: userA.profileId as String,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}),
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationMinutes()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .scheduleRichPushNotificationMinutes(
              profileId: userA.profileId as String,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}),
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcWrapper.groupService.deleteGroup(
        groupId: groupId,
        version: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotification()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendNormalizedPushNotification(
              toProfileId: userB.profileId as String,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationBatch()", () async {
      ServerResponse response = await bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationBatch(
              profileIds: [
            userA.profileId as String,
            userB.profileId as String
          ],
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}));

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
