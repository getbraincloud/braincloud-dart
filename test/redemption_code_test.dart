import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  var _lastCodeUsedStatName = "lastCodeUsed";
  var _codeType = "default";
  var _codeToRedeem = "";

  group("Test Redemptionm Code", () {
    test("getCodeToRedeem()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(statistics: {_lastCodeUsedStatName: "+1"});

      expect(response.statusCode, StatusCodes.ok);

      _codeToRedeem = response.data!["statistics"]["lastCodeUsed"].toString();
    });

    test("redeemCode()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(statistics: {_lastCodeUsedStatName: "+1"});

      expect(response.statusCode, StatusCodes.ok);

      _codeToRedeem = response.data!["statistics"]["lastCodeUsed"].toString();
      ;

      ServerResponse response2 = await bcTest.bcWrapper.redemptionCodeService
          .redeemCode(
              scanCode: _codeToRedeem,
              codeType: _codeType,
              customRedemptionInfo: {});
      expect(response2.statusCode, StatusCodes.ok);
    });

    test("getRedeemedCodes()", () async {
      ServerResponse response = await bcTest.bcWrapper.redemptionCodeService
          .getRedeemedCodes(codeType: _codeType);

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
