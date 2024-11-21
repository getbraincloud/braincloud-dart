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

      bcTest.bcWrapper.brainCloudClient.deregisterGlobalErrorCallback();

    });

    tearDownAll(() {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      bcTest.dispose();
    });
  });

  group("Test Comms", () {
    setUpAll(() async {
      await bcTest.ids.load();
    });

    test("testMessageCache", () async {
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

      final Completer completer = Completer();
      // stop run loop to accumulate requests
      int callbackCount = 2;

      bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);
      bcWrapper.brainCloudClient.enableLogging(true);

      bcWrapper.brainCloudClient.registerNetworkErrorCallback(() {
        callbackCount--;
        if (callbackCount == 0) completer.complete();
      });

      bcWrapper
          .authenticateUniversal(
              username: "abc", password: "abc", forceCreate: true)
          .then((result) {
        fail(
            "Should not have completed Authentication Requests. when NetworkErrorMessageCaching and NetworkErrorCallback is register on invalid server");
      });

      await Future.delayed(Duration(seconds: 2));
      bcWrapper.brainCloudClient.retryCachedMessages();

      bcWrapper.brainCloudClient.flushCachedMessages(true);

      await completer.future;

      bcWrapper.brainCloudClient.deregisterNetworkErrorCallback();

      bcWrapper.onDestroy();
    });

    test("testPacketTimeouts Bad Address", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");
      SharedPreferences.setMockInitialValues({});

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              // url: "https://localhost/nowhere",
              // url: "https://lismar.ca/nowhere",
              url: "https://not.a.valid.server.com/nowhere",
              updateTick: 50)
          .onError((error, stackTrace) {
        print(error.toString());
      });
      bcWrapper.brainCloudClient.enableLogging(true);
      // bcWrapper.brainCloudClient.setAuthenticationPacketTimeout(2);
      final Completer completer = Completer();

      bcWrapper
          .authenticateUniversal(
              username: "abc", password: "abc", forceCreate: true)
          .then((result) {
        expect(result.statusCode, 900);
        expect(result.reasonCode, ReasonCodes.clientNetworkErrorTimeout);
        completer.complete();
      });

      await completer.future;

      bcWrapper.onDestroy();
    });

    test("testPacketTimeouts Wrong Server", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");
      // SharedPreferences.setMockInitialValues({});

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              url: "https://bitheads.com/nowhere",
              // url: "https://not.a.valid.server.com/nowhere",
              updateTick: 50)
          .onError((error, stackTrace) {
        print(error.toString());
      });
      bcWrapper.brainCloudClient.enableLogging(true);
      bcWrapper.brainCloudClient.setAuthenticationPacketTimeout(2);
      final Completer completer = Completer();

      bcWrapper
          .authenticateUniversal(
              username: "abc", password: "abc", forceCreate: true)
          .then((result) {
            print("authenticateUniversal: $result");
        expect(result.statusCode, 404);
        expect(result.reasonCode, 301);
        completer.complete();
      });

      await completer.future.timeout(Duration(seconds: 3));

      bcWrapper.onDestroy();
    });

    test("isAuthenticateRequestInProgress", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");
      SharedPreferences.setMockInitialValues({});
      bcWrapper.brainCloudClient.enableLogging(true);

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              url: bcTest.ids.url,
              updateTick: 50)
          .onError((error, stackTrace) {
        print(error.toString());
      });
      // bcWrapper.brainCloudClient.enableNetworkErrorMessageCaching(true);

      final Completer completer = Completer();

      int callbackCount = 0;

      bcWrapper
          .authenticateUniversal(
              username: userA.name, password: userA.password, forceCreate: true)
          .then((result) {
        completer.complete();
        print(
            "${DateTime.now().toIso8601String()} - Orig -   callback $callbackCount  authenticate $result");
      });

      expect(bcWrapper.brainCloudClient.comms.isAuthenticateRequestInProgress(),
          false,
          reason: "Authenticater request should not be in progress yet");
      // wait long enough to have the retuest in progress
      await Future.delayed(Duration(milliseconds: 55));
      expect(bcWrapper.brainCloudClient.comms.isAuthenticateRequestInProgress(),
          true,
          reason: "Authenticate Request should have sent the reeust now");
      bcWrapper
          .authenticateUniversal(
              username: userA.name, password: userA.password, forceCreate: true)
          .then((result) {
        print(
            "${DateTime.now().toIso8601String()} - New - authenticate $result");
      });

      await completer.future;
      expect(bcWrapper.brainCloudClient.comms.isAuthenticateRequestInProgress(),
          false,
          reason: "Authenticate Request should have completed now.");

      // re-start run loop to for other tests
      bcWrapper.onDestroy();
    });
  
    test("shutDown comms", () async {
      await bcTest.setupBC();
      
      bcTest.bcWrapper.brainCloudClient.sendHeartbeat();

      ServerResponse response = await bcTest.bcWrapper.entityService.getList(whereJson: {}, orderByJson: {}, maxReturn:5);
      expect(response.statusCode, 200);

      // Pause communications
      bcTest.bcWrapper.brainCloudClient.enableCommunications(false);
      
      Completer<ServerResponse> delayedResponse = Completer();

      // make a request that should not go true
      bcTest.bcWrapper.entityService.getList(whereJson: {}, orderByJson: {}, maxReturn:5).then( (response) {
        // fail("Should not complte while communitaction disabled");
        delayedResponse.complete(response);
      });
      
      // give it ample time to complete
      await Future.delayed(Duration(seconds: 3));

      // check it did not complete
      expect(delayedResponse.isCompleted, false, reason: "Should not get respose while comms disabled");

      // restore communications
      bcTest.bcWrapper.brainCloudClient.enableCommunications(true);
      
      // now wait for it to complete
      response = await delayedResponse.future;
      expect(response.statusCode, 200);

      // Complte shutdown now
      bcTest.bcWrapper.brainCloudClient.shutDown();

      // make another query that sould not complete
      response = await bcTest.bcWrapper.entityService.getList(whereJson: {}, orderByJson: {}, maxReturn:5);
      expect(response.statusCode, 403);
      expect(response.reasonCode, ReasonCodes.noSession);
      

      bcTest.dispose();

    }); 
  });
}
