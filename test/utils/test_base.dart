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

  dispose() {
    //this will stop the update timer
    bcWrapper.onDestroy();
  }

  BCTest._internal();

  /// Initialize the wrapper and load StoredIds
  setupBC() async {
    SharedPreferences.setMockInitialValues({});

    //load StoredIds
    await ids.load();

    // set email and password
    ids.email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    ids.password =
        ids.password.isEmpty ? const UuidV4().generate() : ids.password;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');

    //init wrapper (this will start the update loop)
    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      //retore session if there was one.
      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      //restore packetId if there was one
      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  }

  /// Authenticate with email and password found in test/ids.txt
  auth() async {
    bcWrapper.brainCloudClient.enableLogging(false);
    if (!bcWrapper.brainCloudClient.isAuthenticated()) {
      await bcWrapper.authenticateUniversal(
          username: ids.email, password: ids.password, forceCreate: true);
    }
  }
}
