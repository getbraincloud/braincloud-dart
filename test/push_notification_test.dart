import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

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
              platform: PlatformID.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deregisterPushNotificationDeviceToken()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .deregisterPushNotificationDeviceToken(
              platform: PlatformID.iOS, token: "GARBAGE_TOKEN");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendSimplePushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendSimplePushNotification(
              profileId: userA.profileId!, message: "Test message.");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRichPushNotification(
              profileId: userA.profileId!, notificationTemplateId: 1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRichPushNotificationWithParams()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRichPushNotificationWithParams(
              profileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutions: {"1": userA.name});
      expect(response.statusCode, StatusCodes.ok);
    });

    String groupId = "";

    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          data: {"test": "asdf"});

      expect(response.statusCode, StatusCodes.ok);
      groupId = response.data?["groupId"];
    });

    test("sendTemplatedPushNotificationToGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendTemplatedPushNotificationToGroup(
              groupId: groupId,
              notificationTemplateId: 1,
              substitutionsJson: {"1": userA.name});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationToGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationToGroup(
              groupId: groupId,
              alertContent: {
            "body": "content of message",
            "title": "message title"
          });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationUTC()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationUTC(
              profileId: userA.profileId!,
              alertContent: {
                "body": "content of message",
                "title": "message title"
              },
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleNormalizedPushNotificationMinutes()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleNormalizedPushNotificationMinutes(
              profileId: userA.profileId!,
              alertContent: {
                "body": "content of message",
                "title": "message title"
              },
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationUTC()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRichPushNotificationUTC(
              profileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutions: {"1": userA.name},
              startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRichPushNotificationMinutes()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRichPushNotificationMinutes(
              profileId: userA.profileId!,
              notificationTemplateId: 1,
              substitutions: {"1": userA.name},
              minutesFromNow: 42);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotification(
              profileId: userB.profileId!,
              alertContent: {
            "body": "content of message",
            "title": "message title"
          });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendNormalizedPushNotificationBatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendNormalizedPushNotificationBatch(profileIds: [
        userA.profileId!,
        userB.profileId!
      ], alertContent: {
        "body": "content of message",
        "title": "message title"
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRawPushNotificationUTC()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRawPushNotificationUTC(
              profileId: userA.profileId!, startTimeUTC: 0);

      expect(response.statusCode, StatusCodes.ok);

      response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRawPushNotificationUTC(
              profileId: userA.profileId!,
              startTimeUTC: 0,
              facebookContent: {"title": "test"},
              fcmContent: {"title": "test"},
              iosContent: {"title": "test"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("scheduleRawPushNotificationMinutes()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRawPushNotificationMinutes(
              profileId: userA.profileId!, minutesFromNow: 0);

      expect(response.statusCode, StatusCodes.ok);

      response = await bcTest.bcWrapper.pushNotificationService
          .scheduleRawPushNotificationMinutes(
              profileId: userA.profileId!,
              minutesFromNow: 0,
              facebookContent: {"title": "test"},
              fcmContent: {"title": "test"},
              iosContent: {"title": "test"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRawPushNotification()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRawPushNotification(
              profileId: userA.profileId!, iosContent: {"a": "b"});

      expect(response.statusCode, StatusCodes.ok);

      response = await bcTest.bcWrapper.pushNotificationService
          .sendRawPushNotification(
              profileId: userA.profileId!,
              iosContent: {"a": "b"},
              facebookContent: {"a": "b"},
              fcmContent: {"a": "b"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRawPushNotificationBatch()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRawPushNotificationBatch(profileIds: [
        userA.profileId!,
        userB.profileId!,
        userC.profileId!
      ], iosContent: {
        "a": "b"
      });

      expect(response.statusCode, StatusCodes.ok);

      response = await bcTest.bcWrapper.pushNotificationService
          .sendRawPushNotificationBatch(profileIds: [
        userA.profileId!,
        userB.profileId!,
        userC.profileId!
      ], iosContent: {
        "a": "b"
      }, facebookContent: {
        "a": "b"
      }, fcmContent: {
        "a": "b"
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendRawPushNotificationToGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.pushNotificationService
          .sendRawPushNotificationToGroup(
              groupId: groupId, iosContent: {"a": "b"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.deleteGroup(
        groupId: groupId,
        version: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });
  });

  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
