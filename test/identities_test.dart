import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Identities Tests", () {
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
      if (checks.statusCode == 200 && checks.data != null) {
        Map<String, dynamic> body = checks.data!;
        if (body['identities']['Email'] != null) {
          checks = await bcTest.bcWrapper.identityService.detachEmailIdentity(
              email: body['identities']['Email'], continueAnon: true);
        }
      }

      ServerResponse response = await bcTest.bcWrapper.identityService
          .mergeEmailIdentity(email: userC.email, password: userC.password);

      expect(response.statusCode, 200, reason: response.statusMessage);
      // expect(response.body, isNull);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
