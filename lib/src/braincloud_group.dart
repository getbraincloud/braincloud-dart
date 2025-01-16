import 'dart:async';

import 'package:braincloud_dart/src/common/group_acl.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

import 'common/acl.dart';

class BrainCloudGroup {
  final BrainCloudClient _clientRef;

  BrainCloudGroup(this._clientRef);

  /// Accept an outstanding invitation to join the group.
  ///
  /// Service Name - group
  /// Service Operation - ACCEPT_GROUP_INVITATION
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> acceptGroupInvitation({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.acceptGroupInvitation, data);
  }

  /// Add a member to the group.
  ///
  /// Service Name - group
  /// Service Operation - ADD_GROUP_MEMBER
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the member being added.
  ///
  /// @param role
  /// Role of the member being added.
  ///
  /// @param attributes
  /// Attributes of the member being added.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> addGroupMember(
      {required String groupId,
      required String profileId,
      required Role role,
      Map<String, dynamic>? attributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (attributes != null) {
      data[OperationParam.groupAttributes.value] = attributes;
    }

    return _sendRequest(ServiceOperation.addGroupMember, data);
  }

  /// Approve an outstanding request to join the group.
  ///
  /// Service Name - group
  /// Service Operation - APPROVE_GROUP_JOIN_REQUEST
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the invitation being deleted.
  ///
  /// @param role
  /// Role of the member being invited.
  ///
  /// @param attributes
  /// Attributes of the member being invited.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> approveGroupJoinRequest(
      {required String groupId,
      required String profileId,
      required Role role,
      Map<String, dynamic>? attributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (attributes != null) {
      data[OperationParam.groupAttributes.value] = attributes;
    }

    return _sendRequest(ServiceOperation.approveGroupJoinRequest, data);
  }

  /// Automatically join an open group that matches the search criteria and has space available.
  ///
  /// Service Name - group
  /// Service Operation - AUTO_JOIN_GROUP
  ///
  /// @param groupType
  /// Name of the associated group type.
  ///
  /// @param autoJoinStrategy
  /// Selection strategy to employ when there are multiple matches
  ///
  /// @param dataQueryJson
  /// Query parameters (optional)
  ///
  /// returns `Future<ServerResponse>`
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

  /// Find and join an open group in the pool of groups in multiple group types provided as input arguments.
  ///
  /// Service Name - group
  /// Service Operation - AUTO_JOIN_GROUP_MULTI
  ///
  /// @param groupTypes
  /// Name of the associated group types.
  ///
  /// @param autoJoinStrategy
  /// Selection strategy to employ when there are multiple matches
  ///
  /// @param dataQueryJson
  /// Query parameters (optional)
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> autoJoinGroupMulti(
      {required List<String> groupTypes,
      required AutoJoinStrategy autoJoinStrategy,
      Map<String, dynamic>? where}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupTypes.value] = groupTypes;
    data[OperationParam.groupAutoJoinStrategy.value] =
        autoJoinStrategy.toString();
      data[OperationParam.groupWhere.value] = where;

