import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/common/group_acl.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';
import 'package:dart_extensions/dart_extensions.dart';

class BrainCloudGroup {
  final BrainCloudClient _clientRef;

  BrainCloudGroup(this._clientRef);

  /// <summary>
  /// Accept an outstanding invitation to join the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - ACCEPT_GROUP_INVITATION
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> acceptGroupInvitation({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.acceptGroupInvitation, data);
  }

  /// <summary>
  /// Add a member to the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - ADD_GROUP_MEMBER
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the member being added.
  /// </param>
  /// <param name="role">
  /// Role of the member being added.
  /// </param>
  /// <param name="jsonAttributes">
  /// Attributes of the member being added.
  /// </param>
  Future<ServerResponse> addGroupMember(
      {required String groupId,
      required String profileId,
      required Role role,
      String? jsonAttributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> customData = jsonDecode(jsonAttributes!);
      data[OperationParam.groupAttributes.value] = customData;
    }

    return _sendRequest(ServiceOperation.addGroupMember, data);
  }

  /// <summary>
  /// Approve an outstanding request to join the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - APPROVE_GROUP_JOIN_REQUEST
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the invitation being deleted.
  /// </param>
  /// <param name="role">
  /// Role of the member being invited.
  /// <param name="jsonAttributes">
  /// Attributes of the member being invited.
  /// </param>
  Future<ServerResponse> approveGroupJoinRequest(
      {required String groupId,
      required String profileId,
      required Role role,
      String? jsonAttributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> customData = jsonDecode(jsonAttributes!);
      data[OperationParam.groupAttributes.value] = customData;
    }

    return _sendRequest(ServiceOperation.approveGroupJoinRequest, data);
  }

  /// <summary>
  /// Automatically join an open group that matches the search criteria and has space available.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - AUTO_JOIN_GROUP
  /// </remarks>
  /// <param name="groupType">
  /// Name of the associated group type.
  /// </param>
  /// <param name="autoJoinStrategy">
  /// Selection strategy to employ when there are multiple matches
  /// </param>
  /// <param name="dataQueryJson">
  /// Query parameters (optional)
  /// </param>
  Future<ServerResponse> autoJoinGroup(
      {required String groupType,
      required AutoJoinStrategy autoJoinStrategy,
      String? dataQueryJson}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupType.value] = groupType;
    data[OperationParam.groupAutoJoinStrategy.value] =
        autoJoinStrategy.toString();

    if (Util.isOptionalParameterValid(dataQueryJson)) {
      data[OperationParam.groupWhere.value] = dataQueryJson;
    }

