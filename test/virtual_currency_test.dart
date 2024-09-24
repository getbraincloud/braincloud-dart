import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Virtual Currency", () {
    setUp(bcTest.auth);

    test("getCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getCurrency(currencyType: "_invalid_id_");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getParentCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getParentCurrency(
              currencyType: "_invalid_id_", levelName: "_invalid_level_")
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.missingPlayerParent);
    });

    test("getPeerCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getPeerCurrency(
              currencyType: "_invalid_id_", peerCode: "_invalid_peer_code_")
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.profilePeerNotFound);
    });

    test("resetCurrency()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.virtualCurrencyService.resetCurrency();

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
