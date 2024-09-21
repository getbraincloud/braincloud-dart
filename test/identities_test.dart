import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';
import 'utils/test_users.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Identities Tests", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));
    TestUser userB = TestUser("UserB", generateRandomString(8));
    TestUser userC = TestUser("UserC", generateRandomString(8));

    setUp(() async {
      if (!bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.authenticateEmailPassword(
            email: userC.email, password: userC.password, forceCreate: true);

        await bcTest.bcWrapper.authenticateUniversal(
            username: userB.name, password: userB.password, forceCreate: true);
      }
    });

    // end test

    test("getExpiredIdentities", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.identityService.getExpiredIdentities();

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['identities'], isMap);
      }
    });

    test("getIdentities", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.identityService.getIdentities();

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['identities'], isMap);
        expect(body['identities']['Universal'], userB.name.toLowerCase());
      }
    });

    test("attachEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.identityService
          .attachEmailIdentity(email: userA.email, password: userA.password);

      expect(response.statusCode, 200);
      // expect(response.body, isMAp);
    });

    test("detachEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.identityService
          .detachEmailIdentity(email: userA.email, continueAnon: true);

      expect(response.statusCode, 200);
      // expect(response.body, isNull);
    });

    test("mergeEmailIdentity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // if there is already a email identity detach it
      ServerResponse checks =
          await bcTest.bcWrapper.identityService.getIdentities();
      if (checks.statusCode == 200 && checks.body != null) {
        Map<String, dynamic> body = checks.body!;
        if (body['identities']['Email'] != null) {
          checks = await bcTest.bcWrapper.identityService.detachEmailIdentity(
              email: body['identities']['Email'], continueAnon: true);
        }
      }

      ServerResponse response = await bcTest.bcWrapper.identityService
          .mergeEmailIdentity(email: userC.email, password: userC.password);

      expect(response.statusCode, 200);
      // expect(response.body, isNull);
    });

    /// END TEST
    test("Dispose", () {
      bcTest.dispose();
    });
  });
}
