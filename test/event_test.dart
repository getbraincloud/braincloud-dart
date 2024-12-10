import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Event", () {
    var eventType = "test";
    var eventDataKey = "testData";

    var eventId;

    test("updateIncomingEventDataIfExistsFalse()", () async {
      var nonExistentEventId = "999999999999999999999999";

      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventDataIfExists(
              evId: nonExistentEventId, jsonEventData: {eventDataKey: 118});

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
          jsonEventData: {eventDataKey: 24});

      response = await bcTest.bcWrapper.eventService.sendEvent(
          toProfileId: userA.profileId!,
          eventType: eventType,
          jsonEventData: {eventDataKey: 24});

      expect(response.statusCode, StatusCodes.ok);
      eventId = response.data?["evId"];
    });

    test("updateIncomingEventData()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventData(
              evId: eventId, jsonEventData: {eventDataKey: 117});
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateIncomingEventDataIfExistsTrue()", () async {
      ServerResponse response = await bcTest.bcWrapper.eventService
          .updateIncomingEventDataIfExists(
              evId: eventId, jsonEventData: {eventDataKey: 118});

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
          jsonEventData: {eventDataKey: 24});

      expect(response.statusCode, StatusCodes.ok);
      eventId = response.data?["evId"];
    });

    test("deleteIncomingEvents()", () async {
      List<String> evIds = [];
      ServerResponse response = await bcTest.bcWrapper.eventService
          .deleteIncomingEvents(evIds: evIds);
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
          .deleteIncomingEventsOlderThan(dateMillis: dateMillis);
      expect(response.statusCode, StatusCodes.ok);
    });

    // B read event
    test("userB recv event()", () async {
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      expect(response.statusCode, StatusCodes.ok);

      List incoming_events = [];

      if (response.data?["incoming_events"] is List) {
        incoming_events = response.data?["incoming_events"];
      }

      print(
          "Found (${incoming_events.length}) Events: ${incoming_events}");

      var foundEvent;
      for (var event in incoming_events) {
        if (event["evId"] == eventId) {
          foundEvent = event;
        }
      }

      expect(incoming_events.length, greaterThan(0),
          reason: "incoming_events should have more than 1");
      expect(foundEvent["evId"], eventId,
          reason: "eventId should equal foundEvent['evId']");
      expect(foundEvent["fromPlayerId"], userA.profileId,
          reason: "userA.profileId should equal ['fromPlayerId'] ");
      expect(foundEvent["toPlayerId"], userB.profileId,
          reason: "userB.profileId should equal ['toPlayerId'] ");
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
