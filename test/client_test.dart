import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

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

      bcTest.bcWrapper.brainCloudClient.deregisterGlobalErrorCallback();
    });

    test("killSwitch", () async {
      // Ensure the client is reset.
      await bcTest.setupBC();

      Completer completer = Completer();

      late ServerResponse response;

      bool loggingFlag  = bcTest.bcWrapper.brainCloudClient.loggingEnabled;
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

      bool loggingFlag  = bcTest.bcWrapper.brainCloudClient.loggingEnabled;
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);

      response = await bcTest.bcWrapper.timeService.readServerTime();
      expect(response.statusCode, 200);

      String noAccount = "email$uniqueString@bitheadscom";
      for (var i = 0; i < 3; i++) {
        response = await bcTest.bcWrapper.authenticateEmailPassword(email: noAccount, password: "password", forceCreate: false);
        expect(response.statusCode, 202,reason: "This account should not exists");
        expect(response.reasonCode, ReasonCodes.missingProfileError,reason: "This account should not exists");
      }

      response = await bcTest.bcWrapper.authenticateEmailPassword(email: noAccount, password: "password", forceCreate: false);

      expect(response.statusCode,900);
      expect(response.reasonCode,ReasonCodes.clientDisabledFailedAuth);

      // To minimize log entries stop logging but re-enable just before the timer expuiry
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      await Future.delayed(Duration(milliseconds: 29800));
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      await Future.delayed(Duration(milliseconds: 1200));

      // Should be unlock now.
      print("Should be unlock now.");
      response = await bcTest.bcWrapper.authenticateEmailPassword(email: noAccount, password: "password", forceCreate: false);
      expect(response.statusCode, 202,reason: "This account should not exists");
      expect(response.reasonCode, ReasonCodes.missingProfileError,reason: "This account should not exists");

      // restore flag for other tests.
      bcTest.bcWrapper.brainCloudClient.enableLogging(loggingFlag);
    },timeout: Timeout.parse("90s"));


    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      bcTest.dispose();
    });
  });
}
