import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';
import 'utils/test_base.dart';
import 'dart:io' as io;

@override
main() async {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);
  const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

  group("Test Authentication", () {
    test("releasePlatform", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (kIsWeb) {
        expect(
            bcTest.bcWrapper.brainCloudClient.releasePlatform, PlatformID.web);
      } else {
        String platform = "LINUX";
        if (io.Platform.isIOS) platform = "IOS";
        if (io.Platform.isWindows) platform = "WINDOWS";
        if (io.Platform.isMacOS) platform = "MAC";
        if (io.Platform.isAndroid) platform = "ANG";

        expect(bcTest.bcWrapper.brainCloudClient.releasePlatform,
            PlatformID.fromString(platform));
      }
    });

    test("getServerVersion", () async {
      ServerResponse response = await bcTest.bcWrapper.authenticationService.getServerVersion();

      expect(response.statusCode, 200);
      expect(response.data?['serverVersion'], isA<String>());

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

      // exercise reauthenticate \
      expect(bcTest.bcWrapper.brainCloudClient.isAuthenticated(), true,
          reason: "Should be authenticated");
      await bcTest.bcWrapper.reauthenticate();
      expect(bcTest.bcWrapper.brainCloudClient.isAuthenticated(), true,
          reason: "Should be reauthenticated");
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
          username: userA.name, password: userA.password, forceCreate: true);
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    test("authenticateUniversal Bad PWD", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userA.name,
          password: userA.password + "make invalid",
          forceCreate: false);

      print(" $response ");

      expect(response.statusCode, 403);
      expect(
          response.error['status_message'],
          startsWith(
              "Processing exception (message): Token does not match user"));
    });
    test("authenticateUniversal Bad User", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      bcTest.bcWrapper.resetStoredProfileId();
      bcTest.bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcTest.bcWrapper.authenticateUniversal(
          username: userA.name + "make invalid",
          password: userA.password,
          forceCreate: false);

      expect(response.statusCode, 202);
      expect(
          response.error["status_message"],
          startsWith(
              "Processing exception (message): Missing profile, must force create."));
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

      response = await bcTest.bcWrapper.smartSwitchAuthenticateUniversal(
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

      response = await bcTest.bcWrapper.smartSwitchAuthenticateAdvanced(
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

      response = await bcTest.bcWrapper.smartSwitchAuthenticateEmail(
          email: userA.email, password: userA.password, forceCreate: true);
      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
      expect(response.data?['server_time'], isA<int>());
      expect(response.data?['createdAt'], isA<int>());
      expect(response.data?['isTester'], isA<bool>());
      expect(response.data?['currency'], isA<Object>());
    });

    test("testAuthenticateSpam", () {
      // our problem is that users who find they can't log in, will retry over and over until they have success. They do not change their credentials while doing this.
      // This threatens our servers, because huge numbers of errors related to the profileId not matching the anonymousId show up, as the user continues to have this retry.
      // Our goal is to stop this by checking to see if the call being made was an authentication call, then seeing if the attempted parameters for the authenticate were the
      // same. If they were, we know they're simply retrying, and retrying, and we can send a client error saying that the credentials have already been retried.

      //start test by initializing an anonymous Id and profileID
      // string anonId = _bc.Client.AuthenticationService.GenerateAnonymousId();
      // _bc.Client.AuthenticationService.Initialize("randomProfileId", anonId);

      // in this test we purposefully fail 4 times so that 3 identical call will have been made after the first
      // We then allow a fifth call to show that whenever a call is made it will simply hit the client with a fake response.
      // Then we freeze the test in a while loop for 30 seconds to wait out the comms timer.
      // then we call authenticate again and you will notice that a call will be made to the server and everything reset.

      //TODO: Complete the spam test  use C# as the template
    });

    test("authenticateHandoff", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runScript(scriptName: "createHandoffId");

      expect(response.statusCode, 200);

      String handoffId = response.data?['response']['handoffId'] ?? "";
      String securityToken = response.data?['response']['securityToken'] ?? "";

      expect(handoffId, isNotEmpty);
      expect(securityToken, isNotEmpty);

      response = await bcTest.bcWrapper.authenticationService
          .authenticateHandoff(
              handoffId: handoffId, securityToken: securityToken);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
    });

    test("authenticateSettopHandoff", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.scriptService
          .runScript(scriptName: "CreateSettopHandoffCode");

      expect(response.statusCode, 200);
      String handoffCode = response.data?['response']['handoffCode'] ?? "";
      expect(handoffCode, isNotEmpty);

      response = await bcTest.bcWrapper.authenticationService
          .authenticateSettopHandoff(handoffCode: handoffCode);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
    });

    // test("authenticateNintendo", () async {
    //         expect(bcTest.bcWrapper.isInitialized, true);

    //   ServerResponse response = await bcTest.bcWrapper
    //       .authenticateNintendo(accountId: "Dart_Tester", authToken: "acceptThis", forceCreate: true);

    //   expect(response.statusCode, 200);
    // });

    // test("authenticatePlaystation5", () async {
    //         expect(bcTest.bcWrapper.isInitialized, true);

    //   ServerResponse response = await bcTest.bcWrapper
    //       .authenticatePlaystation5(accountId: "Dart_Tester", authToken: "acceptThis", forceCreate: true);

    //   expect(response.statusCode, 200);
    // });

    // test("authenticateOculus", () async {
    //         expect(bcTest.bcWrapper.isInitialized, true);

    //   ServerResponse response = await bcTest.bcWrapper
    //       .authenticateOculus(oculusUserId: "Dart_Tester", oculusNonce: "acceptThis", forceCreate: true);

    //   expect(response.statusCode, 403);
    // });

    test("resetEmailPassword", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      String email = "braincloudunittest@gmail.com";

      ServerResponse response = await bcTest.bcWrapper
          .authenticateEmailPassword(
              email: email, password: email, forceCreate: true);

      response = await bcTest.bcWrapper.authenticationService
          .resetEmailPassword(emailAddress: email);

      expect(response.statusCode, 200);
    });

    test("resetEmailPasswordWithExpiry", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      String email = "braincloudunittest@gmail.com";

      ServerResponse response = await bcTest.bcWrapper
          .authenticateEmailPassword(
              email: email, password: email, forceCreate: true);

      response = await bcTest.bcWrapper.authenticationService
          .resetEmailPasswordWithExpiry(
              emailAddress: email, tokenTtlInMinutes: 1);

      expect(response.statusCode, 200);
    });

    test("resetEmailPasswordAdvanced", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      String email = "braincloudunittest@gmail.com";

      Map<String, dynamic> serviceParams = {
        "fromAddress": "fromAddress",
        "fromName": "fromName",
        "replyToAddress": "replyToAddress",
        "replyToName": "replyToName",
        "templateId": "8f14c77d-61f4-4966-ab6d-0bee8b13d090",
        "subject": "subject",
        "body": "Body goes here",
        "substitutions": {
          ":name": "John Doe",
          ":resetLink": "www.dummuyLink.io"
        },
        "categories": ["category1", "category2"]
      };
      ServerResponse response = await bcTest.bcWrapper
          .authenticateEmailPassword(
              email: email, password: email, forceCreate: true);

      response = await bcTest.bcWrapper.authenticationService
          .resetEmailPasswordAdvanced(
              emailAddress: email, serviceParams: serviceParams);

      expect(response.statusCode, 400);
      expect(response.reasonCode, ReasonCodes.invalidFromAddress);
    });

    test("resetEmailPasswordAdvancedWithExpiry", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      String email = "braincloudunittest@gmail.com";

      Map<String, dynamic> serviceParams = {
        "fromAddress": "fromAddress",
        "fromName": "fromName",
        "replyToAddress": "replyToAddress",
        "replyToName": "replyToName",
        "templateId": "8f14c77d-61f4-4966-ab6d-0bee8b13d090",
        "subject": "subject",
        "body": "Body goes here",
        "substitutions": {
          ":name": "John Doe",
          ":resetLink": "www.dummuyLink.io"
        },
        "categories": ["category1", "category2"]
      };

      ServerResponse response = await bcTest.bcWrapper
          .authenticateEmailPassword(
              email: email, password: email, forceCreate: true);

      response = await bcTest.bcWrapper.authenticationService
          .resetEmailPasswordAdvancedWithExpiry(
              emailAddress: email,
              serviceParams: serviceParams,
              tokenTtlInMinutes: 1);

      expect(response.statusCode, 400);
      expect(response.reasonCode, ReasonCodes.invalidFromAddress);
    });

    test("resetUniversalIdPassword", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // Tests normally login with userA as universal.
      ServerResponse response = await bcTest
          .bcWrapper.authenticationService
          .resetUniversalIdPassword(universalId: userA.name);

      expect(response.statusCode, isIn([409, 200]));
      if (response.statusCode != 200) {
        if (response.statusCode != 409)
          print('Unexpected: $response \n${response.data}');
        expect(response.reasonCode, ReasonCodes.emailIdNotFound);
      }
    });

    test("resetUniversalIdPasswordWithExpiry", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // Tests normally login with userA as universal.
      ServerResponse response = await bcTest
          .bcWrapper.authenticationService
          .resetUniversalIdPasswordWithExpiry(
              universalId: userA.name, tokenTtlInMinutes: 1);

      expect(response.statusCode, isIn([409, 200]));
      if (response.statusCode != 200) {
        if (response.statusCode != 409)
          print('Unexpected: $response \n${response.data}');
        expect(response.reasonCode, ReasonCodes.emailIdNotFound);
      }
    });

    test("resetUniversalIdPasswordAdvanced", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      Map<String, dynamic> serviceParams = {
        "templateId": "8f14c77d-61f4-4966-ab6d-0bee8b13d090",
        "substitutions": {
          ":name": "John Doe",
          ":resetLink": "www.dummuyLink.io"
        },
        "categories": ["category1", "category2"]
      };

      // Tests normally login with userA as universal.
      ServerResponse response = await bcTest
          .bcWrapper.authenticationService
          .resetUniversalIdPasswordAdvanced(
              universalId: userA.name, serviceParams: serviceParams);

      if (![409, 200].contains(response.statusCode))
        print('Unexpected: $response \n${response.data}');
      expect(response.statusCode, isIn([409, 200]));
    });

    test("resetUniversalIdPasswordAdvancedWithExpiry", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      Map<String, dynamic> serviceParams = {
        "templateId": "8f14c77d-61f4-4966-ab6d-0bee8b13d090",
        "substitutions": {
          ":name": "John Doe",
          ":resetLink": "www.dummuyLink.io"
        },
        "categories": ["category1", "category2"]
      };

      // Tests normally login with userA as universal.
      ServerResponse response = await bcTest
          .bcWrapper.authenticationService
          .resetUniversalIdPasswordAdvancedWithExpiry(
              universalId: userA.name,
              serviceParams: serviceParams,
              tokenTtlInMinutes: 1);

      if (![200, 409].contains(response.statusCode))
        print('Unexpected: $response \n${response.data}');

      expect(response.statusCode, isIn([409, 200]));
    });

    test("authenticateWithHeartbeat", () async {
      // In  order to send a heartbeat before loging in we create a new Wrapper as the bcTest is already logged-in;
      BrainCloudWrapper _bc =
          BrainCloudWrapper(wrapperName: "authenticateWithHeartbeat");
      await _bc.init(
          secretKey: bcTest.ids.secretKey,
          appId: bcTest.ids.appId,
          version: bcTest.ids.version,
          url: bcTest.ids.url,
          updateTick: 50);
      _bc.brainCloudClient.enableLogging(true);

      _bc.brainCloudClient.sendHeartbeat();
      _bc.brainCloudClient.sendHeartbeat();
      _bc.brainCloudClient.sendHeartbeat();

      ServerResponse response = await _bc.brainCloudClient.authenticationService
          .authenticateEmailPassword(
              email: userA.email, password: userA.password, forceCreate: true);

      expect(response.statusCode, 200);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });

  group("Un-Authenticated Tests", () {

    test("Server Version", () async {
      final BrainCloudWrapper bcWrapper = await BrainCloudWrapper(wrapperName: "srvVersion");

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

      ServerResponse response = await bcWrapper.authenticationService.getServerVersion();

      print("ServerVersion response: $response,   ${response.data}");
      expect(response.statusCode, 200);
      expect(response.data?['serverVersion'],isA<String>());
    });


  });
}
