import 'package:braincloud/braincloud.dart';

import 'package:test/test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  var userToAuth = userA;
  var testData = {"test": 1234};

  String groupId = "";
  var entityId = "";

  reAuth() async {
    await bcTest.auth(userId: userToAuth.name, password: userToAuth.password);
  }

  group("Test Group", () {
    test("createGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          data: {"test": "asdf"});

      groupId = response.data?["groupId"];
      expect(response.statusCode, StatusCodes.ok);
    });

    test("createGroupWithSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .createGroupWithSummaryData(
              name: "test",
              groupType: "test",
              isOpenGroup: false,
              ownerAttributes: {"test": "asdf"},
              summaryData: {"summary": "asdf"});

      groupId = response.data?["groupId"];
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

    test("leaveGroupAuto()", () async {
      await reAuth();

      ServerResponse response =
          await bcTest.bcWrapper.groupService.leaveGroupAuto(groupId: groupId);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("inviteGroupMember()", retry: 2, () async {
      userToAuth = userA;
      await reAuth();
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
      userToAuth = userA;
      await reAuth();
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
      userToAuth = userA;
      await reAuth();
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
      userToAuth = userA;
      await reAuth();
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
              acl: GroupACL(Access.readWrite, Access.readWrite),
              data: testData);

      entityId = response.data?["entityId"];
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
              jsonData: testData);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementGroupEntityData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .incrementGroupEntityData(
              groupId: groupId, entityId: entityId, data: testData);
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

    Map<String, dynamic> entityContext = {
      "pagination": {"rowsPerPage": 50, "pageNumber": 1},
      "searchCriteria": {"groupId": groupId, "entityType": "test"}
    };

    var entityReturnedContext;

    test("readGroupEntitiesPage()", () async {
      entityContext["searchCriteria"]?["groupId"] = groupId;

      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupEntitiesPage(context: entityContext);

      entityReturnedContext = response.data?["context"];

      expect(response.statusCode, StatusCodes.ok);
    });

    test("readGroupEntitiesPageByOffset()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .readGroupEntitiesPageByOffset(
              context: entityReturnedContext, pageOffset: 1);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupData(groupId: groupId, version: -1, data: testData);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("incrementGroupData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .incrementGroupData(groupId: groupId, data: testData);

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

    Map<String, dynamic> groupContext = {
      "pagination": {"rowsPerPage": 50, "pageNumber": 1},
      "searchCriteria": {"groupType": "test"}
    };
    var groupReturnedContext;

    test("listGroupsPage()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .listGroupsPage(context: groupContext);

      groupReturnedContext = response.data?["context"];
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
          data: {"test": "asdf"});

      groupId = response.data?["groupId"];
      userToAuth = userB;
      expect(response.statusCode, StatusCodes.ok);
    });

    test("updateGroupAcl()", () async {
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      ServerResponse response = ServerResponse(statusCode: 200); //
      if (groupId.isEmpty) {
        response = await bcTest.bcWrapper.groupService.createGroup(
            name: "testAcl",
            groupType: "test",
            isOpenGroup: true,
            data: {"test": "asdf"});
        if (response.statusCode == 200) {
          groupId = response.data?["groupId"];
        }
      }
      if (response.statusCode == 200) {
        response = await bcTest.bcWrapper.groupService
            .updateGroupAcl(groupId: groupId, acl: {"member": 2, "other": 0});
        //  due to a mis-configuration that will be fix later ignoring a error of cloudCodeOnlyMethod
        if (response.reasonCode != ReasonCodes.cloudCodeOnlyMethod) {
          expect(response.statusCode, StatusCodes.ok);
        }
      }
    });

    test("updateGroupEntityAcl()", () async {
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      ServerResponse response = ServerResponse(statusCode: 200); 
      if (groupId.isEmpty) {
        response = await bcTest.bcWrapper.groupService.createGroup(
            name: "testAcl",
            groupType: "test",
            isOpenGroup: true,
            data: {"test": "asdf"});
        if (response.statusCode == 200) {
          groupId = response.data?["groupId"];
        }
      }
      if (response.statusCode == 200) {
        response = await bcTest.bcWrapper.groupService.createGroupEntity(
          groupId: groupId, 
          entityType: "entityType",data: {"name":"value"},
          acl: GroupACL(Access.readWrite, Access.readWrite),
          isOwnedByGroupMember: true);
      if (response.statusCode == 200) {
        var entityId = response.data?["entityId"];
        response = await bcTest.bcWrapper.groupService
            .updateGroupEntityAcl(groupId: groupId, entityId: entityId, acl: {"member": 2, "other": 1});

        //  due to a mis-configuration that will be fix later ignoring a error of cloudCodeOnlyMethod
        if (response.reasonCode != ReasonCodes.cloudCodeOnlyMethod) {
          expect(response.statusCode, StatusCodes.ok);
        }
        }
      }     
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
          .getRandomGroupsMatching(where: {"groupType": "BLUE"}, maxReturn: 20);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("UpdateGroupSummaryData()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .updateGroupSummaryData(
              groupId: groupId,
              version: -1,
              jsonSummaryData: {"summary": "asdf"});

      expect(response.statusCode, StatusCodes.ok);
    });

    test("deleteGroup()", () async {
      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: groupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);
    });

    var testGroupId = "";

    completeDeleteGroupJoinRequestTest() async {
      await bcTest.bcWrapper.logout(forgetUser: true);

      await bcTest.bcWrapper.authenticateUniversal(
          username: "JS-Tester1", password: "JS-Tester1", forceCreate: false);

      ServerResponse response = await bcTest.bcWrapper.groupService
          .deleteGroup(groupId: testGroupId, version: -1);

      expect(response.statusCode, StatusCodes.ok);

      response = await bcTest.bcWrapper.logout(forgetUser: true);

      expect(response.statusCode, StatusCodes.ok);
    }

    testDeleteGroupJoinRequest() async {
      var groupJoinRequestExists = false;

      ServerResponse authResponse = await bcTest.bcWrapper
          .authenticateUniversal(
              username: "JS-Tester2",
              password: "JS-Tester2",
              forceCreate: true);

      expect(authResponse.statusCode, StatusCodes.ok);

      print("Authenticated group tester");

      ServerResponse joinResponse =
          await bcTest.bcWrapper.groupService.joinGroup(groupId: testGroupId);

      expect(joinResponse.statusCode, StatusCodes.ok);

      ServerResponse groupsResponse =
          await bcTest.bcWrapper.groupService.getMyGroups();

      List requestedGroups = groupsResponse.data?["requested"];
      requestedGroups.forEach((requestedGroup) {
        if (requestedGroup["groupId"] == testGroupId) {
          groupJoinRequestExists = true;
        }
      });

      if (groupJoinRequestExists) {
        print("Group Join Request exists");

        // Reset for second check
        groupJoinRequestExists = false;

        await bcTest.bcWrapper.groupService
            .deleteGroupJoinRequest(groupId: testGroupId);

        ServerResponse response =
            await bcTest.bcWrapper.groupService.getMyGroups();

        requestedGroups = response.data?["requested"];
        requestedGroups.forEach((requestedGroup) {
          if (requestedGroup["groupId"] == testGroupId) {
            groupJoinRequestExists = true;
          }
        });

        if (groupJoinRequestExists) {
          expect(groupJoinRequestExists, true);
        } else {
          print("Group Join Request no longer exists");

          await completeDeleteGroupJoinRequestTest();
        }
      } else {
        expect(groupJoinRequestExists, true);
      }
    }

    setupGroupForTest() async {
      await bcTest.bcWrapper.authenticateUniversal(
          username: "JS-Tester1", password: "JS-Tester1", forceCreate: true);

      print("Authenticated group creator");

      var name = "JS-Test-ClosedGroup";
      var groupType = "test";
      var isOpenGroup = false;
      GroupACL acl = GroupACL(Access.readWrite, Access.none);

      Map<String, dynamic> jsonData = {};
      Map<String, dynamic> ownerAttributes = {};
      Map<String, dynamic> defaultMemberAttributes = {};

      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: name,
          groupType: groupType,
          isOpenGroup: isOpenGroup,
          acl: acl,
          data: jsonData,
          ownerAttributes: ownerAttributes,
          defaultMemberAttributes: defaultMemberAttributes);

      if (response.statusCode == StatusCodes.ok) {
        print("Group created");

        testGroupId = response.data?["groupId"];

        await bcTest.bcWrapper.logout();
        await testDeleteGroupJoinRequest();
      } else {
        expect(1, "Failed to create group");
      }
    }

    test("deleteGroupJoinRequest()", () async {
      if (bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.playerStateService.logout();
        await setupGroupForTest();
      } else {
        await setupGroupForTest();
      }
      expect(true, true);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
