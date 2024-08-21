import 'dart:async';
import 'dart:convert';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stored_ids.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");

  group("BrainCloud Dart Test", () {
    test("Init", () async {
      StoredIds ids = StoredIds('test/ids.txt');
      await ids.load();

      //start test

      bcWrapper
          .init(
              secretKey: ids.secretKey,
              appId: ids.appId,
              version: ids.version,
              url: ids.url)
          .then((_) {
        expect(bcWrapper.isInitialized, true);

        bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

        if (hadSession) {
          bcWrapper.restoreSession();
        }

        int packetId = bcWrapper.getStoredPacketId();
        if (packetId > BrainCloudComms.noPacketExpected) {
          bcWrapper.restorePacketId();
        }

        Timer.periodic(const Duration(milliseconds: 500), (timer) {
          bcWrapper.update();
        });
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
      });
    });

    // end test

    test("authenticateEmailPassword", () {
      bcWrapper
          .authenticateEmailPassword(
              email: "argResults[username] as String ??",
              password: "argResults[password] as String",
              forceCreate: false)
          .then((value) {
        debugPrint(jsonEncode(value.toJson()));
        expect(value.body, 200);
      }).onError((error, stackTrace) {
        debugPrint(error.toString());
        expect({}, {"stackTrace": stackTrace});
      }).whenComplete(
        () => debugPrint('authenticateEmailPassword whenComplete '),
      );
    });
  });
}
