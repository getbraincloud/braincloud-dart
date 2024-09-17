import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

import 'stored_ids.dart';

class BCTest {
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  final String entityType = "DartUnitTests";

  StoredIds ids = StoredIds('test/ids.txt');

  static final BCTest _bcTest = BCTest._internal();

  factory BCTest() {
    return _bcTest;
  }

  BCTest._internal();

  setupBC() async {
    // });
    // test("Init", () async {

    SharedPreferences.setMockInitialValues({});

    await ids.load();

    ids.email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    ids.password =
        ids.password.isEmpty ? const UuidV4().generate() : ids.password;

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
  }

  auth() async {
    bcWrapper.brainCloudClient.enableLogging(false);
    if (!bcWrapper.brainCloudClient.isAuthenticated()) {
      await bcWrapper.authenticateUniversal(
          username: ids.email, password: ids.password, forceCreate: true);
    }
  }
}
