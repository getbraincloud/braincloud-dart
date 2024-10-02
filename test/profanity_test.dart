import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Profanity", () {
    test("profanityCheck()", () async {
      ServerResponse response = await bcTest.bcWrapper.profanityService
          .profanityCheck(
              text: "shitbird fly away",
              languages: "en",
              flagEmail: true,
              flagPhone: true,
              flagUrls: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("profanityReplaceText()", () async {
      ServerResponse response = await bcTest.bcWrapper.profanityService
          .profanityReplaceText(
              text: "shitbird fly away",
              replaceSymbol: "*",
              languages: "en",
              flagEmail: false,
              flagPhone: false,
              flagUrls: false);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("profanityIdentifyBadWords()", () async {
      ServerResponse response = await bcTest.bcWrapper.profanityService
          .profanityIdentifyBadWords(
              text: "shitbird fly away",
              languages: "en,fr",
              flagEmail: true,
              flagPhone: false,
              flagUrls: false);

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDown(() {
      bcTest.dispose();
    });
  });
}
