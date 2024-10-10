import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stored_ids.dart';
import 'test_users.dart';

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
    userB.profileId = null;
  }

  BCTest._internal();

  /// Initialize the wrapper and load StoredIds
  setupBC() async {
    SharedPreferences.setMockInitialValues({});

    //load StoredIds
    await ids.load();

    debugPrint('appId: ${ids.appId} at ${ids.url}');

    //init wrapper (this will start the update loop)
    await bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .onError((error, stackTrace) {
      debugPrint(error.toString());
    });

    bcWrapper.brainCloudClient.authenticationService.clearSavedProfileID();

    await auth();
  }

  /// Authenticate with email and password found in test/ids.txt
  Future auth({String? userId, String? password}) async {
    Completer completer = Completer();
    var id = userId ?? userA.name;
    var token = password ?? userA.password;
    ServerResponse response;

    if (userB.profileId == null) {
      response = await bcWrapper.authenticateEmailPassword(
          email: userC.email, password: userC.password, forceCreate: true);

      response = await bcWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      userB.profileId = response.data?["profileId"];

      response = await bcWrapper.authenticateUniversal(
          username: id, password: token, forceCreate: true);

      if (id == userA.name) {
        userA.profileId = response.data?["profileId"];
      }
    } else {
      response = await bcWrapper.authenticateUniversal(
          username: id, password: token, forceCreate: true);

      if (id == userA.name) {
        userA.profileId = response.data?["profileId"];
      }
    }
    
    debugPrint("Current profileId/session ${bcWrapper.getStoredProfileId()} / ${bcWrapper.getStoredSessionId()}");

    completer.complete();

    return completer.future;
  }
}

TestUser userA = TestUser("UserA", generateRandomString(8));
TestUser userB = TestUser("UserB", generateRandomString(8));
TestUser userC = TestUser("UserC", generateRandomString(8));
