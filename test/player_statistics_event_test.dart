import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Player Statistics Event", () {
    var eventId1 = "testEvent01";
    var eventId2 = "rewardCredits";

    test("triggerUserStatsEvent()", () async {
      ServerResponse response = await bcTest
          .bcWrapper.playerStatisticsEventService
          .triggerUserStatsEvent(eventName: eventId1, eventMultiplier: 10);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("triggerUserStatsEvents()", () async {
      ServerResponse response = await bcTest
          .bcWrapper.playerStatisticsEventService
          .triggerUserStatsEvents(jsonData: [
        {"eventName": eventId1, "eventMultiplier": 10},
        {"eventName": eventId2, "eventMultiplier": 10}
      ]);

      expect(response.statusCode, StatusCodes.ok);
    });

    var rewardCallbackCount = 0;

    registerCallback() async {
      final Completer completer = Completer();
      bcTest.bcWrapper.brainCloudClient.registerRewardCallback((rewardsJson) {
        ++rewardCallbackCount;
        completer.complete();
        bcTest.bcWrapper.brainCloudClient.deregisterRewardCallback();
      });
      return completer.future;
    }

    test("rewardHandlerTriggerStatisticsEvents()", timeout: Timeout.parse("5s"),
        () async {
      Future? callBackCompleter; //
      if (rewardCallbackCount == 0) {
        callBackCompleter = registerCallback();
      }

      await bcTest.bcWrapper.playerStateService.resetUser();
      await bcTest
          .auth(); // resetUser will log you out so this so need to re-authenticate

      await bcTest.bcWrapper.playerStatisticsEventService
          .triggerUserStatsEvents(jsonData: [
        {"eventName": "incQuest1Stat", "eventMultiplier": 1},
        {"eventName": "incQuest2Stat", "eventMultiplier": 1}
      ]);

      if (callBackCompleter != null) await callBackCompleter;
      expect(rewardCallbackCount, 1);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
