import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';

import 'stored_ids.dart' if (dart.library.js_interop) 'stored_ids_web.dart';
import 'test_users.dart';

class BCTest {

  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest", persistance: MemoryPersistance() );
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
  setupBC({String? serverUrl}) async {
    
    //load StoredIds
    await ids.load();

    print('appId: ${ids.appId} at ${ids.url}');

    //init wrapper (this will start the update loop)
    await bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: serverUrl ?? ids.url,
            updateTick: 50)
        .onError((error, stackTrace) {
      print(error.toString());
    });

    print("Platform: ${bcWrapper.brainCloudClient.releasePlatform}");

    bcWrapper.brainCloudClient.authenticationService.clearSavedProfileID();

    await auth();
  }

  /// Initialize the wrapper and load StoredIds
  setupBCwithChild() async {

    //load StoredIds
    await ids.load();

    print('appId: ${ids.appId} at ${ids.url}');

    Map<String, String> appIdSecretMap = {
      ids.appId: ids.secretKey,
      ids.childAppId: ids.childSecret
    };

    //init wrapper (this will start the update loop)
    await bcWrapper
        .initWithApps(
            appIdSecretMap: appIdSecretMap,
            defaultAppId: ids.appId,
            version: ids.version,
            url: ids.url,
            updateTick: 50)
        .onError((error, stackTrace) {
      print(error.toString());
    });

    print("Platform: ${bcWrapper.brainCloudClient.releasePlatform}");

    bcWrapper.brainCloudClient.authenticationService.clearSavedProfileID();

    await auth();
  }

  /// Authenticate with email and password found in test/ids.txt
  Future auth({String? userId, String? password}) async {
    Completer completer = Completer();
    var id = userId ?? userA.name;
    var token = password ?? userA.password;
    ServerResponse response;

    // Ensure userC is ready.
    if (userC.profileId == null) {
      response = await bcWrapper.authenticateEmailPassword(
          email: userC.email, password: userC.password, forceCreate: true);
      userC.profileId = response.data?["profileId"];
      await bcWrapper.logout(forgetUser: true);
    }

    // Ensure userB is ready.
    if (userB.profileId == null) {
      response = await bcWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);
      userB.profileId = response.data?["profileId"];
      await bcWrapper.logout(forgetUser: true);
    }
    // Now authenticate the requested user or userA if null
    response = await bcWrapper.authenticateUniversal(
        username: id, password: token, forceCreate: true);

    if (id == userA.name) {
      userA.profileId = response.data?["profileId"];
    }

    print(
        "Current profileId/session ${bcWrapper.getStoredProfileId()} / ${bcWrapper.brainCloudClient.getSessionId()} as $id");

    completer.complete();

    return completer.future;
  }
}

TestUser userA = TestUser("UserA", generateRandomString(9));
TestUser userB = TestUser("UserB", generateRandomString(9));
TestUser userC = TestUser("UserC", generateRandomString(9));

String uniqueString = "${(DateTime.now().millisecondsSinceEpoch / 60000).floor()}";