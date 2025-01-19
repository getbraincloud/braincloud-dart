import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();

  setUpAll(bcTest.setupBC);

  group("Test Match Making", () {
    test("disableMatchMaking()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.disableMatchMaking();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("enableMatchMaking()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.enableMatchMaking();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("read()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.read();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("setPlayerRating()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .setPlayerRating(playerRating: 150);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("resetPlayerRating()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.resetPlayerRating();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementPlayerRating()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .incrementPlayerRating(increment: 25);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("decrementPlayerRating()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .decrementPlayerRating(decrement: 25);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("turnShieldOn()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.turnShieldOn();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("turnShieldOff()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.matchMakingService.turnShieldOff();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("turnShieldOnFor()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .turnShieldOnFor(minutes: 60);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementShieldOnFor()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .incrementShieldOnFor(minutes: 60);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findPlayers()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .findPlayers(rangeDelta: 100, numMatches: 5);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findPlayersWithAttributes()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .findPlayersWithAttributes(
              rangeDelta: 100, numMatches: 5, jsonAttributes: {"test": "test"});
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getShieldExpiry()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .getShieldExpiry(playerId: userB.profileId!);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findPlayersUsingFilter()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .findPlayersUsingFilter(
              rangeDelta: 100, numMatches: 5, jsonExtraParms: {"test": "test"});
      expect(response.statusCode, StatusCodes.ok);
    });

    test("findPlayersWithAttributesUsingFilter()", () async {
      ServerResponse response = await bcTest.bcWrapper.matchMakingService
          .findPlayersWithAttributesUsingFilter(
              rangeDelta: 100,
              numMatches: 5,
              jsonExtraParms: {"test": "test"},
              jsonAttributes: {"test": "test"});

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
