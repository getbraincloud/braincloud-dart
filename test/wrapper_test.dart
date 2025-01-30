import 'dart:async';

import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  // setUpAll(bcTest.setupBC);

  Future<BrainCloudWrapper> _createWrapper(String name) async {
    var bcWrapper = BrainCloudWrapper(wrapperName: name);
    await bcWrapper
        .init(
            secretKey: bcTest.ids.secretKey,
            appId: bcTest.ids.appId,
            version: bcTest.ids.version,
            url: bcTest.ids.url,
            updateTick: 50)
        .onError((error, stackTrace) {
      print(error.toString());
    });
    return bcWrapper;
  }

  group("Test Wrapper Reset", () {
    setUpAll(bcTest.setupBC);
    // This test need to be in a separate group not to impact other tests
    // as it reset the wrapper
    test("resetWrapper", () async {
      expect(bcTest.bcWrapper.wrapperName, "FlutterTest");

      bcTest.bcWrapper.resetWrapper(resetWrapperName: true);

      expect(bcTest.bcWrapper.wrapperName, isNot("FlutterTest"));
      expect(bcTest.bcWrapper.wrapperName, isEmpty);
    });
  });

  group("Test Wrapper", () {
    setUpAll(() async {
      await bcTest.setupBC();
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
    });

    test("Multi-Wrapper", () async {
      print("--");
      final BrainCloudWrapper bcWrapper1 = await _createWrapper("Wrap1");
      final BrainCloudWrapper bcWrapper2 = await _createWrapper("Wrap2");

      expect(bcWrapper1.brainCloudClient.isAuthenticated(), false);
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), false);

      ServerResponse authResp1 = await bcWrapper1.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);
      print("++++ authResp1: ${authResp1.data?['id']}");
      expect(authResp1.statusCode, 200);
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), true,
          reason: "Should be logged-in");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), false,
          reason: "Should not be logged-in");

      print(
          "bcWrapper1 pkt id: ${bcWrapper1.brainCloudClient.getReceivedPacketId()}");

      ServerResponse authResp2 = await bcWrapper2.authenticateUniversal(
          username: userC.name, password: userC.password, forceCreate: true);
      print("++++ authResp2: ${authResp2.data?['id']}");
      expect(authResp2.statusCode, 200);
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), true,
          reason: "Should still be logged-in");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), true,
          reason: "Should be logged-in");

      // Add some operations to ensure packet id are not in sync
      await bcWrapper1.entityService.getSingleton(entityType: "entityType");
      await bcWrapper1.entityService.getSingleton(entityType: "entityTypeB");

      print(
          "bcWrapper1 pkt id: ${bcWrapper1.brainCloudClient.getReceivedPacketId()}");

      expect(bcWrapper1.brainCloudClient.getReceivedPacketId() > 1, isTrue);

      await bcWrapper1.logout();
      expect(bcWrapper1.brainCloudClient.isAuthenticated(), false,
          reason: "Should have logged-out");
      expect(bcWrapper2.brainCloudClient.isAuthenticated(), true,
          reason: "Should still be logged-in");

      expect(bcWrapper1.brainCloudClient.getReceivedPacketId(),
          isNot(bcWrapper2.brainCloudClient.getReceivedPacketId()),
          reason: "Packet Id should not match");
    });

    test("authenticateAdvanced", () async {
      BrainCloudWrapper _bc = BrainCloudWrapper(wrapperName: "_mainWrapper");

      String externalId = "authAdvancedUser";
      String authenticationToken = "authAdvancedPass";
      String authenticationSubType = "";
      AuthenticationIds ids = AuthenticationIds(
          externalId, authenticationToken, authenticationSubType);

      ServerResponse response = await _bc.authenticateAdvanced(
          authenticationType: AuthenticationType.universal,
          ids: ids,
          extraJson: {"key": "value"},
          forceCreate: true);

      if (response.statusCode == 200) {
        // Success
      } else {
        // Failed
      }
    });

    test("getServerVersion", () async {
      ServerResponse response = await bcTest.bcWrapper.getServerVersion();

      expect(response.statusCode, 200);
      expect(response.data?["serverVersion"], isA<String>());
    });

    test("authenticateHandoff", () async {
      ServerResponse tokenResp = await bcTest.bcWrapper.scriptService
          .runScript(scriptName: "createHandoffId");

      if (tokenResp.statusCode == 200) {
        String handoffId = tokenResp.data?["response"]["handoffId"];
        String securityToken = tokenResp.data?["response"]["securityToken"];
        ServerResponse response = await bcTest.bcWrapper.authenticateHandoff(
            handoffId: handoffId, securityToken: securityToken);

        expect(response.statusCode, 200);
      }
    });
    test("authenticateSettopHandoff", () async {
      ServerResponse tokenResp = await bcTest.bcWrapper.scriptService
          .runScript(scriptName: "CreateSettopHandoffCode");
      if (tokenResp.statusCode == 200) {
        String handoffCode = tokenResp.data?["response"]["handoffCode"];
        ServerResponse response = await bcTest.bcWrapper
            .authenticateSettopHandoff(handoffCode: handoffCode);
        expect(response.statusCode, 200);
      }
    });
    test("resetStoredAuthenticationType", () {
      String authType = bcTest.bcWrapper.getStoredAuthenticationType();
      if (authType.isNotEmpty) {
        bcTest.bcWrapper.resetStoredAuthenticationType();
        expect(bcTest.bcWrapper.getStoredAuthenticationType(), isEmpty);
      } else {
        Skip("Authentication type not initialized cannot test reseting it,");
      }
    });

    test("Genereal", () {
      bcTest.bcWrapper.alwaysAllowProfileSwitch = false;
      expect(bcTest.bcWrapper.alwaysAllowProfileSwitch, false,
          reason: "alwaysAllowProfileSwitch should have been false");

      bcTest.bcWrapper.alwaysAllowProfileSwitch = true;
      expect(bcTest.bcWrapper.alwaysAllowProfileSwitch, true,
          reason: "alwaysAllowProfileSwitch should have been true");

      expect(bcTest.bcWrapper.canReconnect(), true,
          reason: "canReconnect should have be true, since we did signin");
    });
  });

  group("Test auto-reconnect", () {
    setUpAll(bcTest.setupBC);

    test("Confirm Disconnect", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.brainCloudClient.enableLogging(true);
      ServerResponse userSessionResp = await userWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      print(userSessionResp.data);

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, 403,
          reason: "Session should have been invalidated");
      expect(userSessionResp.reasonCode, ReasonCodes.playerSessionExpired,
          reason: "Resoncode should be userSessionExpired 40303");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
    test("Auto-Reconnect", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.brainCloudClient.enableLogging(true);
      print(
          " Generated id: ${userWrapper.brainCloudClient.authenticationService.generateAnonymousId()}");

      userWrapper.enableLongSession(true);
      ServerResponse userSessionResp = await userWrapper.authenticateUniversal(
          username: "${userB.name}_${DateTime.now().microsecond}",
          password: userB.password,
          forceCreate: true);

      print(userSessionResp.data);

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Session be able to get attributes again");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
    test("Auto-Reconnect by service", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.resetStoredAnonymousId();
      userWrapper.resetStoredProfileId();

      userWrapper.brainCloudClient.enableLogging(true);
      print(
          " Generated id: ${userWrapper.brainCloudClient.authenticationService.generateAnonymousId()}");
      userWrapper.enableLongSession(true);
      ServerResponse userSessionResp = await userWrapper.authenticationService
          .authenticateUniversal(
              userId: "${userB.name}_${DateTime.now().millisecondsSinceEpoch}",
              password: userB.password,
              forceCreate: true);

      print(userSessionResp.data);

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Session be able to get attributes again");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });

    test("Auto-Reconnect flag late", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.brainCloudClient.enableLogging(true);
      ServerResponse userSessionResp = await userWrapper.authenticateUniversal(
          username: "${userB.name}_${DateTime.now().microsecond}",
          password: userB.password,
          forceCreate: true);

      print(userSessionResp.data);

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      userWrapper.enableLongSession(true);

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Session be able to get attributes again");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
    test("Auto-Reconnect Anonymous", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.resetStoredAnonymousId();
      userWrapper.resetStoredProfileId();

      userWrapper.brainCloudClient.enableLogging(true);
      userWrapper.enableLongSession(true);
      ServerResponse userSessionResp =
          await userWrapper.authenticateAnonymous();

      print(userSessionResp.data);

      // userSessionResp = await userWrapper.authenticateLongSession();

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Session be able to get attributes again");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
    test("Auto-Reconnect with bundle", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.brainCloudClient.enableLogging(true);
      userWrapper.enableLongSession(true);
      ServerResponse userSessionResp = await userWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      print(userSessionResp.data);

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userWrapper.playerStateService.setUserStatus(
          statusName: "Active", durationSecs: 5, details: {"value": true});
      userSessionResp = await userWrapper.playerStateService.getAttributes();

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Call an api to validate the session has been terminated.
      userWrapper.playerStateService.setUserStatus(
          statusName: "Active", durationSecs: 5, details: {"value": false});
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Session be able to get attributes again");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
    test("Auto-Reconnect fails", () async {
      final BrainCloudWrapper userWrapper = await _createWrapper("user");
      userWrapper.brainCloudClient.enableLogging(true);
      userWrapper.enableLongSession(true);

      ServerResponse userSessionResp = await userWrapper.authenticateUniversal(
          username: userB.name, password: userB.password, forceCreate: true);

      print(userSessionResp.data);

      // userSessionResp = await userWrapper.authenticateLongSession();

      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to login test user");
      String profileId = userSessionResp.data?["id"];
      String sessionId = userSessionResp.data?["sessionId"];
      expect(profileId, isA<String>(),
          reason: "Failed to get profileId from login results");
      expect(sessionId, isA<String>(),
          reason: "Failed to get sessionId from login results");
      expect(profileId, isNotEmpty);
      expect(sessionId, isNotEmpty);

      print("User\n\t\t profile: $profileId\n\t\t session: $sessionId\n");

      // Call an api to validate the session is well and alive
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      expect(userSessionResp.statusCode, StatusCodes.ok,
          reason: "Failed to get attributes for user");

      print("\n Pre-Users Attributes: ${userSessionResp.data}\n");

      // kill the session from the other user
      ServerResponse response = await bcTest.bcWrapper.scriptService.runScript(
          scriptName: "LogoutSession",
          scriptData: {"profileId": profileId, "sessionId": sessionId});
      expect(response.statusCode, StatusCodes.ok,
          reason: "Failed to run script to logout session");
      print("LogoutSession returned: ${response.data}");

      // Now update the anonymousId to make the re-connect fail.
      userWrapper.setStoredAnonymousId("not-valid");
      userWrapper.authenticationService
          .initialize(profileId: profileId, anonymousId: "not-valid");

      // Call an api to validate the session has been terminated.
      userSessionResp = await userWrapper.playerStateService.getAttributes();
      print(
          "\nPost-Users Attributes: $userSessionResp  : ${userSessionResp.data}\n");

      expect(userSessionResp.statusCode, 403,
          reason: "Session should have been invalidated");
      expect(userSessionResp.reasonCode, ReasonCodes.playerSessionExpired,
          reason: "Resoncode should be userSessionExpired 40303");

      print("\nPost-Users Attributes: ${userSessionResp.data}\n");
    });
  });
}
