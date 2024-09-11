import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
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

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    password = ids.password.isEmpty ? const UuidV4().generate() : ids.password;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
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

  group("Test Gamification", () {
    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: email, password: password, forceCreate: true);
      }
    });

    test("profanityCheck()", () async {
      ServerResponse response = await bcWrapper.profanityService.profanityCheck(
          text: "shitbird fly away",
          languages: "en",
          flagEmail: true,
          flagPhone: true,
          flagUrls: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("profanityReplaceText()", () async {
      ServerResponse response = await bcWrapper.profanityService
          .profanityReplaceText(
              text: "shitbird fly away",
              replaceSymbol: "*",
              languages: "en",
              flagEmail: false,
              flagPhone: false,
              flagUrls: false);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("profanityIdentifyBadWords()", () async {
      ServerResponse response = await bcWrapper.profanityService
          .profanityIdentifyBadWords(
              text: "shitbird fly away",
              languages: "en,fr",
              flagEmail: true,
              flagPhone: false,
              flagUrls: false);

      expect(response.statusCode, StatusCodes.ok);
    });
  });
}
