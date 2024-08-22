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

    test("authenticateEmailPassword", () async {
      try {
        debugPrint(">>> Login with ${email} <<<");
        // AuthenticationType s = AuthenticationType.values.firstWhere((e)=>e.value == email);
        
        var response = await bcWrapper.authenticateEmailPassword(email: email, password: password, forceCreate: false);
        debugPrint("----------Login Success----------");
        var ressponseData = response.toJson();
        // debugPrint(jsonEncode(response.toJson()));
        debugPrint(jsonEncode(ressponseData));
        expect(ressponseData['status'], 200);
      } catch (error, stackTrace) {
        debugPrint("----------Login Failed----------");
        if ( error is ServerResponse) debugPrint(error.statusMessage);
        // debugPrint(stackTrace.toString());
        // expect({}, {"stackTrace": stackTrace});
        // expect({}, {"stackTrace": ""});
      }
    });
  });
}
