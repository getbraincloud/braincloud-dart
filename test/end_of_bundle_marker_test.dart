import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Message Bundle Marker", () {
    test("InsertEndOfMessageBundleMarker", () async {
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();

      ServerResponse response =
          await bcTest.bcWrapper.playerStatisticsService.readAllUserStats();

      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();

      // to make sure it doesn't die on first message being marker
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();

      response =
          await bcTest.bcWrapper.playerStatisticsService.readAllUserStats();

      debugPrint("Resonse: $response");
      response =
          await bcTest.bcWrapper.playerStatisticsService.readAllUserStats();

      debugPrint("Resonse: $response");
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
