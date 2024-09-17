import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'test_base.dart';
import 'test_users.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  TestUser userA = TestUser("userA", generateRandomString(8));
  TestUser userB = TestUser("UserB", generateRandomString(8));

  var userToAuth = userA;
  var testData = {"test": 1234};

  String groupId = "";
  var entityId = "";

  Future<ServerResponse> reAuth() {
    return bcTest.bcWrapper.authenticateUniversal(
        username: userToAuth.name,
        password: userToAuth.password,
        forceCreate: true);
  }

  group("Test Group", () {
    setUp(() async {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.logout();
      }

      ServerResponse userB_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userB.name,
              password: userB.password,
              forceCreate: true);

      userB.profileId = userB_response.body?["profileId"];

      ServerResponse userA_response = await bcTest.bcWrapper
          .authenticateUniversal(
              username: userA.name,
              password: userA.password,
              forceCreate: true);

      userA.profileId = userA_response.body?["profileId"];
    });

    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          jsonData: jsonEncode({"test": "asdf"}));

      groupId = response.body?["data"]["groupId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("createGroupWithSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .createGroupWithSummaryData(
              name: "test",
              groupType: "test",
              isOpenGroup: false,
              jsonOwnerAttributes: jsonEncode({"test": "asdf"}),
              jsonSummaryData: jsonEncode({"summary": "asdf"}));

      groupId = response.body?["data"]["groupId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroupData()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.groupService.readGroupData(groupId: groupId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("addGroupMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .addGroupMember(
              groupId: groupId, profileId: userB.profileId!, role: Role.member);

      expect(response.statusCode, StatusCodes.ok);
      userToAuth = userB;
    });

    test("leaveGroup()", () async {
      await reAuth();

      ServerResponse response =
          await bcTest.bcWrapper.groupService.leaveGroup(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("inviteGroupMember()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.groupService.inviteGroupMember(
        groupId: groupId,
        profileId: userB.profileId!,
        role: Role.member,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    test("cancelGroupInvitation()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .cancelGroupInvitation(groupId: groupId, profileId: userB.profileId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("inviteGroupMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .inviteGroupMember(
              groupId: groupId, profileId: userB.profileId!, role: Role.member);

      userToAuth = userB;
      expect(response.statusCode, StatusCodes.ok);
    });

    test("rejectGroupInvitation()", () async {
      await reAuth();

      ServerResponse response = await bcTest.bcWrapper.groupService
          .rejectGroupInvitation(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("inviteGroupMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .inviteGroupMember(
              groupId: groupId, profileId: userB.profileId!, role: Role.member);

      userToAuth = userB;

      expect(response.statusCode, StatusCodes.ok);
    });

    test("acceptGroupInvitation()", () async {
      await reAuth();
      ServerResponse response = await bcTest.bcWrapper.groupService
          .acceptGroupInvitation(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("removeGroupMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .removeGroupMember(groupId: groupId, profileId: userB.profileId!);

      userToAuth = userB;

      expect(response.statusCode, StatusCodes.ok);
    });

    test("joinGroup()", () async {
      await reAuth();

      ServerResponse response =
          await bcTest.bcWrapper.groupService.joinGroup(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("rejectGroupJoinRequest()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .rejectGroupJoinRequest(
              groupId: groupId, profileId: userB.profileId!);

      userToAuth = userB;
      expect(response.statusCode, StatusCodes.ok);
    });

    test("joinGroup()", () async {
      await reAuth();

      ServerResponse response =
          await bcTest.bcWrapper.groupService.joinGroup(groupId: groupId);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("approveGroupJoinRequest()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .approveGroupJoinRequest(
              groupId: groupId, profileId: userB.profileId!, role: Role.member);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("createGroupEntity()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .createGroupEntity(
              groupId: groupId,
              entityType: "test",
              isOwnedByGroupMember: false,
              jsonData: jsonEncode(testData));

      entityId = response.body?["data"]["entityId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroupEntity()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupEntity(groupId: groupId, entityId: entityId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupEntityData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupEntityData(
              groupId: groupId,
              entityId: entityId,
              version: 1,
              jsonData: jsonEncode(testData));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementGroupEntityData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .incrementGroupEntityData(
              groupId: groupId,
              entityId: entityId,
              jsonData: jsonEncode(testData));
      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroupEntity()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.groupService.deleteGroupEntity(
        groupId: groupId,
        entityId: entityId,
        version: -1,
      );

      expect(response.statusCode, StatusCodes.ok);
    });

    var entityContext = {
      "pagination": {"rowsPerPage": 50, "pageNumber": 1},
      "searchCriteria": {"groupId": groupId, "entityType": "test"}
    };

    var entityReturnedContext;

    test("readGroupEntitiesPage()", () async {
      entityContext["searchCriteria"]?["groupId"] = groupId;

      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupEntitiesPage(jsonContext: jsonEncode(entityContext));

      entityReturnedContext = response.body?["data"]["context"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroupEntitiesPageByOffset()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupEntitiesPageByOffset(
              encodedContext: entityReturnedContext, pageOffset: 1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupData(
              groupId: groupId, version: -1, jsonData: jsonEncode(testData));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementGroupData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .incrementGroupData(groupId: groupId, jsonData: jsonEncode(testData));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupName()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupName(groupId: groupId, name: "testName");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getMyGroups()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.groupService.getMyGroups();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("listGroupsWithMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .listGroupsWithMember(profileId: userA.profileId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    var groupContext = {
      "pagination": {"rowsPerPage": 50, "pageNumber": 1},
      "searchCriteria": {"groupType": "test"}
    };
    var groupReturnedContext;

    test("listGroupsPage()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .listGroupsPage(jsonContext: jsonEncode(groupContext));

      groupReturnedContext = response.body?["data"]["context"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("listGroupsPageByOffset()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .listGroupsPageByOffset(context: groupReturnedContext, pageOffset: 1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroup()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.groupService.readGroup(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroupMembers()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupMembers(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupMember()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupMember(groupId: groupId, profileId: userA.profileId!);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("setGroupOpen()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .setGroupOpen(groupId: groupId, isOpenGroup: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: groupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: true,
          jsonData: jsonEncode({"test": "asdf"}));

      groupId = response.body?["data"]["groupId"];
      userToAuth = userB;
      expect(response.statusCode, StatusCodes.ok);
    });

    test("autoJoinGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .autoJoinGroup(
              groupType: "test",
              autoJoinStrategy: AutoJoinStrategy.joinFirstGroup);

      expect(response.statusCode, StatusCodes.ok);
    });

    var groupTypes = ["test"];

    test("autoJoinGroupMulti()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .autoJoinGroupMulti(
              groupTypes: groupTypes,
              autoJoinStrategy: AutoJoinStrategy.joinFirstGroup);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetRandomGroupsMatching()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .getRandomGroupsMatching(
              jsonWhere: jsonEncode({"groupType": "BLUE"}), maxReturn: 20);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("UpdateGroupSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupSummaryData(
              groupId: groupId,
              version: 1,
              jsonSummaryData: jsonEncode({"summary": "asdf"}));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: groupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    var testGroupId = "";

    completeDeleteGroupJoinRequestTest() {
      bcTest.bcWrapper.logout(forgetUser: true).then((response) {
        bcTest.bcWrapper
            .authenticateUniversal(
                username: "JS-Tester1",
                password: "JS-Tester1",
                forceCreate: false)
            .then((response) {
          bcTest.bcWrapper.groupService
              .deleteGroup(groupId: testGroupId, version: -1)
              .then((response) {
            expect(response.statusCode, StatusCodes.ok);

            bcTest.bcWrapper.logout(forgetUser: true).then(
                (response) => expect(response.statusCode, StatusCodes.ok));
          });
        });
      });
    }

    testDeleteGroupJoinRequest() {
      var groupJoinRequestExists = false;

      bcTest.bcWrapper
          .authenticateUniversal(
              username: "JS-Tester2", password: "JS-Tester2", forceCreate: true)
          .then((response) {
        debugPrint("Authenticated group tester");

        bcTest.bcWrapper.groupService
            .joinGroup(groupId: testGroupId)
            .then((response) {
          bcTest.bcWrapper.groupService.getMyGroups().then((response) {
            var requestedGroups = response.body?["data"]["requested"];
            requestedGroups.forEach((requestedGroup) => {
                  if (requestedGroup.groupId == testGroupId)
                    {groupJoinRequestExists = true}
                });

            if (groupJoinRequestExists) {
              debugPrint("Group Join Request exists");

              // Reset for second check
              groupJoinRequestExists = false;

              bcTest.bcWrapper.groupService
                  .deleteGroupJoinRequest(groupId: testGroupId)
                  .then((response) {
                bcTest.bcWrapper.groupService.getMyGroups().then((response) {
                  requestedGroups = response.body?["data"]["requested"];
                  requestedGroups.forEach((requestedGroup) {
                    if (requestedGroup.groupId == testGroupId) {
                      groupJoinRequestExists = true;
                    }
                  });

                  if (groupJoinRequestExists) {
                    expect(groupJoinRequestExists, true);
                  } else {
                    debugPrint("Group Join Request no longer exists");

                    completeDeleteGroupJoinRequestTest();
                  }
                });
              });
            } else {
              expect(groupJoinRequestExists, true);
            }
          });
        });
      });
    }

    setupGroupForTest() async {
      await bcTest.bcWrapper.authenticateUniversal(
          username: "JS-Tester1", password: "JS-Tester1", forceCreate: true);

      debugPrint("Authenticated group creator");

      var name = "JS-Test-ClosedGroup";
      var groupType = "test";
      var isOpenGroup = false;
      GroupACL acl = GroupACL(Access.readWrite, Access.none);

      var jsonData = {};
      var ownerAttributes = {};
      var defaultMemberAttributes = {};

      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: name,
          groupType: groupType,
          isOpenGroup: isOpenGroup,
          acl: acl,
          jsonData: jsonEncode(jsonData),
          jsonOwnerAttributes: jsonEncode(ownerAttributes),
          jsonDefaultMemberAttributes: jsonEncode(defaultMemberAttributes));

      if (response.statusCode == StatusCodes.ok) {
        debugPrint("Group created");

        testGroupId = response.body?["data"]["groupId"];

        bcTest.bcWrapper.logout().then((_) {
          testDeleteGroupJoinRequest();
        });
      } else {
        debugPrint("Failed to create group");
      }
    }

    test("deleteGroupJoinRequest()", () {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        bcTest.bcWrapper.playerStateService
            .logout()
            .then((_) => setupGroupForTest());
      } else {
        setupGroupForTest();
      }
    });
  });
}
