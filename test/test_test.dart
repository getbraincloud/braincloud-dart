import 'dart:async';
import 'dart:convert';
import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/src/Common/acl.dart';
import 'package:braincloud_dart/src/Common/authentication_ids.dart';
import 'package:braincloud_dart/src/internal/rtt_comms.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';
import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";
  String sharedProfileId = "";
  String customEntityType = "";
  const String entityType = "DartUnitTests";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    password = ids.password.isEmpty ? const UuidV4().generate() : ids.password;
    sharedProfileId = ids.sharedProfileId;
    customEntityType = ids.customEntityType;

    debugPrint(
        'email: ${ids.email} in appId: ${ids.appId} at ${ids.url}  with customEntityType $customEntityType');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      // expect(bcWrapper.isInitialized, false);

      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });
  group("Authentication Tests", () {
    // end test

    test("authenticateSpam", () async {
      expect(bcWrapper.isInitialized, true);

      // ServerResponse response = await bcWrapper.brainCloudClient.authenticationService.authenticateAnonymous(true);
      // expect(response.statusCode, 200);
      // expect(response.reasonCode, ReasonCodes.switchingProfiles);

    });

    test("authenticateAnonymous", () async {
      expect(bcWrapper.isInitialized, true);

      // bcWrapper.brainCloudClient.enableLogging(true);
      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();

      ServerResponse response = await bcWrapper.authenticateAnonymous();
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
      if (sharedProfileId.isEmpty) {
        // if no shared Profile Id define in ids then use the anonymous user
        sharedProfileId = response.body?['profileId'];
        // and create a shared entity too as this will be needed.
        var jsonEntityData = {"team": "RedTeam", "quantity": 0};
        await bcWrapper.entityService
            .createEntity(entityType, jsonEntityData, ACLs.readWrite);
      }
    });

    test("reconnect", () async {
      ServerResponse response;
      if (bcWrapper.brainCloudClient.authenticated) {
        response = await bcWrapper.logout(false);
        expect(response.statusCode, 200);
        expect(bcWrapper.brainCloudClient.isAuthenticated(), false);
      }

      response = await bcWrapper.reconnect();
      expect(response.statusCode, 200);
    });

    test("authenticateUniversal", () async {
      expect(bcWrapper.isInitialized, true);

      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcWrapper.authenticateUniversal(
          username: email, password: password, forceCreate: true);
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });

    test("logout", () async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
      }

      ServerResponse response = await bcWrapper.logout(true);
      expect(response.statusCode, 200);

      try {
        response = await bcWrapper.reconnect();
        fail('Should fail reconnect as no session existed.');
      } on ServerResponse {
        (response) {
          expect(response.statusCode, 403);
        };
      }
    });

    test("smartSwitchauthenticateUniversal", () async {
      expect(bcWrapper.isInitialized, true);
      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcWrapper.authenticateAnonymous();
      expect(response.statusCode, 200);

      response = await bcWrapper.smartSwitchauthenticateUniversal(
          username: email, password: password, forceCreate: true);
           expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });

    test("smartSwitchauthenticateAdvanced", () async {
      expect(bcWrapper.isInitialized, true);
      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcWrapper.authenticateUniversal(username: email, password: password, forceCreate: false);
      expect(response.statusCode, 200);

      response = await bcWrapper.smartSwitchauthenticateAdvanced(
          authenticationType: AuthenticationType.anonymous, ids: AuthenticationIds("", "", ""),forceCreate: true,extraJson: {});
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });
    test("smartSwitchauthenticateEmail", () async {
      expect(bcWrapper.isInitialized, true);
      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcWrapper.authenticateUniversal(username: email, password: password, forceCreate: false);
      expect(response.statusCode, 200);

      response = await bcWrapper.smartSwitchauthenticateEmail(
          email:email,password: password,forceCreate: true);
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });
  });


  group("Test RTT", () {
    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: email, password: password, forceCreate: false);
      }
    });

    test("enableRTT", () async {
      bcWrapper.rTTService?.disableRTT();

      ServerResponse? response =
          await bcWrapper.rTTService?.enableRTT(RTTConnectionType.websocket).onError<ServerResponse>((error,_) {
            expect(error.reasonCode, ReasonCodes.featureNotEnabled);
            return error ; //ServerResponse(statusCode: 200);
          });

      if (response?.reasonCode == ReasonCodes.featureNotEnabled) {
        markTestSkipped("Rtt not enable for this app.");
      } else if (response != null) {
        expect(response.body?['operation'], 'CONNECT');
      } else {
        throw "rtt response was null";
      }
    });

    test("rttChatCallback", () async {
      String channelId = "32:gl:valid";

      //Connect to channel
      bcWrapper.chatService?.channelConnect(channelId, 50, (response) {
        debugPrint(jsonEncode(response));
      }, (statusCode, reasonCode, statusMessage) {
        debugPrint(statusMessage);
      });
    });
  });
}
