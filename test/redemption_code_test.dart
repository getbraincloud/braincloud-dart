import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  var _lastCodeUsedStatName = "lastCodeUsed";
  var _codeType = "default";
  var _codeToRedeem = "";

  group("Test Redemptionm Code", () {
    setUp(bcTest.auth);

    test("getCodeToRedeem()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(
              jsonData: jsonEncode({_lastCodeUsedStatName: "+1"}));

      expect(response.statusCode, StatusCodes.ok);

      _codeToRedeem =
          response.body!["data"]["statistics"]["lastCodeUsed"].toString();
    });

    test("redeemCode()", () async {
      ServerResponse response = await bcTest.bcWrapper.globalStatisticsService
          .incrementGlobalStats(
              jsonData: jsonEncode({_lastCodeUsedStatName: "+1"}));

      expect(response.statusCode, StatusCodes.ok);

      _codeToRedeem =
          response.body!["data"]["statistics"]["lastCodeUsed"].toString();
      ;

      ServerResponse response2 = await bcTest.bcWrapper.redemptionCodeService
          .redeemCode(
              scanCode: _codeToRedeem,
              codeType: _codeType,
              jsonCustomRedemptionInfo: "{}");
      expect(response2.statusCode, StatusCodes.ok);
    });

    test("getRedeemedCodes()", () async {
      ServerResponse response = await bcTest.bcWrapper.redemptionCodeService
          .getRedeemedCodes(codeType: _codeType);

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
