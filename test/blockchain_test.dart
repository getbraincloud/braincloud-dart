import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Blockchain", () {
    var _defaultIntegrationId = "default";
    Map<String, dynamic> _defaultContextJson = {};

    test("getBlockchainItems()", () async {
      ServerResponse response = await bcTest.bcWrapper.blockchainService
          .getBlockchainItems(
              integrationid: _defaultIntegrationId,
              contextJson: _defaultContextJson);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getUniqs()", () async {
      ServerResponse response = await bcTest.bcWrapper.blockchainService
          .getUniqs(
              inIntegrationid: _defaultIntegrationId,
              contextJson: _defaultContextJson);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
