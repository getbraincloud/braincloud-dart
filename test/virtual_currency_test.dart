import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Virtual Currency", () {


    test("awardCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .awardCurrency(vcId: "test",vcAmount: 23);
print("awardCurrency(): $response");
      expect(response.statusCode, StatusCodes.ok);
    });

    test("consumeCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .consumeCurrency(vcId: "test",vcAmount: 5);
print("consumeCurrency(): $response");
      expect(response.statusCode, StatusCodes.ok);
    });
    
    test("getCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getCurrency(vcId: "_invalid_id_");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getParentCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getParentCurrency(
              vcId: "_invalid_id_", levelName: "_invalid_level_");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.missingPlayerParent);
    });

    test("getPeerCurrency()", () async {
      ServerResponse response = await bcTest.bcWrapper.virtualCurrencyService
          .getPeerCurrency(
              vcId: "_invalid_id_", peerCode: "_invalid_peer_code_");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.profilePeerNotFound);
    });

    test("resetCurrency()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.virtualCurrencyService.resetCurrency();

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
