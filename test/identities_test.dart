import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stored_ids.dart';
import 'test_users.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String customEntityType = "";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

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

  group("Identities Tests", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));
    TestUser userC = TestUser("UserC", generateRandomString(8));

    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: userC.email, password: userC.password, forceCreate: true);

        await bcWrapper.authenticateUniversal(
            username: userB.name, password: userB.password, forceCreate: true);
      }
    });

    // end test

    test("getExpiredIdentities", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcWrapper.identityService.getExpiredIdentities();

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['identities'], isMap);
      }
    });

    test("getIdentities", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response = await bcWrapper.identityService.getIdentities();

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['identities'], isMap);
        expect(body['identities']['Universal'], userB.name.toLowerCase());
      }
    });

    test("attachEmailIdentity", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response = await bcWrapper.identityService
          .attachEmailIdentity(userA.email, userA.password);

      expect(response.statusCode, 200);
      // expect(response.body, isMAp);
    });

    test("detachEmailIdentity", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response = await bcWrapper.identityService
          .detachEmailIdentity(userA.email, true);

      expect(response.statusCode, 200);
      // expect(response.body, isNull);
    });

    test("mergeEmailIdentity", () async {
      expect(bcWrapper.isInitialized, true);

      // if there is already a email identity detach it
      ServerResponse checks = await bcWrapper.identityService.getIdentities();
      if (checks.statusCode == 200 && checks.body != null) {
        Map<String, dynamic> body = checks.body!;
        if (body['identities']['Email'] != null) {
          checks = await bcWrapper.identityService
              .detachEmailIdentity(body['identities']['Email'], true);
        }
      }

      ServerResponse response = await bcWrapper.identityService
          .mergeEmailIdentity(userC.email, userC.password);

      expect(response.statusCode, 200);
      // expect(response.body, isNull);
    });
  });
}
