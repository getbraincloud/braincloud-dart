import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Blockchain", () {
    var _defaultIntegrationId = "default";
    Map<String, dynamic> _defaultContextJson = {};

    test("getBlockchainItems()", () {
      bcTest.bcWrapper.blockchainService.getBlockchainItems(
          integrationid: _defaultIntegrationId,
          contextJson: _defaultContextJson);
    });

    test("getUniqs()", () {
      bcTest.bcWrapper.blockchainService.getUniqs(
          inIntegrationid: _defaultIntegrationId,
          contextJson: _defaultContextJson);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
