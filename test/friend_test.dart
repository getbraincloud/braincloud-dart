import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Friend", () {
    test("getProfileInfoForCredential()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getProfileInfoForCredential(
              externalId: userA.name,
              authenticationType: AuthenticationType.universal);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getProfileInfoForExternalAuthId()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getProfileInfoForExternalAuthId(
              externalId: "externalId",
              externalAuthType: AuthenticationType.facebook);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getExternalIdForProfileId()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getExternalIdForProfileId(
              profileId: userA.profileId!,
              authenticationType: AuthenticationType.facebook);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSummaryDataForProfileId()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getSummaryDataForProfileId(profileId: userA.profileId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("findUsersByExactName()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .findUsersByExactName(searchText: "NotAUser", maxResults: 10);

      expect(response.statusCode, StatusCodes.ok);
    });
  });

  test("findUsersBySubstrName()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .findUsersBySubstrName(searchText: "NotAUser", maxResults: 10);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("addFriends()", retry: 2, () async {
    var ids = [userB.profileId!];
    ServerResponse response =
        await bcTest.bcWrapper.friendService.addFriends(profileIds: ids);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("addFriendsFromPlatform()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .addFriendsFromPlatform(
            friendPlatform: FriendPlatform.facebook,
            mode: "ADD",
            externalIds: []);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("listFriends()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService.listFriends(
        friendPlatform: FriendPlatform.all, includeSummaryData: false);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("getMySocialInfo()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .getMySocialInfo(
            friendPlatform: FriendPlatform.all, includeSummaryData: false);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("removeFriends()", retry: 2, () async {
    var ids = [userB.profileId!];
    ServerResponse response =
        await bcTest.bcWrapper.friendService.removeFriends(profileIds: ids);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("getUsersOnlineStatus()", retry: 2, () async {
    var ids = [userB.profileId!];
    ServerResponse response = await bcTest.bcWrapper.friendService
        .getUsersOnlineStatus(profileIds: ids);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("findUsersByUniversalIdStartingWith()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .findUsersByUniversalIdStartingWith(
            searchText: "completelyRandomName", maxResults: 30);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("findUsersByNameStartingWith()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .findUsersByNameStartingWith(
            searchText: "completelyRandomUniversalId", maxResults: 30);

    expect(response.statusCode, StatusCodes.ok);
  });

  //still needs to be added.
  test("finduserbyExactUniversalId()", retry: 2, () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .findUserByExactUniversalId(searchText: "completelyRandomUniversalId");

    expect(response.statusCode, StatusCodes.ok);
  });

  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
