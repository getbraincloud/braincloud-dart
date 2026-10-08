// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

// Unlike the other authentication_test.dart, these don't hit a live server -
// they inspect the request queued by BrainCloudComms before dispatch, so we
// can assert on the exact JSON shape of an authenticate call.
void main() {
  group("Authentication appCheckToken", () {
    late BrainCloudClient client;

    setUp(() {
      client = BrainCloudClient(null);
      client.initialize(
          serverURL: "https://api.braincloudservers.com/dispatcherv2",
          secretKey: "secretKey",
          appId: "appId",
          appVersion: "1.0.0");
    });

    test("is forwarded unchanged when supplied", () {
      client.setAppCheckToken("the-app-check-token");

      client.authenticationService.authenticateUniversal(
          userId: "someUserId", password: "somePassword", forceCreate: false);

      var data = client.comms.serviceCallsWaiting.last.getJsonData!;
      expect(data["appCheckToken"], "the-app-check-token");
    });

    test("is omitted when not supplied, keeping today's exact request shape",
        () {
      client.authenticationService.authenticateUniversal(
          userId: "someUserId", password: "somePassword", forceCreate: false);

      var data = client.comms.serviceCallsWaiting.last.getJsonData!;
      expect(data.containsKey("appCheckToken"), isFalse);
      expect(
          data.keys.toSet(),
          {
            "externalId",
            "authenticationToken",
            "authenticationType",
            "forceCreate",
            "compressResponses",
            "profileId",
            "anonymousId",
            "gameId",
            "releasePlatform",
            "gameVersion",
            "clientLibVersion",
            "clientLib",
            "countryCode",
            "languageCode",
            "timeZoneOffset",
          });
    });

    test("provider is asked for a fresh token on every authenticate call",
        () async {
      var callCount = 0;
      client.setAppCheckTokenProvider(() async {
        callCount++;
        return "token-$callCount";
      });

      client.authenticationService.authenticateUniversal(
          userId: "someUserId", password: "somePassword", forceCreate: false);
      await Future.delayed(Duration.zero);
      expect(
          client.comms.serviceCallsWaiting.last.getJsonData!["appCheckToken"],
          "token-1");

      client.authenticationService.authenticateUniversal(
          userId: "someUserId", password: "somePassword", forceCreate: false);
      await Future.delayed(Duration.zero);
      expect(
          client.comms.serviceCallsWaiting.last.getJsonData!["appCheckToken"],
          "token-2");
    });

    test("provider takes priority over a stored appCheckToken", () async {
      client.setAppCheckToken("stale-token");
      client.setAppCheckTokenProvider(() async => "fresh-token");

      client.authenticationService.authenticateUniversal(
          userId: "someUserId", password: "somePassword", forceCreate: false);
      await Future.delayed(Duration.zero);

      expect(
          client.comms.serviceCallsWaiting.last.getJsonData!["appCheckToken"],
          "fresh-token");
    });
  });
}
