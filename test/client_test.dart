import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  // setUpAll(bcTest.setupBC);

  group("Test Client", () {
    setUpAll(() async {
      await bcTest.setupBC();
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
    });

    test("Client Setters/Getters", () async {
      bcTest.bcWrapper.brainCloudClient.overrideCountryCode('US');
      bcTest.bcWrapper.brainCloudClient.overrideLanguageCode('FR');
      bcTest.bcWrapper.brainCloudClient.setUploadLowTransferRateThreshold(123);
      expect(
          bcTest.bcWrapper.brainCloudClient.getUploadLowTransferRateThreshold(),
          123);
      bcTest.bcWrapper.brainCloudClient.setAuthenticationPacketTimeout(456);
      expect(bcTest.bcWrapper.brainCloudClient.getAuthenticationPacketTimeout(),
          456);

      var pktTimeouts = bcTest.bcWrapper.brainCloudClient.getPacketTimeouts();
      bcTest.bcWrapper.brainCloudClient.setPacketTimeouts([21, 31, 41]);
      expect(
          bcTest.bcWrapper.brainCloudClient.getPacketTimeouts(), [21, 31, 41]);
      bcTest.bcWrapper.brainCloudClient.setPacketTimeoutsToDefault();
      expect(
          bcTest.bcWrapper.brainCloudClient.getPacketTimeouts(), pktTimeouts);

      expect(bcTest.bcWrapper.brainCloudClient.getUrl(), bcTest.ids.url);
      expect(bcTest.bcWrapper.brainCloudClient.getAppId(), bcTest.ids.appId);

      bcTest.bcWrapper.brainCloudClient.enableCompressedRequests = true;
      bcTest.bcWrapper.brainCloudClient.enableCompressedResponses = true;

      expect(bcTest.bcWrapper.brainCloudClient.getSessionId(), isA<String>());

      ServerResponse response =
          await bcTest.bcWrapper.brainCloudClient.sendHeartbeat();

      expect(response.statusCode, StatusCodes.ok);

      // bcTest.bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);
      bcTest.bcWrapper.brainCloudClient.flushCachedMessages(false);
      bcTest.bcWrapper.brainCloudClient.retryCachedMessages();

      bcTest.bcWrapper.brainCloudClient.log("log");
    });

    test("registerGlobalErrorCallback", () async {
      final Completer completer = Completer();

      int callbackCount = 0;

      bcTest.bcWrapper.brainCloudClient.registerGlobalErrorCallback(
          (service, operation, status, reason, message) {
        if (callbackCount == 0) {
          expect(service, isEmpty);
          expect(operation, isEmpty);
          expect(status, 500);
          expect(reason, 50000);
          expect(message,
              '{"reason_code":50000,"status":500,"status_message":"TestMessage","severity":"ERROR"}');
        }
        if (callbackCount == 1) {
          expect(service, "entity");
          expect(operation, "UPDATE");
          expect(status, 404);
          expect(reason, ReasonCodes.updateFailed);
        }
        callbackCount++;
        if (callbackCount > 1) completer.complete();
      });

      bcTest.bcWrapper.brainCloudClient.comms
          .triggerCommsError(500, 50000, "TestMessage");
      bcTest.bcWrapper.entityService.updateEntity(
          entityId: "entityId",
          entityType: "entityType",
          jsonEntityData: {},
          version: 12);
      // bcTest.bcWrapper.brainCloudClient.comms.fakeErrorResponse(RequestState(), statusCode, reasonCode, statusMessage)

      await completer.future;
    });

    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      bcTest.dispose();
    });
  });

  group("Test Comms", () {
    test("testMessageCache", () async {
      // SharedPreferences.setMockInitialValues({});
      // SharedPreferencesAsync
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              url: "https://not.a.valid.server.com/nowhere",
              updateTick: 50)
          .onError((error, stackTrace) {
        print(error.toString());
      });
      // bcWrapper.restoreSession();
      final Completer completer = Completer();
      // stop run loop to accumulate requests
      int callbackCount = 0;

      bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);
      bcWrapper.brainCloudClient.enableLogging(true);
      print(
          "===- current PacketTimeouts :${bcWrapper.brainCloudClient.getPacketTimeouts()}");
      // bcWrapper.brainCloudClient.setPacketTimeouts([1, 1, 1]);
      print(
          "===+ current PacketTimeouts :${bcWrapper.brainCloudClient.getPacketTimeouts()}");

      bcWrapper.brainCloudClient.registerNetworkErrorCallback(() {
        callbackCount++;
        print(
            "${DateTime.now().toIso8601String()} - ###  Net error callback $callbackCount  ###");
        if (callbackCount == 2) completer.complete();
      });

      bcWrapper
          .authenticateUniversal(
              username: "abc", password: "abc", forceCreate: true)
          .then((result) {
        print(
            "${DateTime.now().toIso8601String()} - -   callback $callbackCount  authenticate failed $result");
      });

      await Future.delayed(Duration(seconds: 2));
      // expect(callbackCount, 1);
      print(
          "${DateTime.now().toIso8601String()} - 1   callback $callbackCount");

      bcWrapper.brainCloudClient.retryCachedMessages();
      // expect(callbackCount, 2);
      print(
          "${DateTime.now().toIso8601String()} - 2   callback $callbackCount");

      bcWrapper.brainCloudClient.flushCachedMessages(true);

      await completer.future;
      // expect(callbackCount, 2);
      print(
          "${DateTime.now().toIso8601String()} - 3   callback $callbackCount");

      // re-start run loop to for other tests
      bcWrapper.onDestroy();
    });

    test("testPacketTimeouts", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");
      SharedPreferences.setMockInitialValues({});

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              url: "https://not.a.valid.server.com/nowhere",
              updateTick: 50)
          .onError((error, stackTrace) {
        print(error.toString());
      });
      final Completer completer = Completer();
      // stop run loop to accumulate requests
      int callbackCount = 0;

      bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);
      bcWrapper.brainCloudClient.enableLogging(true);
      print(
          "===- current PacketTimeouts :${bcWrapper.brainCloudClient.getPacketTimeouts()}");
      // bcWrapper.brainCloudClient.setPacketTimeouts([1, 1, 1]);
      print(
          "===+ current PacketTimeouts :${bcWrapper.brainCloudClient.getPacketTimeouts()}");

      bcWrapper.brainCloudClient.registerNetworkErrorCallback(() {
        callbackCount++;
        print(
            "${DateTime.now().toIso8601String()} - ###  Net error callback $callbackCount  ###");
        if (callbackCount == 2) completer.complete();
      });

      bcWrapper
          .authenticateUniversal(
              username: "abc", password: "abc", forceCreate: true)
          .then((result) {
        print(
            "${DateTime.now().toIso8601String()} - -   callback $callbackCount  authenticate failed $result");
      });

      await Future.delayed(Duration(seconds: 2));
      // expect(callbackCount, 1);
      print(
          "${DateTime.now().toIso8601String()} - 1   callback $callbackCount");

      bcWrapper.brainCloudClient.retryCachedMessages();
      // expect(callbackCount, 2);
      print(
          "${DateTime.now().toIso8601String()} - 2   callback $callbackCount");

      bcWrapper.brainCloudClient.flushCachedMessages(true);

      await completer.future;
      // expect(callbackCount, 2);
      print(
          "${DateTime.now().toIso8601String()} - 3   callback $callbackCount");

      // re-start run loop to for other tests
      bcWrapper.onDestroy();
    });
  });
}