    return _sendRequest(ServiceOperation.autoJoinGroup, data);
  }

  /// <summary>
  /// Find and join an open group in the pool of groups in multiple group types provided as input arguments.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - AUTO_JOIN_GROUP_MULTI
  /// </remarks>
  /// <param name="groupTypes">
  /// Name of the associated group types.
  /// </param>
  /// <param name="autoJoinStrategy">
  /// Selection strategy to employ when there are multiple matches
  /// </param>
  /// <param name="dataQueryJson">
  /// Query parameters (optional)
  /// </param>
  Future<ServerResponse> autoJoinGroupMulti(
      {required List<String> groupTypes,
      required AutoJoinStrategy autoJoinStrategy,
      String? dataQueryJson}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupTypes.value] = groupTypes;
    data[OperationParam.groupAutoJoinStrategy.value] =
        autoJoinStrategy.toString();

    if (Util.isOptionalParameterValid(dataQueryJson)) {
      data[OperationParam.groupWhere.value] = dataQueryJson;
    }

    return _sendRequest(ServiceOperation.autoJoinGroupMulti, data);
  }

  /// <summary>
  /// Cancel an outstanding invitation to the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - CANCEL_GROUP_INVITATION
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the invitation being deleted.
  /// </param>
  Future<ServerResponse> cancelGroupInvitation(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.cancelGroupInvitation, data);
  }

  /// <summary>
  /// Delete a request to join the group.
  /// </summary>
  /// <remarks>
  /// Service Name - Group
  /// Service Operation - DELETE_GROUP_JOIN_REQUEST
  /// </remarks>
  /// <param name="groupId">
  /// The id of the group.
  /// </param>
  Future<ServerResponse> deleteGroupJoinRequest({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.deleteGroupJoinRequest, data);
  }

  /// <summary>
  /// Create a group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - CREATE_GROUP
  /// </remarks>
  /// <param name="name">
  /// Name of the group.
  /// </param>
  /// <param name="groupType">
  /// Name of the type of group.
  /// </param>
  /// <param name="isOpenGroup">
  /// true if group is open; false if closed.
  /// </param>
  /// <param name="acl">
  /// The group's access control list. A null ACL implies default.
  /// </param>
  /// <param name="jsonOwnerAttributes">
  /// Attributes for the group owner (current user).
  /// </param>
  /// <param name="jsonDefaultMemberAttributes">
  /// Default attributes for group members.
  /// </param>
  /// <param name="jsonData">
  /// Custom application data.
  /// </param>
  Future<ServerResponse> createGroup(
      {required String name,
      required String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      String? jsonData,
      String? jsonOwnerAttributes,
      String? jsonDefaultMemberAttributes}) {
    Map<String, dynamic> data = {};

    if (!name.isEmptyOrNull) {
      data[OperationParam.groupName.value] = name;
    }
    data[OperationParam.groupType.value] = groupType;
    if (isOpenGroup != null && isOpenGroup) {
      data[OperationParam.groupIsOpenGroup.value] = isOpenGroup;
    }
    if (acl != null) {
      data[OperationParam.groupAcl.value] = jsonDecode(acl.toJsonString());
    }
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }
    if (!jsonOwnerAttributes.isEmptyOrNull) {
      data[OperationParam.groupOwnerAttributes.value] =
          jsonDecode(jsonOwnerAttributes!);
    }
    if (!jsonDefaultMemberAttributes.isEmptyOrNull) {
      data[OperationParam.groupDefaultMemberAttributes.value] =
          jsonDecode(jsonDefaultMemberAttributes!);
    }

    return _sendRequest(ServiceOperation.createGroup, data);
  }

  /// <summary>
  /// Create a group. With additional summary data
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - CREATE_GROUP
  /// </remarks>
  /// <param name="name">
  /// Name of the group.
  /// </param>
  /// <param name="groupType">
  /// Name of the type of group.
  /// </param>
  /// <param name="isOpenGroup">
  /// true if group is open; false if closed.
  /// </param>
  /// <param name="acl">
  /// The group's access control list. A null ACL implies default.
  /// </param>
  /// <param name="jsonOwnerAttributes">
  /// Attributes for the group owner (current user).
  /// </param>
  /// <param name="jsonDefaultMemberAttributes">
  /// Default attributes for group members.
  /// </param>
  /// <param name="jsonData">
  /// Custom application data.
  /// </param>
  /// </param>
  /// <param name="jsonSummaryData">
  /// Custom application data.
  /// </param>
  Future<ServerResponse> createGroupWithSummaryData(
      {required String name,
      required String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      String? jsonData,
      required String jsonOwnerAttributes,
      String? jsonDefaultMemberAttributes,
      required String jsonSummaryData}) {
    Map<String, dynamic> data = {};

    if (!name.isEmptyOrNull) {
      data[OperationParam.groupName.value] = name;
    }
    data[OperationParam.groupType.value] = groupType;
    if (isOpenGroup != null && isOpenGroup) {
      data[OperationParam.groupIsOpenGroup.value] = isOpenGroup;
    }
    if (acl != null) {
      data[OperationParam.groupAcl.value] = jsonDecode(acl.toJsonString());
    }
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }
    if (!jsonOwnerAttributes.isEmptyOrNull) {
      data[OperationParam.groupOwnerAttributes.value] =
          jsonDecode(jsonOwnerAttributes);
    }
    if (!jsonDefaultMemberAttributes.isEmptyOrNull) {
      data[OperationParam.groupDefaultMemberAttributes.value] =
          jsonDecode(jsonDefaultMemberAttributes!);
    }
    if (!jsonSummaryData.isEmptyOrNull) {
      data[OperationParam.groupSummaryData.value] = jsonDecode(jsonSummaryData);
    }

    return _sendRequest(ServiceOperation.createGroup, data);
  }

  /// <summary>
  /// Create a group entity.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - CREATE_GROUP_ENTITY
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="isOwnedByGroupMember">
  /// true if entity is owned by a member; false if owned by the entire group.
  /// </param>
  /// <param name="type">
  /// Type of the group entity.
  /// </param>
  /// <param name="acl">
  /// Access control list for the group entity.
  /// </param>
  /// <param name="jsonData">
  /// Custom application data.
  /// </param>
  Future<ServerResponse> createGroupEntity(
      {required String groupId,
      required String entityType,
      bool? isOwnedByGroupMember,
      GroupACL? acl,
      String? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    if (!entityType.isEmptyOrNull) {
      data[OperationParam.groupEntityType.value] = entityType;
    }
    if (isOwnedByGroupMember != null) {
      data[OperationParam.groupIsOwnedByGroupMember.value] =
          isOwnedByGroupMember;
    }
    if (acl != null) {
      data[OperationParam.groupAcl.value] = jsonDecode(acl.toJsonString());
    }
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }

    return _sendRequest(ServiceOperation.createGroupEntity, data);
  }

  /// <summary>
  /// Delete a group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - DELETE_GROUP
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="version">
  /// Current version of the group
  /// </param>
  Future<ServerResponse> deleteGroup(
      {required String groupId, required int version}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;

    return _sendRequest(ServiceOperation.deleteGroup, data);
  }

  /// <summary>
  /// Delete a group entity.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - DELETE_GROUP_ENTITY
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="entityId">
  /// ID of the entity.
  /// </param>
  /// <param name="version">
  /// The current version of the group entity (for concurrency checking).
  /// </param>
  Future<ServerResponse> deleteGroupEntity(
      {required String groupId,
      required String entityId,
      required int version}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    data[OperationParam.groupVersion.value] = version;

    return _sendRequest(ServiceOperation.deleteGroupEntity, data);
  }

  /// <summary>
  /// Read information on groups to which the current user belongs.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - GET_MY_GROUPS
  Future<ServerResponse> getMyGroups() {
    return _sendRequest(ServiceOperation.getMyGroups, {});
  }

  /// <summary>
  /// Increment elements for the group's data field.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - INCREMENT_GROUP_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="jsonData">
  /// Partial data map with incremental values.
  /// </param>
  Future<ServerResponse> incrementGroupData(
      {required String groupId, String? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }

    return _sendRequest(ServiceOperation.incrementGroupData, data);
  }

  /// <summary>
  /// Increment elements for the group entity's data field.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - INCREMENT_GROUP_ENTITY_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="entityId">
  /// ID of the entity.
  /// </param>
  /// <param name="jsonData">
  /// Partial data map with incremental values.
  /// </param>
  Future<ServerResponse> incrementGroupEntityData(
      {required String groupId, required String entityId, String? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }
    return _sendRequest(ServiceOperation.incrementGroupEntityData, data);
  }

  /// <summary>
  /// Invite a member to the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - INVITE_GROUP_MEMBER
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the member being invited.
  /// </param>
  /// <param name="role">
  /// Role of the member being invited.
  /// </param>
  /// <param name="jsonAttributes">
  /// Attributes of the member being invited.
  /// </param>
  Future<ServerResponse> inviteGroupMember(
      {required String groupId,
      required String profileId,
      required Role role,
      String? jsonAttributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();
    if (!jsonAttributes.isEmptyOrNull) {
      data[OperationParam.groupAttributes.value] = jsonDecode(jsonAttributes!);
    }

    return _sendRequest(ServiceOperation.inviteGroupMember, data);
  }

  /// <summary>
  /// Join an open group or request to join a closed group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - JOIN_GROUP
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> joinGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.joinGroup, data);
  }

  /// <summary>
  /// Leave a group in which the user is a member.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - LEAVE_GROUP
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> leaveGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.leaveGroup, data);
  }

  /// <summary>
  /// Retrieve a page of group summary information based on the specified context.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_PAGE
  /// </remarks>
  /// <param name="jsonContext">
  /// Query context.
  Future<ServerResponse> listGroupsPage({required String jsonContext}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = jsonDecode(jsonContext);

    return _sendRequest(ServiceOperation.listGroupsPage, data);
  }

  /// <summary>
  /// Retrieve a page of group summary information based on the encoded context
  /// and specified page offset.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_PAGE_BY_OFFSET
  /// </remarks>
  /// <param name="context">
  /// Encoded reference query context.
  /// </param>
  /// <param name="pageOffset">
  /// Number of pages by which to offset the query.
  /// </param>
  Future<ServerResponse> listGroupsPageByOffset(
      {required String context, required int pageOffset}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    return _sendRequest(ServiceOperation.listGroupsPageByOffset, data);
  }

  /// <summary>
  /// Read information on groups to which the specified user belongs.  Access is subject to restrictions.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_WITH_MEMBER
  /// </remarks>
  /// <param name="profileId">
  /// User to read groups for
  Future<ServerResponse> listGroupsWithMember({required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.listGroupsWithMember, data);
  }

  /// <summary>
  /// Read the specified group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_GROUP
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> readGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroup, data);
  }

  /// <summary>
  /// Read the data of the specified group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_GROUP_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> readGroupData({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroupData, data);
  }

  /// <summary>
  /// Read a page of group entity information.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_GROUP_ENTITIES_PAGE
  /// </remarks>
  /// <param name="jsonContext">
  /// Query context.
  /// </param>
  Future<ServerResponse> readGroupEntitiesPage({required String jsonContext}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = jsonDecode(jsonContext);

    return _sendRequest(ServiceOperation.readGroupEntitiesPage, data);
  }

  /// <summary>
  /// Read a page of group entity information.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_GROUP_ENTITIES_PAGE_BY_OFFSET
  /// </remarks>
  /// <param name="encodedContext">
  /// Encoded reference query context.
  /// </param>
  /// <param name="pageOffset">
  /// Number of pages by which to offset the query.
  /// </param>
  Future<ServerResponse> readGroupEntitiesPageByOffset(
      {required String encodedContext, required int pageOffset}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = encodedContext;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    return _sendRequest(ServiceOperation.readGroupEntitiesPageByOffset, data);
  }

  /// <summary>
  /// Read the specified group entity.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_GROUP_ENTITY
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="entityId">
  /// ID of the entity.
  /// </param>
  Future<ServerResponse> readGroupEntity(
      {required String groupId, required String entityId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;

    return _sendRequest(ServiceOperation.readGroupEntity, data);
  }

  /// <summary>
  /// Read the members of the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - READ_MEMBERS_OF_GROUP
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> readGroupMembers({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroupMembers, data);
  }

  /// <summary>
  /// Reject an outstanding invitation to join the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - REJECT_GROUP_INVITATION
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  Future<ServerResponse> rejectGroupInvitation({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.rejectGroupInvitation, data);
  }

  /// <summary>
  /// Reject an outstanding request to join the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - REJECT_GROUP_JOIN_REQUEST
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the invitation being deleted.
  /// </param>
  Future<ServerResponse> rejectGroupJoinRequest(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.rejectGroupJoinRequest, data);
  }

  /// <summary>
  /// Remove a member from the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - REMOVE_GROUP_MEMBER
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the member being deleted.
  /// </param>
  Future<ServerResponse> removeGroupMember(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.removeGroupMember, data);
  }

  /// <summary>
  /// Updates a group's data.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="version">
  /// Version to verify.
  /// </param>
  /// <param name="jsonData">
  /// Data to apply.
  /// </param>
  Future<ServerResponse> updateGroupData(
      {required String groupId, required int version, String? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;
    data[OperationParam.groupData.value] = jsonDecode(jsonData ?? "");

    return _sendRequest(ServiceOperation.updateGroupData, data);
  }

  /// <summary>
  /// Update a group entity.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_ENTITY_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="entityId">
  /// ID of the entity.
  /// </param>
  /// <param name="version">
  /// The current version of the group entity (for concurrency checking).
  /// </param>
  /// <param name="jsonData">
  /// Custom application data.
  /// </param>
  Future<ServerResponse> updateGroupEntityData(
      {required String groupId,
      required String entityId,
      required int version,
      String? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    data[OperationParam.groupVersion.value] = version;
    if (jsonData != null && jsonData.isNotEmpty) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData);
    }

    return _sendRequest(ServiceOperation.updateGroupEntity, data);
  }

  /// <summary>
  /// Update a member of the group.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_MEMBER
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="profileId">
  /// Profile ID of the member being updated.
  /// </param>
  /// <param name="role">
  /// Role of the member being updated (optional).
  /// </param>
  /// <param name="jsonAttributes">
  /// Attributes of the member being updated (optional).
  /// </param>
  Future<ServerResponse> updateGroupMember(
      {required groupId,
      required String profileId,
      Role? role,
      String? jsonAttributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    if (role != null) {
      data[OperationParam.groupRole.value] = role.toString();
    }
    if (!jsonAttributes.isEmptyOrNull) {
      data[OperationParam.groupAttributes.value] = jsonDecode(jsonAttributes!);
    }
    return _sendRequest(ServiceOperation.updateGroupMember, data);
  }

  /// <summary>
  /// Updates a group's name.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_NAME
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="name">
  /// Name to apply.
  /// </param>
  Future<ServerResponse> updateGroupName(
      {required String groupId, required String name}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupName.value] = name;

    return _sendRequest(ServiceOperation.updateGroupName, data);
  }

  /// <summary>
  /// set a group to be open true or false
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - SET_GROUP_OPEN
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="isOpenGroup">
  /// true or false if a group is open.
  /// </param>
  Future<ServerResponse> setGroupOpen(
      {required String groupId, required bool isOpenGroup}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupIsOpenGroup.value] = isOpenGroup;

    return _sendRequest(ServiceOperation.setGroupOpen, data);
  }

  /// <summary>
  /// Update a group's summary data
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_SUMMARY_DATA
  /// </remarks>
  /// <param name="groupId">
  /// ID of the group.
  /// </param>
  /// <param name="version">
  /// Current version of the group
  /// </param>
  /// <param name="jsonSummaryData">
  /// Custom application data.
  /// </param>
  Future<ServerResponse> updateGroupSummaryData(
      {required String groupId,
      required int version,
      String? jsonSummaryData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;
    if (!jsonSummaryData.isEmptyOrNull) {
      data[OperationParam.groupSummaryData.value] =
          jsonDecode(jsonSummaryData!);
    }

    return _sendRequest(ServiceOperation.updateGroupSummaryData, data);
  }

  /// <summary>
  /// Gets a list of up to maxReturn randomly selected groups from the server based on the where condition.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - UPDATE_SUMMARY_DATA
  /// </remarks>
  /// <param name="jsonWhere">
  /// where to search
  /// ex . "where": {"groupType": "BLUE"}
  /// </param>
  /// <param name="maxReturn">
  /// max num groups wanted
  /// </param>
  Future<ServerResponse> getRandomGroupsMatching(
      {required String jsonWhere, required int maxReturn}) {
    Map<String, dynamic> data = {};
    if (Util.isOptionalParameterValid(jsonWhere)) {
      Map<String, dynamic> customData = jsonDecode(jsonWhere);
      data[OperationParam.groupWhere.value] = customData;
    }
    data[OperationParam.groupMaxReturn.value] = maxReturn;

    return _sendRequest(ServiceOperation.getRandomGroupsMatching, data);
  }

  Future<ServerResponse> _sendRequest(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.group, operation, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}

enum Role {
  owner("OWNER"),
  admin("ADMIN"),
  member("MEMBER"),
  other("OTHER");

  const Role(this.value);
  final String value;

  static Role fromString(String s) {
    Role role =
        Role.values.firstWhere((e) => e.value == s, orElse: () => Role.other);

    return role;
  }

  @override
  String toString() => value;
}

enum AutoJoinStrategy {
  joinFirstGroup("JoinFirstGroup"),
  joinRandomGroup("JoinRandomGroup");

  const AutoJoinStrategy(this.value);
  final String value;

  static AutoJoinStrategy fromString(String s) {
    AutoJoinStrategy autoJoinStrategy = AutoJoinStrategy.values.firstWhere(
        (e) => e.value == s,
        orElse: () => AutoJoinStrategy.joinRandomGroup);
    return autoJoinStrategy;
  }

  @override
  String toString() => value;
}
