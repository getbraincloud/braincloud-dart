import 'dart:convert';

import 'package:braincloud_dart/src/Common/group_acl.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void acceptGroupInvitation(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(
        ServiceOperation.acceptGroupInvitation, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void addGroupMember(
      String groupId,
      String profileId,
      Role role,
      String jsonAttributes,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> customData = jsonDecode(jsonAttributes);
      data[OperationParam.groupAttributes.value] = customData;
    }

    _sendRequest(ServiceOperation.addGroupMember, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void approveGroupJoinRequest(
      String groupId,
      String profileId,
      Role role,
      String jsonAttributes,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();

    if (Util.isOptionalParameterValid(jsonAttributes)) {
      Map<String, dynamic> customData = jsonDecode(jsonAttributes);
      data[OperationParam.groupAttributes.value] = customData;
    }

    _sendRequest(
        ServiceOperation.approveGroupJoinRequest, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void autoJoinGroup(
      String groupType,
      AutoJoinStrategy autoJoinStrategy,
      String dataQueryJson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupType.value] = groupType;
    data[OperationParam.groupAutoJoinStrategy.value] =
        autoJoinStrategy.toString();

    if (Util.isOptionalParameterValid(dataQueryJson)) {
      data[OperationParam.groupWhere.value] = dataQueryJson;
    }

    _sendRequest(ServiceOperation.autoJoinGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void autoJoinGroupMulti(
      List<String> groupTypes,
      AutoJoinStrategy autoJoinStrategy,
      String dataQueryJson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupTypes.value] = groupTypes;
    data[OperationParam.groupAutoJoinStrategy.value] =
        autoJoinStrategy.toString();

    if (Util.isOptionalParameterValid(dataQueryJson)) {
      data[OperationParam.groupWhere.value] = dataQueryJson;
    }

    _sendRequest(ServiceOperation.autoJoinGroupMulti, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void cancelGroupInvitation(String groupId, String profileId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    _sendRequest(
        ServiceOperation.cancelGroupInvitation, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void createGroup(
      String name,
      String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      String? jsonData,
      String jsonOwnerAttributes,
      String jsonDefaultMemberAttributes,
      SuccessCallback? success,
      FailureCallback? failure) {
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
          jsonDecode(jsonDefaultMemberAttributes);
    }

    _sendRequest(ServiceOperation.createGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void createGroupWithSummaryData(
      String name,
      String groupType,
      bool? isOpenGroup,
      GroupACL? acl,
      String? jsonData,
      String jsonOwnerAttributes,
      String jsonDefaultMemberAttributes,
      String jsonSummaryData,
      SuccessCallback? success,
      FailureCallback? failure) {
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
          jsonDecode(jsonDefaultMemberAttributes);
    }
    if (!jsonSummaryData.isEmptyOrNull) {
      data[OperationParam.groupSummaryData.value] = jsonDecode(jsonSummaryData);
    }

    _sendRequest(ServiceOperation.createGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void createGroupEntity(
      String groupId,
      String entityType,
      bool? isOwnedByGroupMember,
      GroupACL? acl,
      String? jsonData,
      SuccessCallback? success,
      FailureCallback? failure) {
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

    _sendRequest(ServiceOperation.createGroupEntity, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void deleteGroup(String groupId, int version, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;

    _sendRequest(ServiceOperation.deleteGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void deleteGroupEntity(String groupId, String entityId, int version,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    data[OperationParam.groupVersion.value] = version;

    _sendRequest(ServiceOperation.deleteGroupEntity, success, failure, data);
  }

  /// <summary>
  /// Read information on groups to which the current user belongs.
  /// </summary>
  /// <remarks>
  /// Service Name - group
  /// Service Operation - GET_MY_GROUPS
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getMyGroups(SuccessCallback? success, FailureCallback? failure) {
    _sendRequest(ServiceOperation.getMyGroups, success, failure, {});
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void incrementGroupData(String groupId, String? jsonData,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }

    _sendRequest(ServiceOperation.incrementGroupData, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void incrementGroupEntityData(String groupId, String entityId,
      String? jsonData, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    if (!jsonData.isEmptyOrNull) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData!);
    }
    _sendRequest(
        ServiceOperation.incrementGroupEntityData, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void inviteGroupMember(
      String groupId,
      String profileId,
      Role role,
      String? jsonAttributes,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    data[OperationParam.groupRole.value] = role.toString();
    if (!jsonAttributes.isEmptyOrNull) {
      data[OperationParam.groupAttributes.value] = jsonDecode(jsonAttributes!);
    }

    _sendRequest(ServiceOperation.inviteGroupMember, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void joinGroup(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(ServiceOperation.joinGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void leaveGroup(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(ServiceOperation.leaveGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void listGroupsPage(
      String jsonContext, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = jsonDecode(jsonContext);

    _sendRequest(ServiceOperation.listGroupsPage, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void listGroupsPageByOffset(String context, int pageOffset,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = context;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    _sendRequest(
        ServiceOperation.listGroupsPageByOffset, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void listGroupsWithMember(
      String profileId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupProfileId.value] = profileId;

    _sendRequest(ServiceOperation.listGroupsWithMember, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroup(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(ServiceOperation.readGroup, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroupData(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(ServiceOperation.readGroupData, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroupEntitiesPage(
      String jsonContext, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = jsonDecode(jsonContext);

    _sendRequest(
        ServiceOperation.readGroupEntitiesPage, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroupEntitiesPageByOffset(String encodedContext, int pageOffset,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupContext.value] = encodedContext;
    data[OperationParam.groupPageOffset.value] = pageOffset;

    _sendRequest(
        ServiceOperation.readGroupEntitiesPageByOffset, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroupEntity(String groupId, String entityId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;

    _sendRequest(ServiceOperation.readGroupEntity, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void readGroupMembers(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(ServiceOperation.readGroupMembers, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void rejectGroupInvitation(
      String groupId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;

    _sendRequest(
        ServiceOperation.rejectGroupInvitation, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void rejectGroupJoinRequest(String groupId, String profileId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    _sendRequest(
        ServiceOperation.rejectGroupJoinRequest, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void removeGroupMember(String groupId, String profileId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;

    _sendRequest(ServiceOperation.removeGroupMember, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateGroupData(String groupId, int version, String? jsonData,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;
    data[OperationParam.groupData.value] = jsonDecode(jsonData ?? "");

    _sendRequest(ServiceOperation.updateGroupData, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateGroupEntityData(String groupId, String entityId, int version,
      String? jsonData, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupEntityId.value] = entityId;
    data[OperationParam.groupVersion.value] = version;
    if (jsonData != null && jsonData.isNotEmpty) {
      data[OperationParam.groupData.value] = jsonDecode(jsonData);
    }

    _sendRequest(ServiceOperation.updateGroupEntity, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateGroupMember(
      String groupId,
      String profileId,
      Role? role,
      String? jsonAttributes,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupProfileId.value] = profileId;
    if (role != null) {
      data[OperationParam.groupRole.value] = role.toString();
    }
    if (!jsonAttributes.isEmptyOrNull) {
      data[OperationParam.groupAttributes.value] = jsonDecode(jsonAttributes!);
    }
    _sendRequest(ServiceOperation.updateGroupMember, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateGroupName(String groupId, String name, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupName.value] = name;

    _sendRequest(ServiceOperation.updateGroupName, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void setGroupOpen(String groupId, bool isOpenGroup, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupIsOpenGroup.value] = isOpenGroup;

    _sendRequest(ServiceOperation.setGroupOpen, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateGroupSummaryData(
      String groupId,
      int version,
      String? jsonSummaryData,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupVersion.value] = version;
    if (!jsonSummaryData.isEmptyOrNull) {
      data[OperationParam.groupSummaryData.value] =
          jsonDecode(jsonSummaryData!);
    }

    _sendRequest(
        ServiceOperation.updateGroupSummaryData, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getRandomGroupsMatching(String jsonWhere, int maxReturn,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    if (Util.isOptionalParameterValid(jsonWhere)) {
      Map<String, dynamic> customData = jsonDecode(jsonWhere);
      data[OperationParam.groupWhere.value] = customData;
    }
    data[OperationParam.groupMaxReturn.value] = maxReturn;

    _sendRequest(
        ServiceOperation.getRandomGroupsMatching, success, failure, data);
  }

  void _sendRequest(ServiceOperation operation, SuccessCallback? success,
      FailureCallback? failure, Map<String, dynamic> data) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.group, operation, data, callback);
    _clientRef.sendRequest(sc);
  }
}

enum Role { owner, admin, member, other }

enum AutoJoinStrategy { joinFirstGroup, joinRandomGroup }
