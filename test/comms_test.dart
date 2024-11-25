import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  group("Test Comms custom init", () {
    setUpAll(() async {
      await bcTest.ids.load();
    });

    test("messageCache", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              // Need to use a server that does not immediately return a DNS error, so it need to be somewhat valid.
              url: bcTest.ids.url.replaceFirst("api", "avi"),
              // url: "https://not.a.valid.server.com/nowhere",
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
          .then((response) {
          expect(response.statusCode, 900, reason: "Should not have completed Authentication Requests. when NetworkErrorMessageCaching and NetworkErrorCallback is register on invalid server");  
          expect(response.reasonCode, ReasonCodes.clientNetworkErrorTimeout);   // 90001
      });

      // Add more to the mesage queue
      bcWrapper.globalAppService.readProperties().then((response) {
        // print("globalAppService.readProperties: $response");
          expect(response.statusCode, 900, reason: "Should not have completed readProperties Requests. when NetworkErrorMessageCaching and NetworkErrorCallback is register on invalid server");  
          expect(response.reasonCode, ReasonCodes.clientNetworkErrorTimeout);  // 90001 
          expect(response.error, "Timeout trying to reach brainCloud server, please check the URL and/or certificates for server");
      });

      await Future.delayed(Duration(seconds: 2));
      bcWrapper.brainCloudClient.retryCachedMessages();

      await Future.delayed(Duration(seconds: 2));
      bcWrapper.brainCloudClient.flushCachedMessages(true);

      await completer.future;

      bcWrapper.brainCloudClient.deregisterNetworkErrorCallback();

      bcWrapper.onDestroy();
    });

    test("Bad Url", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");

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

    test("Wrong Server", () async {
      final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterCommsTest");

      await bcWrapper
          .init(
              secretKey: bcTest.ids.secretKey,
              appId: bcTest.ids.appId,
              version: bcTest.ids.version,
              url: "https://bitheads.com/nowhere",
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
  
    test("enableCommunications/shutDown", () async {
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

  group("Test Comms default init", () {

    setUpAll(() async {
      await bcTest.setupBC();
    });

    test("insertEndOfMessageBundleMarker", () async {
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();

      // Queue up 3 request with a forced bundle marker in between
      var pkt1 = bcTest.bcWrapper.brainCloudClient.getReceivedPacketId();
      var request1 = bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();
      var request2 =  bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      var request3 =  bcTest.bcWrapper.playerStatisticsService.readAllUserStats();
      var request4 =  bcTest.bcWrapper.globalAppService.readProperties();
      
      // Now wait for them to complete, dont really care about the results so dont capture it.
      await request1;
      await request2;
      await request3;
      await request4;

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
