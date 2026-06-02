// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Campaign", () {
    test("getMyCampaigns()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.campaignService.getMyCampaigns();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getMyCampaigns() with options", () async {
      ServerResponse response = await bcTest.bcWrapper.campaignService
          .getMyCampaigns(optionsJson: {});
      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
