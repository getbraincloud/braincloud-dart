import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Push Notifications", () {
    test("deregisterAllPushNotificationDeviceTokens()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .deregisterAllPushNotificationDeviceTokens();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("registerPushNotificationDeviceToken()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .registerPushNotificationDeviceToken(
              platform: Platform.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deregisterPushNotificationDeviceToken()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .deregisterPushNotificationDeviceToken(
              platform: Platform.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendSimplePushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendSimplePushNotification(
              toProfileId: userA.profileId!, message: "Test message.");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRichPushNotification(
              toProfileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutionJson: "");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotificationWithParams()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRichPushNotificationWithParams(
              toProfileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutionJson: jsonEncode({"1": userA.name}));
      expect(response.statusCode, StatusCodes.ok);
    });

    String groupId = "";

    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          jsonData: jsonEncode({"test": "asdf"}));

      expect(response.statusCode, StatusCodes.ok);
      groupId = response.body?["data"]["groupId"];
    });

    test("sendTemplatedPushNotificationToGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendTemplatedPushNotificationToGroup(
              groupId: groupId,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationToGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationToGroup(
        groupId: groupId,
        alertContentJson: jsonEncode(
            {"body": "content of message", "title": "message title"}),
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationUTC()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationUTC(
              profileId: userA.profileId!,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}),
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationMinutes()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationMinutes(
              profileId: userA.profileId!,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}),
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationUTC()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRichPushNotificationUTC(
              profileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}),
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationMinutes()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRichPushNotificationMinutes(
              profileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutionsJson: jsonEncode({"1": userA.name}),
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.deleteGroup(
        groupId: groupId,
        version: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotification(
              toProfileId: userB.profileId!,
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationBatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationBatch(
              profileIds: [userA.profileId!, userB.profileId!],
              alertContentJson: jsonEncode(
                  {"body": "content of message", "title": "message title"}));

      expect(response.statusCode, StatusCodes.ok);
    });
  });

  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
