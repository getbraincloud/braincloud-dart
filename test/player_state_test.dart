import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Player State", () {
    test("updateName()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateName(userName: "junit");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readUserState()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStateService.readUserState();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateAttributes()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateAttributes(
              jsonAttributes: {"att1": "123", "att2": "blue"},
              wipeExisting: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getAttributes()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStateService.getAttributes();

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
      expect(response.data?["attributes"]["att2"], "blue",
          reason: "Attribute comparison");
    });

    test("removeAttributes()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .removeAttributes(attributeNames: ["att1", "att2"]);
      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("updateSummaryFriendData()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateSummaryFriendData(jsonSummaryData: {"field": "value"});

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("updateUserPictureUrl()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateUserPictureUrl(
              pictureUrl: "https://some.domain.com/mypicture.jpg");
      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("updateContactEmail()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateContactEmail(contactEmail: "something@test.getbraincloud.com");
      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("resetUser()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStateService.resetUser();

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("clearUserStatus()", () async {
      await bcTest.auth();
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .clearUserStatus(statusName: "a_Status_Name");

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("extendUserStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .extendUserStatus(
              statusName: "a_Status_Name", additionalSecs: 1000, details: {});

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("getUserStatus()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStateService.getUserStatus(
        statusName: "a_Status_Name",
      );
      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("setUserStatus()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .setUserStatus(
              statusName: "a_Status_Name", durationSecs: 60, details: {});

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("updateTimeZoneOffset()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.playerStateService.updateTimeZoneOffset(
        timeZoneOffset: "1",
      );

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    test("updateLanguageCode()", () async {
      ServerResponse response = await bcTest.bcWrapper.playerStateService
          .updateLanguageCode(languageCode: "fr");

      expect(response.statusCode, StatusCodes.ok, reason: "${response.data}");
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
