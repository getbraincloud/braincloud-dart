import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Presence", () {
    test("forcePush()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.presenceService.forcePush();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPresenceOfFriends()", () async {
      ServerResponse response = await bcTest.bcWrapper.presenceService
          .getPresenceOfFriends(platform: "brainCloud", includeOffline: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getPresenceOfGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.presenceService
          .getPresenceOfGroup(groupId: "testPlatform", includeOffline: true);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getPresenceOfUsers()", () async {
      var testArray = ["aaa-bbb-ccc", "bbb-ccc-ddd"];

      ServerResponse response = await bcTest.bcWrapper.presenceService
          .getPresenceOfUsers(profileIds: testArray, includeOffline: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("registerListenersForFriends()", () async {
      ServerResponse response = await bcTest.bcWrapper.presenceService
          .registerListenersForFriends(
              platform: "brainCloud", bidirectional: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("registerListenersForGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.presenceService
          .registerListenersForGroup(
              groupId: "bad_group_id", bidirectional: true);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("registerListenersForProfiles()", () async {
      var testArray = ["aaa-bbb-ccc", "bbb-ccc-ddd"];

      ServerResponse response = await bcTest.bcWrapper.presenceService
          .registerListenersForProfiles(
              profileIds: testArray, bidirectional: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("setVisibility()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.presenceService.setVisibility(visible: true);

      if (response.statusCode != StatusCodes.badRequest) {
        print("-- Response is $response with data:\n${response.data}");
      }
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("stopListening()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.presenceService.stopListening();

      if (response.statusCode != StatusCodes.badRequest) {
        print("-- Response is $response with data:\n${response.data}");
      }
      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("updateActivity()", () async {
      ServerResponse response = await bcTest.bcWrapper.presenceService
          .updateActivity(activity: {"status": "waiting"});

      if (response.statusCode != StatusCodes.badRequest) {
        print("-- Response is $response with data:\n${response.data}");
      }
      expect(response.statusCode, StatusCodes.badRequest);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
