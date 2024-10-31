import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Message Bundle Marker", () {
    test("InsertEndOfMessageBundleMarker", () async {
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();

      // Queue up 3 request with a forced bundle marker in between
      var pkt1 = bcTest.bcWrapper.brainCloudClient.getReceivedPacketId();
      var request1 = bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();
      var request2 =  bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      var request3 =  bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      
      // Now wait for them to complete, dont really care about the results so dont capture it.
      await request1;
      await request2;
      await request3;

      // check that this only generated 2 distinct packets.
      var pkt2 = bcTest.bcWrapper.brainCloudClient.getReceivedPacketId();
      expect(pkt2 - pkt1, 2, reason:"There should be 2 packets used.");
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
