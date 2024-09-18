import 'dart:convert';
import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Player Statistics Event", () {
    setUp(bcTest.auth);

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
          .triggerUserStatsEvents(
              jsonData: jsonEncode([
        {"eventName": eventId1, "eventMultiplier": 10},
        {"eventName": eventId2, "eventMultiplier": 10}
      ]));

      expect(response.statusCode, StatusCodes.ok);
    });

    var rewardCallbackCount = 0;

    test("rewardHandlerTriggerStatisticsEvents()", retry: 3, () async {
      await bcTest.bcWrapper.playerStateService.resetUser();

      bcTest.bcWrapper.brainCloudClient.registerRewardCallback((rewardsJson) {
        ++rewardCallbackCount;
        bcTest.bcWrapper.brainCloudClient.deregisterRewardCallback();
      });

      await bcTest.bcWrapper.playerStatisticsEventService
          .triggerUserStatsEvents(
              jsonData: jsonEncode([
        {"eventName": "incQuest1Stat", "eventMultiplier": 1},
        {"eventName": "incQuest2Stat", "eventMultiplier": 1}
      ]));

      debugPrint("rewardCallbackCount: $rewardCallbackCount");
      expect(rewardCallbackCount, 3);
    });
  });
}
