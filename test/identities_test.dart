import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';
import 'utils/test_users.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBCwithChild);

  Future<bool> _gotoChildProfile() async {
    ServerResponse response = await bcTest.bcWrapper.identityService
        .switchToSingletonChildProfile(
            childAppId: bcTest.ids.childAppId, forceCreate: true);

    if (response.statusCode == 200) {
      return true;
    }
    ;
    debugPrint(
        '🚨 Error while _gotoChildProfile: $response, \n ${response.data}');
    return false;
  }

  Future<bool> _detachParent() async {
    ServerResponse response =
        await bcTest.bcWrapper.identityService.detachParent();
    if (response.statusCode == 200) {
      return true;
    }
    ;
    debugPrint('🚨 Error while _detachParent: $response, \n ${response.data}');
    return false;
  }

  Future<bool> _detachPeer() async {
    ServerResponse response = await bcTest.bcWrapper.identityService
        .detachPeer(peer: bcTest.ids.peerName);
    if (response.statusCode == 200) {
      return true;
    }
    ;
    debugPrint('🚨 Error while _detachPeer: $response, \n ${response.data}');
    return false;
  }

  group("Identities Tests", () {

    String attachableIdentity = "dart_${generateRandomString(8)}_${userA.email}";

    setUp(() async {
      // ensure we are loggedin the
      if (bcTest.bcWrapper.brainCloudClient.appId != bcTest.ids.appId) {
        await bcTest.bcWrapper.identityService
            .switchToParentProfile(parentLevelName: bcTest.ids.parentLevelName);
      }
      await bcTest.bcWrapper.authenticateUniversal(
          username: userA.name, password: userA.password, forceCreate: false);
    });

    test("getExpiredIdentities", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.identityService.getExpiredIdentities();

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['identities'], isMap);
      }
    });

    test("getIdentities", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.identityService.getIdentities();

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['identities'], isMap);
        expect(body['identities']['Universal'], userA.name.toLowerCase());
      }
    });

    test("attachEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachEmailIdentity(email: userA.email, password: userA.password);

      expect(response.statusCode, isIn([StatusCodes.ok, StatusCodes.accepted]));
      // expect(response.body, isMAp);
    });

    test("detachEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.identityService
          .detachEmailIdentity(email: userA.email, continueAnon: true);

      expect(response.statusCode, isIn([StatusCodes.ok, StatusCodes.accepted]));
      // expect(response.body, isNull);
    });

    test("mergeEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // if there is already a email identity detach it
      ServerResponse checks =
          await bcTest.bcWrapper.identityService.getIdentities();
      if (checks.statusCode == 200 && checks.data != null) {
        Map<String, dynamic> body = checks.data!;
        if (body['identities']['Email'] != null) {
          checks = await bcTest.bcWrapper.identityService.detachEmailIdentity(
              email: body['identities']['Email'], continueAnon: true);
        }
      }

      ServerResponse response = await bcTest.bcWrapper.identityService
          .mergeEmailIdentity(email: userC.email, password: userC.password);

      expect(response.statusCode, anyOf([200, 202]),
          reason: response.error);
      // expect(response.body, isNull);
    });

    test("switchToChildProfile", () async {
      ServerResponse response =
          await bcTest.bcWrapper.identityService.switchToChildProfile(
              // childProfileId: null,
              childAppId: bcTest.ids.childAppId,
              forceCreate: true);

      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
    });
   
    test("switchToSingletonChildProfile", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .switchToSingletonChildProfile(
              childAppId: bcTest.ids.childAppId, forceCreate: true);

      if (response.statusCode != 200)
        debugPrint(
            ":switchToSingletonChildProfile returned $response     \n${response.data}");

      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
    });

    test("switchToParentProfile", () async {
      if (!await _gotoChildProfile())
        fail("Could not preemptively swith to child profile.");

      ServerResponse response =
          await bcTest.bcWrapper.identityService.switchToParentProfile(
        parentLevelName: bcTest.ids.parentLevelName,
      );

      if (response.statusCode != 200)
        debugPrint(
            ":switchToParentProfile returned $response     \n${response.data}");

      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
    });

    test("detachParent", () async {
      if (!await _gotoChildProfile())
        fail("Could not preemptively swith to child profile.");

      ServerResponse response =
          await bcTest.bcWrapper.identityService.detachParent();

      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
    });

    test("attachParentWithIdentity", () async {
      bcTest.dispose();
      await bcTest.setupBCwithChild();

      if (!await _gotoChildProfile())
        fail("Could not preemptively swith to child profile.");
      if (!await _detachParent())
        fail("Could not preemptively detach from parent.");


      // ServerResponse response =
      //     await bcTest.bcWrapper.identityService.detachParent();

      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachParentWithIdentity(
              externalId: userB.email,
              authenticationToken: userB.password,
              authenticationType: AuthenticationType.universal,
              forceCreate: true);

      if (response.statusCode != 200)
        debugPrint(
            ":attachParentWithIdentity returned $response     \n${response.data}");

      expect(response.statusCode, 200);
      expect(response.data?['profileId'], isA<String>());
    });

    test("getChildProfiles", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .getChildProfiles(includeSummaryData: true);

      if (response.statusCode != 200)
        debugPrint(
            ":getChildProfiles returned $response     \n${response.data}");

      expect(response.statusCode, 200);
      expect(response.data?['children'], isA<List>());
    });

    test("attachEmailIdentity", () async {
      ServerResponse response =
          await bcTest.bcWrapper.identityService.attachEmailIdentity(
        email: "dart_${userA.email}",
        password: userA.password,
      );

      if (response.statusCode == 200) {
        expect(response.statusCode, 200);
      } else {
        expect(response.statusCode, 202);
        expect(response.reasonCode, ReasonCodes.duplicateIdentityType);
      }

      // expect(response.data?['profileId'], isA<String>());
    });

    test("getIdentities", () async {
      ServerResponse response =
          await bcTest.bcWrapper.identityService.getIdentities();

      if (response.statusCode != 200)
        debugPrint(":getIdentities returned $response     \n${response.data}");

      expect(response.statusCode, 200);
      expect(response.data?['children'], isA<List?>());
    });

    test("getExpiredIdentities", () async {
      ServerResponse response =
          await bcTest.bcWrapper.identityService.getExpiredIdentities();

      expect(response.statusCode, 200);
      expect(response.data?['identities'], isA<Map>());
    });

    test("refreshIdentity", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .refreshIdentity(
              externalId: userA.name,
              authenticationToken: userA.password,
              authenticationType: AuthenticationType.universal);

      expect(response.statusCode, 400);
      expect(response.reasonCode, ReasonCodes.unsupportedAuthType);
    });

    test("changeEmailIdentity", () async {
      final String _uniqueToken ="${(DateTime.now().millisecondsSinceEpoch / 60000).floor()}";
      final String _newEmail = "dart_${_uniqueToken}_new@bitheads.com";
      final String _oldEmail = "dart_${_uniqueToken}_old@bitheads.com";
      final String _password = generateRandomString(9);

      ServerResponse response = await bcTest.bcWrapper
          .authenticateEmailPassword(
              email: _oldEmail, password: _password, forceCreate: true);

      //expected that the old e-mail randomly generated isn't already associated with the profile.
      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.identityService.changeEmailIdentity(
          oldEmailAddress: _oldEmail,
          password: _password,
          newEmailAddress: _newEmail,
          updateContactEmail: true);

      print("Failed to change Email identity from ${_oldEmail} to ${_newEmail}");
      expect(response.statusCode, 200);

      // Return to default user for next test.
      await bcTest.bcWrapper.authenticateUniversal(
          username: userA.name, password: userA.password, forceCreate: false);
    });

    test("attachPeerProfile", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachPeerProfile(
              peer: bcTest.ids.peerName,
              externalId: "${userA.name}_peer",
              authenticationToken: userA.password,
              authenticationType: AuthenticationType.universal,
              forceCreate: true);

      expect(response.statusCode, 200);

      await _detachPeer();
      // expect(response.data?['identities'], isA<Map>());
    });

    test("getPeerProfiles", () async {
      ServerResponse response =
          await bcTest.bcWrapper.identityService.getPeerProfiles();

      if (response.statusCode != 200)
        debugPrint('getPeerProfiles: ${response.data}');

      expect(response.statusCode, 200);
    });

    test("detachPeer", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .detachPeer(peer: bcTest.ids.peerName);

      expect(response.statusCode, 200);
    });

    test("attachNonLoginUniversalId", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachNonLoginUniversalId(externalId: "non_login_dart@bitheads.com");

      expect(response.statusCode, 202);
      expect(response.reasonCode, ReasonCodes.duplicateIdentityType);
    });

    test("updateUniversalIdLogin", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .updateUniversalIdLogin(externalId: "non_login_dart@bitheads.com");

      if (response.statusCode != 400)
        debugPrint('updateUniversalIdLogin: $response \n ${response.data}');

      expect(response.statusCode, 400);
      expect(response.reasonCode, ReasonCodes.newCredentialInUse);
    });

    test("attachAndDetachBlockchain", () async {
      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachBlockChainIdentity(
              blockchainConfig: "config", publicKey: "ehhhwwwhhhhh2");

      expect(response.statusCode, 200);

      response = await bcTest.bcWrapper.identityService
          .detachBlockChainIdentity(blockchainConfig: "config");

      expect(response.statusCode, 200);
    });


    test("attachAdvancedIdentity", () async {

      AuthenticationIds authIds = AuthenticationIds(attachableIdentity,userA.password,"");
      
      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachAdvancedIdentity(
            authenticationType: AuthenticationType.email, 
            ids: authIds);

      if (response.statusCode == 200) {
        expect(response.statusCode, 200);
      } else {
        expect(response.statusCode, 202);
        expect(response.reasonCode, ReasonCodes.duplicateIdentityType);
      }
    });

    test("detachAdvancedIdentity", () async {

      
      ServerResponse response = await bcTest.bcWrapper.identityService
          .detachAdvancedIdentity(
            authenticationType: AuthenticationType.email, 
            externalId: attachableIdentity, 
            continueAnon: false);

      if (response.statusCode == 200) {
        expect(response.statusCode, 200);
      } else {
        expect(response.statusCode, 202);
        expect(response.reasonCode, ReasonCodes.missingIdentityError);
      }
    });

    test("mergeAdvancedIdentity", () async {

      AuthenticationIds authIds = AuthenticationIds(userC.email,userC.password,"");

      ServerResponse response = await bcTest.bcWrapper.identityService
          .mergeAdvancedIdentity(
            authenticationType: AuthenticationType.email, 
            ids: authIds);

      if (response.statusCode == 200) {
        expect(response.statusCode, 200);
      } else {
        expect(response.statusCode, 202);
        expect(response.reasonCode, ReasonCodes.duplicateIdentityType);
      }
    });
    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
