import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  // setUpAll(bcTest.setupBC);

  group("Test Wrapper", () {
    setUpAll(() async {
      await bcTest.setupBC();
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
    });

    Future<BrainCloudWrapper> _createWraper(String name) async {
      var bcWrapper = BrainCloudWrapper(wrapperName: name);
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
      return bcWrapper;
    }

    test("Multi-Wrapper", () async {
      print("--");
      final BrainCloudWrapper bcWrapper1 = await _createWraper("Wrap1");
      final BrainCloudWrapper bcWrapper2 = await _createWraper("Wrap2");

      expect(bcWrapper1.brainCloudClient.isAuthenticated(), false);
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), false);

      ServerResponse authResp1 = await bcWrapper1.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);
      print("++++ authResp1: ${authResp1.data?['id']}");
      expect(authResp1.statusCode, 200);
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), true,
          reason: "Should be logged-in");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), false,
          reason: "Should not be logged-in");

      print(
          "bcWrapper1 pkt id: ${bcWrapper1.brainCloudClient.getReceivedPacketId()}");

      ServerResponse authResp2 = await bcWrapper2.authenticateUniversal(
          username: userC.name, password: userC.password, forceCreate: true);
      print("++++ authResp2: ${authResp2.data?['id']}");
      expect(authResp2.statusCode, 200);
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), true,
          reason: "Should still be logged-in");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), true,
          reason: "Should be logged-in");

      // Add some operations to ensure packet id are not in sync
      await bcWrapper1.entityService.getSingleton(entityType: "entityType");
      await bcWrapper1.entityService.getSingleton(entityType: "entityTypeB");

      print(
          "bcWrapper1 pkt id: ${bcWrapper1.brainCloudClient.getReceivedPacketId()}");

      expect(bcWrapper1.brainCloudClient.getReceivedPacketId() > 1, isTrue);

      await bcWrapper1.logout();
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), false,
          reason: "Should have logged-out");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), true,
          reason: "Should still be logged-in");

      expect(bcWrapper1.brainCloudClient.getReceivedPacketId(),
          isNot(bcWrapper2.brainCloudClient.getReceivedPacketId()),
          reason: "Packet Id should not match");
    });
  });
  group("Test Client", () {
    test("Direct Client Test", () async {
      
      await bcTest.ids.load(); //Load test config
      print("-- will user Universal user ${userA.name}");
      
      final BrainCloudClient bcClient = await BrainCloudClient(null);

      expect(bcClient.isInitialized(), false);
      expect(bcClient.isAuthenticated(), false);
      bcClient.enableLogging(true);


      bcClient.initialize(
          secretKey: bcTest.ids.secretKey,
          appId: bcTest.ids.appId,
          appVersion: bcTest.ids.version,
          serverURL: bcTest.ids.url);
      expect(bcClient.isInitialized(), true);

      final runloop = Timer.periodic(Durations.short1, (timer) {
        bcClient.runCallbacks();
      });

      ServerResponse authResp1 = await bcClient.authenticationService
          .authenticateUniversal(
              userId: userA.name, password: userA.password, forceCreate: true);

      String? pId = authResp1.data?['id'];
      if (pId == null)
        print("++++ response : ${authResp1.data}");
      else
        print("++++ authResp1: $pId");

      expect(authResp1.statusCode, 200);
      expect(bcClient.isAuthenticated(), true, reason: "Should be logged-in");

      print("bcWrapper1 pkt id: ${bcClient.getReceivedPacketId()}");

      // Add some operations to ensure packet id are not in sync
      await bcClient.entityService.getSingleton(entityType: "entityType");
      await bcClient.entityService.getSingleton(entityType: "entityTypeB");

      print("bcWrapper1 pkt id: ${bcClient.getReceivedPacketId()}");

      expect(bcClient.getReceivedPacketId() > 1, isTrue);

      await bcClient.playerStateService.logout();
      expect(bcClient.isAuthenticated(), false,
          reason: "Should have logged-out");

      runloop.cancel();
    });

    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
