import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Mail", () {
    setUpAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
    });

    test("updateContactEmail()", () async {
      await bcTest.bcWrapper.playerStateService.updateContactEmail(
        contactEmail: "braincloudunittest@test.getbraincloud.com",
      );
    });

    test("sendBasicEmail()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.mailService.sendBasicEmail(
        profileId: userA.profileId!,
        subject: "Test Subject - TestSendBasicEmail",
        body: "Test body content message.",
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendAdvancedEmail()", () async {
      ServerResponse response = await bcTest.bcWrapper.mailService
          .sendAdvancedEmail(profileId: userA.profileId!, jsonServiceParams: {
        "subject": "Test Subject - TestSendAdvancedEmailSendGrid",
        "body": "Test body content message.",
        "categories": ["unit-test"]
      });

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendAdvancedEmailByAddress()", () async {
      ServerResponse response = await bcTest.bcWrapper.mailService
          .sendAdvancedEmailByAddress(
              emailAddress: userA.email,
              jsonServiceParams: {
            "subject": "Test Subject - TestSendAdvancedEmailSendGrid",
            "body": "Test body content message.",
            "categories": ["unit-test"]
          });

      expect(response.statusCode, StatusCodes.ok);
    });
    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
    });
  });

  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