    return _sendRequest(ServiceOperation.autoJoinGroupMulti, data);
  }

  /// Cancel an outstanding invitation to the group.
  ///
  /// Service Name - group
  /// Service Operation - CANCEL_GROUP_INVITATION
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the invitation being deleted.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> cancelGroupInvitation(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.cancelGroupInvitation, data);
  }

  /// Delete a request to join the group.
  ///
  /// Service Name - Group
  /// Service Operation - DELETE_GROUP_JOIN_REQUEST
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> deleteGroupJoinRequest({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.deleteGroupJoinRequest, data);
  }

  /// Create a group.
  ///
  /// Service Name - group
  /// Service Operation - CREATE_GROUP
  ///
  /// @param name
  /// Name of the group.
  ///
  /// @param groupType
  /// Name of the type of group.
  ///
  /// @param isOpenGroup
  /// true if group is open; false if closed.
  ///
  /// @param acl
  /// The group's access control list. A null ACL implies default.
  ///
  /// @param jsonOwnerAttributes
  /// Attributes for the group owner (current user).
  ///
  /// @param jsonDefaultMemberAttributes
  /// Default attributes for group members.
  ///
  /// @param jsonData
  /// Custom application data.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> createGroup(
      {required String name,
      required String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      Map<String, dynamic>? data,
      Map<String, dynamic>? ownerAttributes,
      Map<String, dynamic>? defaultMemberAttributes}) {
    Map<String, dynamic> mapData = {};

    if (!name.isEmptyOrNull) {
      mapData[OperationParam.groupName.value] = name;
    }
    mapData[OperationParam.groupType.value] = groupType;
    if (isOpenGroup != null && isOpenGroup) {
      mapData[OperationParam.groupIsOpenGroup.value] = isOpenGroup;
    }
    if (acl != null) {
      mapData[OperationParam.groupAcl.value] = acl.toJsonMap();
    }
    if (data != null) {
      mapData[OperationParam.groupData.value] = data;
    }
    if (ownerAttributes != null) {
      mapData[OperationParam.groupOwnerAttributes.value] = ownerAttributes;
    }
    if (defaultMemberAttributes != null) {
      mapData[OperationParam.groupDefaultMemberAttributes.value] =
          defaultMemberAttributes;
    }

    return _sendRequest(ServiceOperation.createGroup, mapData);
  }

  /// Create a group. With additional summary data
  ///
  /// Service Name - group
  /// Service Operation - CREATE_GROUP
  ///
  /// @param name
  /// Name of the group.
  ///
  /// @param groupType
  /// Name of the type of group.
  ///
  /// @param isOpenGroup
  /// true if group is open; false if closed.
  ///
  /// @param acl
  /// The group's access control list. A null ACL implies default.
  ///
  /// @param jsonOwnerAttributes
  /// Attributes for the group owner (current user).
  ///
  /// @param jsonDefaultMemberAttributes
  /// Default attributes for group members.
  ///
  /// @param jsonData
  /// Custom application data.
  ///
  /// @param jsonSummaryData
  /// Custom application data.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> createGroupWithSummaryData(
      {required String name,
      required String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      Map<String, dynamic>? data,
      Map<String, dynamic>? ownerAttributes,
      Map<String, dynamic>? defaultMemberAttributes,
      Map<String, dynamic>? summaryData}) {
    Map<String, dynamic> mapData = {};

    if (!name.isEmptyOrNull) {
      mapData[OperationParam.groupName.value] = name;
    }
    mapData[OperationParam.groupType.value] = groupType;
    if (isOpenGroup != null && isOpenGroup) {
      mapData[OperationParam.groupIsOpenGroup.value] = isOpenGroup;
    }
    if (acl != null) {
      mapData[OperationParam.groupAcl.value] = acl.toJsonMap();
    }
    if (data != null) {
      mapData[OperationParam.groupData.value] = data;
    }
    if (ownerAttributes != null) {
      mapData[OperationParam.groupOwnerAttributes.value] = ownerAttributes;
    }
    if (defaultMemberAttributes != null) {
      mapData[OperationParam.groupDefaultMemberAttributes.value] =
          defaultMemberAttributes;
    }
    if (summaryData != null) {
      mapData[OperationParam.groupSummaryData.value] = summaryData;
    }

    return _sendRequest(ServiceOperation.createGroup, mapData);
  }

  /// Create a group entity.
  ///
  /// Service Name - group
  /// Service Operation - CREATE_GROUP_ENTITY
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param isOwnedByGroupMember
  /// true if entity is owned by a member; false if owned by the entire group.
  ///
  /// @param type
  /// Type of the group entity.
  ///
  /// @param acl
  /// Access control list for the group entity.
  ///
  /// @param jsonData
  /// Custom application data.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> createGroupEntity(
      {required String groupId,
      required String entityType,
      bool? isOwnedByGroupMember,
      required GroupACL acl,
      Map<String, dynamic>? data}) {
    Map<String, dynamic> mapData = {};
    mapData[OperationParam.groupId.value] = groupId;
    if (!entityType.isEmptyOrNull) {
      mapData[OperationParam.groupEntityType.value] = entityType;
    }
    if (isOwnedByGroupMember != null) {
      mapData[OperationParam.groupIsOwnedByGroupMember.value] =
          isOwnedByGroupMember;
    }
    mapData[OperationParam.groupAcl.value] =  acl.toJsonMap();
    
    if (data != null) {
      mapData[OperationParam.groupData.value] = data;
    }

    return _sendRequest(ServiceOperation.createGroupEntity, mapData);
  }

  /// Delete a group.
  ///
  /// Service Name - group
  /// Service Operation - DELETE_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param version
  /// Current version of the group
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> deleteGroup(
      {required String groupId, required int version}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;

    return _sendRequest(ServiceOperation.deleteGroup, data);
  }

  /// Delete a group entity.
  ///
  /// Service Name - group
  /// Service Operation - DELETE_GROUP_ENTITY
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param entityId
  /// ID of the entity.
  ///
  /// @param version
  /// The current version of the group entity (for concurrency checking).
  ///
  /// returns `Future<ServerResponse>`
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

  /// Read information on groups to which the current user belongs.
  ///
  /// Service Name - group
  /// Service Operation - GET_MY_GROUPS
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getMyGroups() {
    return _sendRequest(ServiceOperation.getMyGroups, {});
  }

  /// Increment elements for the group's data field.
  ///
  /// Service Name - group
  /// Service Operation - INCREMENT_GROUP_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param jsonData
  /// Partial data map with incremental values.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> incrementGroupData(
      {required String groupId, Map<String, dynamic>? data}) {
    Map<String, dynamic> mapData = {};
    mapData[OperationParam.groupId.value] = groupId;
    if (data != null) {
      mapData[OperationParam.groupData.value] = data;
    }

    return _sendRequest(ServiceOperation.incrementGroupData, mapData);
  }

  /// Increment elements for the group entity's data field.
  ///
  /// Service Name - group
  /// Service Operation - INCREMENT_GROUP_ENTITY_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param entityId
  /// ID of the entity.
  ///
  /// @param jsonData
  /// Partial data map with incremental values.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> incrementGroupEntityData(
      {required String groupId,
      required String entityId,
      Map<String, dynamic>? data}) {
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.groupId.value] = groupId;
    dataMap[OperationParam.groupEntityId.value] = entityId;
    if (data != null) {
      dataMap[OperationParam.groupData.value] = data;
    }
    return _sendRequest(ServiceOperation.incrementGroupEntityData, dataMap);
  }

  /// Invite a member to the group.
  ///
  /// Service Name - group
  /// Service Operation - INVITE_GROUP_MEMBER
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the member being invited.
  ///
  /// @param role
  /// Role of the member being invited.
  ///
  /// @param jsonAttributes
  /// Attributes of the member being invited.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> inviteGroupMember(
      {required String groupId,
      required String profileId,
      required Role role,
      Map<String, dynamic>? attributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();
    if (attributes != null) {
      data[OperationParam.groupAttributes.value] = attributes;
    }

    return _sendRequest(ServiceOperation.inviteGroupMember, data);
  }

  /// Join an open group or request to join a closed group.
  ///
  /// Service Name - group
  /// Service Operation - JOIN_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> joinGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.joinGroup, data);
  }

  /// Leave a group in which the user is a member.
  ///
  /// Service Name - group
  /// Service Operation - LEAVE_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> leaveGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.leaveGroup, data);
  }

  /// Leave a group in which the user is a member. If member is OWNER, a new owner is 
  /// automatically selected: most recently active ADMIN; otherwise, most recently 
  /// active MEMBER; otherwise, group is deleted.
  ///
  /// Service Name - group
  /// Service Operation - LEAVE_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> leaveGroupAuto({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.leaveGroupAuto, data);
  }

  /// Retrieve a page of group summary information based on the specified context.
  ///
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_PAGE
  ///
  /// @param jsonContext
  /// Query context.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> listGroupsPage(
      {required Map<String, dynamic> context}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;

    return _sendRequest(ServiceOperation.listGroupsPage, data);
  }

  /// Retrieve a page of group summary information based on the encoded context
  /// and specified page offset.
  ///
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_PAGE_BY_OFFSET
  ///
  /// @param context
  /// Encoded reference query context.
  ///
  /// @param pageOffset
  /// Number of pages by which to offset the query.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> listGroupsPageByOffset(
      {required String context, required int pageOffset}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    return _sendRequest(ServiceOperation.listGroupsPageByOffset, data);
  }

  /// Read information on groups to which the specified user belongs.  Access is subject to restrictions.
  ///
  /// Service Name - group
  /// Service Operation - LIST_GROUPS_WITH_MEMBER
  ///
  /// @param profileId
  /// User to read groups for
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> listGroupsWithMember({required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.listGroupsWithMember, data);
  }

  /// Read the specified group.
  ///
  /// Service Name - group
  /// Service Operation - READ_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroup({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroup, data);
  }

  /// Read the data of the specified group.
  ///
  /// Service Name - group
  /// Service Operation - READ_GROUP_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroupData({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroupData, data);
  }

  /// Read a page of group entity information.
  ///
  /// Service Name - group
  /// ServiceOperation - READ_GROUP_ENTITIES_PAGE
  ///
  /// @param jsonContext
  /// Query context.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroupEntitiesPage(
      {required Map<String, dynamic> context}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;

    return _sendRequest(ServiceOperation.readGroupEntitiesPage, data);
  }

  /// Read a page of group entity information.
  ///
  /// Service Name - group
  /// Service Operation - READ_GROUP_ENTITIES_PAGE_BY_OFFSET
  ///
  /// @param encodedContext
  /// Encoded reference query context.
  ///
  /// @param pageOffset
  /// Number of pages by which to offset the query.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroupEntitiesPageByOffset(
      {required String context, required int pageOffset}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    return _sendRequest(ServiceOperation.readGroupEntitiesPageByOffset, data);
  }

  /// Read the specified group entity.
  ///
  /// Service Name - group
  /// Service Operation - READ_GROUP_ENTITY
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param entityId
  /// ID of the entity.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroupEntity(
      {required String groupId, required String entityId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;

    return _sendRequest(ServiceOperation.readGroupEntity, data);
  }

  /// Read the members of the group.
  ///
  /// Service Name - group
  /// Service Operation - READ_MEMBERS_OF_GROUP
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readGroupMembers({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.readGroupMembers, data);
  }

  /// Reject an outstanding invitation to join the group.
  ///
  /// Service Name - group
  /// Service Operation - REJECT_GROUP_INVITATION
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> rejectGroupInvitation({required String groupId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    return _sendRequest(ServiceOperation.rejectGroupInvitation, data);
  }

  /// Reject an outstanding request to join the group.
  ///
  /// Service Name - group
  /// Service Operation - REJECT_GROUP_JOIN_REQUEST
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the invitation being deleted.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> rejectGroupJoinRequest(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.rejectGroupJoinRequest, data);
  }

  /// Remove a member from the group.
  ///
  /// Service Name - group
  /// Service Operation - REMOVE_GROUP_MEMBER
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the member being deleted.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> removeGroupMember(
      {required String groupId, required String profileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    return _sendRequest(ServiceOperation.removeGroupMember, data);
  }

  /// Updates a group's data.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param version
  /// Version to verify.
  ///
  /// @param jsonData
  /// Data to apply.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupData(
      {required String groupId,
      required int version,
      Map<String, dynamic>? data}) {
    Map<String, dynamic> dataMap = {};
    dataMap[OperationParam.groupId.value] = groupId;
    dataMap[OperationParam.groupVersion.value] = version;
    dataMap[OperationParam.groupData.value] = data;

    return _sendRequest(ServiceOperation.updateGroupData, dataMap);
  }

  ///Update the acl settings for a group entity, enforcing ownership.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_ENTITY_ACL
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param acl
  /// Access control list for the group entity.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupEntityAcl(
      {required String groupId,
      required String entityId,      
      ACL? acl}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    if (acl != null && acl.isNotEmpty) {
      data[OperationParam.groupAcl.value] = acl;
    }

    return _sendRequest(ServiceOperation.updateGroupEntityAcl, data);
  }
  /// Update a group entity.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_ENTITY_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param entityId
  /// ID of the entity.
  ///
  /// @param version
  /// The current version of the group entity (for concurrency checking).
  ///
  /// @param jsonData
  /// Custom application data.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupEntityData(
      {required String groupId,
      required String entityId,
      required int version,
      Map<String, dynamic>? jsonData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    data[OperationParam.groupVersion.value] = version;
    if (jsonData != null && jsonData.isNotEmpty) {
      data[OperationParam.groupData.value] = jsonData;
    }

    return _sendRequest(ServiceOperation.updateGroupEntity, data);
  }

  /// Update a member of the group.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_MEMBER
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param profileId
  /// Profile ID of the member being updated.
  ///
  /// @param role
  /// Role of the member being updated (optional).
  ///
  /// @param jsonAttributes
  /// Attributes of the member being updated (optional).
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupMember(
      {required groupId,
      required String profileId,
      Role? role,
      Map<String, dynamic>? jsonAttributes}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    if (role != null) {
      data[OperationParam.groupRole.value] = role.toString();
    }
    if (jsonAttributes != null) {
      data[OperationParam.groupAttributes.value] = jsonAttributes;
    }
    return _sendRequest(ServiceOperation.updateGroupMember, data);
  }

  /// Updates a group's name.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_NAME
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param name
  /// Name to apply.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupName(
      {required String groupId, required String name}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupName.value] = name;

    return _sendRequest(ServiceOperation.updateGroupName, data);
  }

  /// set a group to be open true or false
  ///
  /// Service Name - group
  /// Service Operation - SET_GROUP_OPEN
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param isOpenGroup
  /// true or false if a group is open.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> setGroupOpen(
      {required String groupId, required bool isOpenGroup}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupIsOpenGroup.value] = isOpenGroup;

    return _sendRequest(ServiceOperation.setGroupOpen, data);
  }

  /// Update a group's access conditions,
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_GROUP_ACL
  ///
  /// @param groupId
  /// ID of the group.
  ///
   /// @param jsonSummaryData
  /// Custom application data.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupAcl(
      {required String groupId,
      Map<String, dynamic>? acl}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    if (acl != null) {
      data[OperationParam.groupAcl.value] = acl;
    }

    return _sendRequest(ServiceOperation.updateGroupAcl, data);
  }

  /// Update a group's summary data
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_SUMMARY_DATA
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param acl
  /// The group's access control list. A null ACL implies default.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateGroupSummaryData(
      {required String groupId,
      required int version,
      Map<String, dynamic>? jsonSummaryData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;
    if (jsonSummaryData != null) {
      data[OperationParam.groupSummaryData.value] = jsonSummaryData;
    }

    return _sendRequest(ServiceOperation.updateGroupSummaryData, data);
  }

  /// Gets a list of up to maxReturn randomly selected groups from the server based on the where condition.
  ///
  /// Service Name - group
  /// Service Operation - UPDATE_SUMMARY_DATA
  ///
  /// @param jsonWhere
  /// where to search
  ///
  /// ex . "where": {"groupType": "BLUE"}
  ///
  /// @param maxReturn
  /// max num groups wanted
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getRandomGroupsMatching(
      {Map<String, dynamic>? where, required int maxReturn}) {
    Map<String, dynamic> data = {};
    if (where != null) {
      data[OperationParam.groupWhere.value] = where;
    }
    data[OperationParam.groupMaxReturn.value] = maxReturn;

    return _sendRequest(ServiceOperation.getRandomGroupsMatching, data);
  }

  /// returns `Future<ServerResponse>`
  Future<ServerResponse> _sendRequest(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
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
