import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';
import 'dart:io' as io;

@override
main() async {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Authentication", () {
    test("releasePlatform", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      String platform = "LINUX";
      if (io.Platform.isIOS) platform = "IOS";
      if (io.Platform.isWindows) platform = "WINDOWS";
      if (io.Platform.isMacOS) platform = "MAC";
      if (io.Platform.isAndroid) platform = "ANG";

      expect(bcTest.bcWrapper.brainCloudClient.releasePlatform, Platform.fromString(platform));

    });

    test("authenticateAnonymous", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();

      ServerResponse response = await bcTest.bcWrapper.authenticateAnonymous();
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
      if (bcTest.ids.sharedProfileId.isEmpty) {
        // if no shared Profile Id define in ids then use the anonymous user
        bcTest.ids.sharedProfileId = response.data?['profileId'];
        // and create a shared entity too as this will be needed.
        var jsonEntityData = {"team": "RedTeam", "quantity": 0};
        await bcTest.bcWrapper.entityService.createEntity(
            entityType: bcTest.entityType,
            jsonEntityData: jsonEntityData,
            jsonEntityAcl: ACLs.readWrite);
      }
    });

    test("reconnect", () async {
      ServerResponse response;
      if (bcTest.bcWrapper.brainCloudClient.authenticated) {
        response = await bcTest.bcWrapper.logout();
        expect(response.statusCode, 200);
        expect(bcTest.bcWrapper.brainCloudClient.isAuthenticated(), false);
      }

      response = await bcTest.bcWrapper.reconnect();
      expect(response.statusCode, 200);
    });

    test("authenticateUniversal", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userA.email, password: userA.password, forceCreate: true);
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    test("logout", () async {
      if (!bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.authenticateEmailPassword(
            email: userA.email, password: userA.password, forceCreate: false);
      }

      ServerResponse response = await bcTest.bcWrapper.logout(forgetUser: true);
      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.reconnect();
      expect(response.statusCode, StatusCodes.accepted);
    });

    test("smartSwitchauthenticateUniversal", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateAnonymous();
      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.smartSwitchauthenticateUniversal(
          username: userA.email, password: userA.password, forceCreate: true);
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    test("smartSwitchauthenticateAdvanced", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userA.email, password: userA.password, forceCreate: false);
      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.smartSwitchauthenticateAdvanced(
          authenticationType: AuthenticationType.anonymous,
          ids: AuthenticationIds("", "", ""),
          forceCreate: true,
          extraJson: {});
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    test("smartSwitchauthenticateEmail", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userA.email, password: userA.password, forceCreate: false);
      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.smartSwitchauthenticateEmail(
          email: userA.email, password: userA.password, forceCreate: true);
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
