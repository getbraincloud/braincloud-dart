import 'dart:convert';
import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';
import 'utils/test_users.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Event", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));

    setUp(() async {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.logout();
      }

      ServerResponse userB_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userB.name,
              password: userB.password,
              forceCreate: true);

      userB.profileId = userB_response.body?["profileId"];

      ServerResponse userA_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userA.name,
              password: userA.password,
              forceCreate: true);

      userA.profileId = userA_response.body?["profileId"];
    });

    var eventType = "test";
    var eventDataKey = "testData";

    var eventId;

    test("updateIncomingEventDataIfExistsFalse()", () async {
      var nonExistentEventId = "999999999999999999999999";

      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventDataIfExists(
              evId: nonExistentEventId,
              jsonEventData: jsonEncode({eventDataKey: 118}))
          .onError((error, stackTrace) => error as ServerResponse);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendEvent()", () async {
      var sendEventSemi = 0;
      bcTest.bcWrapper.brainCloudClient.registerEventCallback((response) {
        ++sendEventSemi;
        if (sendEventSemi == 2) {
          expect(sendEventSemi, 2);
          bcTest.bcWrapper.brainCloudClient.deregisterEventCallback();
        }
      });

      ServerResponse response = await bcTest.bcWrapper.eventService.sendEvent(
          toProfileId: userA.profileId!,
          eventType: eventType,
          jsonEventData: jsonEncode({eventDataKey: 24}));

      response = await bcTest.bcWrapper.eventService.sendEvent(
          toProfileId: userA.profileId!,
          eventType: eventType,
          jsonEventData: jsonEncode({eventDataKey: 24}));

      expect(response.statusCode, StatusCodes.ok);
      eventId = response.body?["data"]["evId"];
    });

    test("updateIncomingEventData()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventData(
              evId: eventId, jsonEventData: jsonEncode({eventDataKey: 117}));
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateIncomingEventDataIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventDataIfExists(
              evId: eventId, jsonEventData: jsonEncode({eventDataKey: 118}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteIncomingEvent()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService
          .deleteIncomingEvent(evId: eventId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getEvents()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService.getEvents();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("sendEvent() to B", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService.sendEvent(
          toProfileId: userB.profileId!,
          eventType: eventType,
          jsonEventData: jsonEncode({eventDataKey: 24}));

      expect(response.statusCode, StatusCodes.ok);
      eventId = response.body?["data"]["evId"];
    });

    test("deleteIncomingEvents()", () async {
      List<String> evIds = [];
      ServerResponse response = await bcTest.bcWrapper.eventService
          .deleteIncomingEvents(inEventids: evIds);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteIncomingEventsByTypeOlderThan()", () async {
      var eventType = "my-event-type";
      var dateMillis = 1619804426154;
      ServerResponse response = await bcTest.bcWrapper.eventService
          .deleteIncomingEventsByTypeOlderThan(
              eventType: eventType, dateMillis: dateMillis);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteIncomingEventsOlderThan()", () async {
      var dateMillis = 1619804426154;
      ServerResponse response = await bcTest.bcWrapper.eventService
          .deleteIncomingEventsOlderThan(inDatemillis: dateMillis);
      expect(response.statusCode, StatusCodes.ok);
    });

    // B read event
    test("userB recv event()", () async {
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      expect(response.statusCode, StatusCodes.ok);

      List incoming_events = response.body?["incoming_events"];

      Map<String, dynamic> found = incoming_events.reduce((ret, event) {
        return ret ||
            (event.evId == eventId &&
                event.fromPlayerId == userA.profileId &&
                event.toPlayerId == userB.profileId);
      });

      expect(found.length, greaterThan(0));
    });

    /// END TEST
    tearDown(() {
      bcTest.dispose();
    });
  });
}
