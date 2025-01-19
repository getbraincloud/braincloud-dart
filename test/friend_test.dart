import 'package:braincloud/braincloud.dart';
import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);
  String? _friendId;

  group("Test Friend", () {
    

    test("getProfileInfoForCredential()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getProfileInfoForCredentialIfExists(
              externalId: userA.name,
              authenticationType: AuthenticationType.universal);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getProfileInfoForExternalAuthId()", retry: 2, () async {
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getProfileInfoForExternalAuthIdIfExists(
              externalId: "externalId",
              externalAuthType: "Test");

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("getExternalIdForProfileId()", retry: 2, () async {
      var authenticationType = AuthenticationType.facebook;
      ServerResponse response = await bcTest.bcWrapper.friendService
          .getExternalIdForProfileId(
              profileId: userA.profileId!,
              authenticationType: authenticationType);

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

  test("addFriends()", () async {
    var ids = [userB.profileId!];
    ServerResponse response =
        await bcTest.bcWrapper.friendService.addFriends(profileIds: ids);

    expect(response.statusCode, StatusCodes.ok);
    _friendId = userB.profileId;
  });

  test("addFriendsFromPlatform()",  () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .addFriendsFromPlatform(
            friendPlatform: FriendPlatform.facebook,
            mode: "ADD",
            externalIds: []);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("listFriends()",  () async {
    ServerResponse response = await bcTest.bcWrapper.friendService.listFriends(
        friendPlatform: FriendPlatform.all, includeSummaryData: false);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("getMySocialInfo()", () async {
    ServerResponse response = await bcTest.bcWrapper.friendService
        .getMySocialInfo(
            friendPlatform: FriendPlatform.facebook, includeSummaryData: false);

    expect(response.statusCode, StatusCodes.ok);
  });

  test("readFriendEntity()", () async {
    if (_friendId ==  null || _friendId!.isEmpty) {       
        if ((await bcTest.bcWrapper.friendService.addFriends(profileIds: [userB.profileId!])).statusCode == 200) {
          _friendId = userB.profileId!;
        } else {
          markTestSkipped("cannot set Friend for test");
          return;
        }
    }
    ServerResponse response = await bcTest.bcWrapper.friendService
        .readFriendEntity(entityId: "",friendId: userB.profileId!);
            
    expect(response.statusCode, StatusCodes.ok);
  });

  test("readFriendUserState()", () async {
    if (_friendId ==  null || _friendId!.isEmpty) {       
        if ((await bcTest.bcWrapper.friendService.addFriends(profileIds: [userB.profileId!])).statusCode == 200) {
          _friendId = userB.profileId!;
        } else {
          markTestSkipped("cannot set Friend for test");
          return;
        }
    }
    ServerResponse response = await bcTest.bcWrapper.friendService
        .readFriendUserState(friendId: _friendId!);
            
    expect(response.statusCode, StatusCodes.ok);
  });


  test("readFriendsEntities()", retry: 2, () async {
    if (_friendId ==  null || _friendId!.isEmpty) {       
        if ((await bcTest.bcWrapper.friendService.addFriends(profileIds: [userB.profileId!])).statusCode == 200) {
          _friendId = userB.profileId!;
        } else {
          markTestSkipped("cannot set Friend for test");
          return;
        }
    }
    ServerResponse response = await bcTest.bcWrapper.friendService
        .readFriendsEntities(entityType: "Test");
            
    expect(response.statusCode, StatusCodes.ok);
  });

  test("removeFriends()", retry: 2, () async {
    // var ids = [userB.profileId!];
    if (_friendId ==  null || _friendId!.isEmpty) {       
        if ((await bcTest.bcWrapper.friendService.addFriends(profileIds: [userB.profileId!])).statusCode == 200) {
          _friendId = userB.profileId!;
        } else {
          markTestSkipped("cannot set Friend for test");
          return;
        }
    }
    ServerResponse response =
        await bcTest.bcWrapper.friendService.removeFriends(profileIds: [_friendId!]);

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
        .findUserByExactUniversalId(universalId: "completelyRandomUniversalId");

    expect(response.statusCode, StatusCodes.ok);
  });




  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
