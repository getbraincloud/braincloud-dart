import 'dart:async';
import 'dart:convert';
import 'package:braincloud_dart/src/Common/authentication_type.dart';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stored_ids.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});

  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");

  group("BrainCloud Dart Test", () {
    String email = "";
    String password = "";
    test("Init", () async {
      StoredIds ids = StoredIds('test/ids.txt');
      await ids.load();

      email = ids.email;
      password = ids.password;
      debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
      //start test

      bcWrapper.init(secretKey: ids.secretKey, appId: ids.appId, version: ids.version, url: ids.url).then((_) {
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

  test("authenticateAnonymous", () async {
        
        bcWrapper.resetStoredAuthenticationType();
        ServerResponse response = await bcWrapper.authenticateAnonymous();
        debugPrint(jsonEncode(response.body));
        expect(response.statusCode, 200);
        expect(response.body?['profileId'], isA<String>());
        expect(response.body?['server_time'], isA<double>());
        expect(response.body?['createdAt'], isA<double>());
        expect(response.body?['isTester'], isA<bool>());
        expect(response.body?['currency'], isA<Object>());
    });
  test("authenticateEmailPassword", () async {
        ServerResponse response = await bcWrapper.authenticateEmailPassword(email: email, password: password, forceCreate: false);
        debugPrint(jsonEncode(response.body));
        expect(response.statusCode, 200);
        expect(response.body?['profileId'], isA<String>());
        expect(response.body?['server_time'], isA<double>());
        expect(response.body?['createdAt'], isA<double>());
        expect(response.body?['isTester'], isA<bool>());
        expect(response.body?['currency'], isA<Object>());
    });
  });
}
