import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';

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

      bcTest.bcWrapper.brainCloudClient.enableCompressedRequests(true);
      bcTest.bcWrapper.brainCloudClient.enableCompressedResponses(true);

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
          expect(message, isA<Map<String,dynamic>>());
          expect(message['status_message'],"TestMessage");
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

      bcTest.bcWrapper.brainCloudClient.deregisterGlobalErrorCallback();
    });

    test("killSwitch", () async {
      // Ensure the client is reset.
      await bcTest.setupBC();

      Completer completer = Completer();

      late ServerResponse response;

      bool loggingFlag = bcTest.bcWrapper.brainCloudClient.loggingEnabled;
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);

      response = await bcTest.bcWrapper.timeService.readServerTime();
      expect(response.statusCode, 200);

      bool _killSwitchEngaged = false;
      int _failureCount = 0;

      while (!_killSwitchEngaged) {
        response = await bcTest.bcWrapper.entityService.updateEntity(
            entityId: "FAIL",
            entityType: "FAIL_DART",
            jsonEntityData: {"test": 1},
            jsonEntityAcl: {"test": 1},
            version: -1);

        if (response.statusCode == 900 &&
            response.reasonCode == ReasonCodes.clientDisabled) {
          print("KillSwitch engaging.");
          _killSwitchEngaged = true;
          expect(response.error['status_message'],
              "Client has been disabled due to repeated errors from a single API call");
          completer.complete();
        } else {
          expect(_failureCount, lessThan(13),
              reason:
                  "UpdateEntity called too many times without killswitch turning on/");
          expect(response.statusCode, 404,
              reason: "This entity should not exists");
        }
      }
      await completer.future;
      // restore flag for other tests.
      bcTest.bcWrapper.brainCloudClient.enableLogging(loggingFlag);
    });

    test("killSwitch Other Authentication", () async {
      // Ensure the client is reset.
      await bcTest.setupBC();

      late ServerResponse response;

      bool loggingFlag = bcTest.bcWrapper.brainCloudClient.loggingEnabled;
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);

      response = await bcTest.bcWrapper.timeService.readServerTime();
      expect(response.statusCode, 200);

      String noAccount = "email$uniqueString@bitheadscom";
      for (var i = 0; i < 3; i++) {
        response = await bcTest.bcWrapper.authenticateEmailPassword(
            email: noAccount, password: "password", forceCreate: false);
        expect(response.statusCode, 202,
            reason: "This account should not exists");
        expect(response.reasonCode, ReasonCodes.missingProfileError,
            reason: "This account should not exists");
      }

      response = await bcTest.bcWrapper.authenticateEmailPassword(
          email: noAccount, password: "password", forceCreate: false);

      expect(response.statusCode, 900);
      expect(response.reasonCode, ReasonCodes.clientDisabledFailedAuth);

      // To minimize log entries stop logging but re-enable just before the timer expuiry
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      await Future.delayed(Duration(milliseconds: 29800));
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      await Future.delayed(Duration(milliseconds: 1200));

      // Should be unlock now.
      print("Should be unlock now.");
      response = await bcTest.bcWrapper.authenticateEmailPassword(
          email: noAccount, password: "password", forceCreate: false);
      expect(response.statusCode, 202,
          reason: "This account should not exists");
      expect(response.reasonCode, ReasonCodes.missingProfileError,
          reason: "This account should not exists");

      // restore flag for other tests.
      bcTest.bcWrapper.brainCloudClient.enableLogging(loggingFlag);
    }, timeout: Timeout.parse("90s"));

    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      bcTest.dispose();
    });
  });

  group("Test Client no-Wrapper", () {
    test("BrainCloudClient Init", () async {
      await bcTest.ids.load(); //Load test config
      print("-- will use Universal user ${userA.name}");

      final BrainCloudClient bcClient = await BrainCloudClient(null);

      expect(bcClient.isInitialized(), false);
      expect(bcClient.isAuthenticated(), false);
      bcClient.enableLogging(true);

      bcClient.initialize(
          serverURL: bcTest.ids.url,
          secretKey: bcTest.ids.secretKey,
          appId: bcTest.ids.appId,
          appVersion: bcTest.ids.version,
      )
      ;
      expect(bcClient.isInitialized(), true);

      final runloop = Timer.periodic(Duration(milliseconds: 40), (timer) {
        bcClient.runCallbacks();
      });

      ServerResponse authResp1 = await bcClient.authenticationService
          .authenticateUniversal(
              userId: userA.name, password: userA.password, forceCreate: true);

      expect(authResp1.statusCode, 200);
      expect(bcClient.isAuthenticated(), true, reason: "Should be logged-in");

      // Add some operations to ensure packet id are not in sync
      await bcClient.entityService.getSingleton(entityType: "entityType");
      await bcClient.entityService.getSingleton(entityType: "entityTypeB");

      expect(bcClient.getReceivedPacketId() > 1, isTrue);

      await bcClient.playerStateService.logout();
      expect(bcClient.isAuthenticated(), false,
          reason: "Should have logged-out");

      runloop.cancel();
    });

    test("Missing Secret for AppId", () async {
      await bcTest.ids.load(); //Load test config
      final BrainCloudClient bcClient = await BrainCloudClient(null);

      bcClient.enableLogging(true);

      ServerResponse response = await bcClient.authenticationService
          .authenticateUniversal(
              userId: userA.name, password: userA.password, forceCreate: true);
      print("Auto Resp: $response");
      expect(response.statusCode, StatusCodes.clientNetworkError);   // 900
      expect(response.reasonCode, ReasonCodes.clientNotInitialized);  // 90202
      expect(response.error, "Client not Initialized");

      bcClient.shutDown();
    });
  });

  tearDownAll(() {
    bcTest.dispose();
  });
}
