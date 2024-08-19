import 'dart:convert';

import 'package:braincloud_dart/src/Common/acl.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudGlobalEntity {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalEntity(this._clientRef);

  /// <summary>
  /// Method creates a new entity on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - Create
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="timeToLive">
  /// Sets expiry time for entity in milliseconds if > 0
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json. A null acl implies default
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void createEntity(
      String entityType,
      Duration? timeToLive,
      String? jsonEntityAcl,
      String jsonEntityData,
      SuccessCallback? success,
      FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;

    data[OperationParam.globalEntityServiceData.value] = jsonEntityAcl;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method creates a new entity on the server with an indexed id.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - CreateWithIndexedId
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="indexedId">
  /// A secondary ID that will be indexed
  /// </param>
  /// <param name="timeToLive">
  /// Sets expiry time for entity in milliseconds if > 0
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json. A null acl implies default
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void createEntityWithIndexedId(
      String entityType,
      String indexedId,
      Duration timeToLive,
      String jsonEntityAcl,
      String jsonEntityData,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceIndexedId.value] = indexedId;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.createWithIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method updates an existing entity on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - Update
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity to update
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateEntity(String entityId, int version, String jsonEntityData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method updates an existing entity's Acl on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - UpdateAcl
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity to update
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateEntityAcl(String entityId, int version, String jsonEntityAcl,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      var acl = jsonDecode(jsonEntityAcl);
      data[OperationParam.globalEntityServiceAcl.value] = acl;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.updateAcl, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method updates an existing entity's time to live on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - UpdateTimeToLive
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity to update
  /// </param>
  /// <param name="timeToLive">
  /// Sets expiry time for entity in milliseconds if > 0
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateEntityTimeToLive(String entityId, int version, Duration timeToLive,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateTimeToLive, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method deletes an existing entity on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity to delete
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void deleteEntity(String entityId, int version, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.delete, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method reads an existing entity from the server.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - Read
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readEntity(String entityId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method gets list of entities from the server base on type and/or where clause
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetList
  /// </remarks>
  /// <param name="whereJson">
  /// Mongo style query String
  /// </param>
  /// <param name="orderByJson">
  /// Sort order
  /// </param>
  /// <param name="maxReturn">
  /// The maximum number of entities to return
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getList(String whereJson, String orderByJson, int maxReturn,
      SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(whereJson)) {
      data[OperationParam.globalEntityServiceWhere.value] =
          jsonDecode(whereJson);
    }
    if (Util.isOptionalParameterValid(orderByJson)) {
      data[OperationParam.globalEntityServiceOrderBy.value] =
          jsonDecode(orderByJson);
    }
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getList, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method gets list of entities from the server base on indexed id
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetListByIndexedId
  /// </remarks>
  /// <param name="entityIndexedId">
  /// The entity indexed Id
  /// </param>
  /// <param name="maxReturn">
  /// The maximum number of entities to return
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getListByIndexedId(String entityIndexedId, int maxReturn,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListByIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method gets a count of entities based on the where clause
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  /// </remarks>
  /// <param name="whereJson">
  /// Mongo style query String
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getListCount(String whereJson, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(whereJson)) {
      data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListCount, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method uses a paging system to iterate through Global Entities.
  /// After retrieving a page of Global Entities with this method,
  /// use GetPageOffset() to retrieve previous or next pages.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetPage
  /// </remarks>
  /// <param name="jsonContext">The json context for the page request.
  /// See the portal appendix documentation for format</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  ///
  void getPage(String jsonContext, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceContext.value] = jsonContext;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getPage, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method to retrieve previous or next pages after having called
  /// the GetPage method.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetPageOffset
  /// </remarks>
  /// <param name="context">
  /// The context String returned from the server from a previous call
  /// to GetPage() or GetPageOffset()
  /// </param>
  /// <param name="pageOffset">
  /// The positive or negative page offset to fetch. Uses the last page
  /// retrieved using the context String to determine a starting point.
  /// </param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  ///
  void getPageOffset(String context, int pageOffset, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceContext.value] = context;
    data[OperationParam.globalEntityServicePageOffset.value] = pageOffset;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getPageOffset, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Partial increment of global entity data field items. Partial set of items incremented as specified.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - INCREMENT_GLOBAL_ENTITY_DATA
  /// </remarks>
  /// <param name="entityId">The entity to increment</param>
  /// <param name="jsonData">The subset of data to increment</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void incrementGlobalEntityData(String entityId, String jsonData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    if (Util.isOptionalParameterValid(jsonData)) {
      data[OperationParam.globalEntityServiceData.value] = jsonData;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.incrementGlobalEntityData, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Gets a list of up to randomCount randomly selected entities from the server based on the where condition and specified maximum return count.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - GET_RANDOM_ENTITIES_MATCHING
  /// </remarks>
  /// <param name="where">Mongo style query String</param>
  /// <param name="maxReturn">The maximum number of entities to return</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getRandomEntitiesMatching(String whereJson, int maxReturn,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(whereJson)) {
      data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    }

    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getRandomEntitiesMatching, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method updates an existing entity's Indexed Id.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_INDEXED_ID
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity
  /// </param>
  /// <param name="entityIndexedId">
  /// The id index of the entity
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateEntityIndexedId(
      String entityId,
      Duration version,
      String entityIndexedId,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method updates an existing entity's Owner and Acl on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_OWNER_AND_ACL
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity
  /// </param>
  /// <param name="ownerId">
  /// The owner ID
  /// </param>
  /// <param name="acl">
  /// The entity's access control list
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateEntityOwnerAndAcl(
      String entityId,
      Duration version,
      String ownerId,
      ACL acl,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.ownerId.value] = ownerId;
    data[OperationParam.globalEntityServiceAcl.value] = acl;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityOwnerAndAcl, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method clears the owner id of an existing entity and sets the Acl on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_OWNER_AND_ACL
  /// </remarks>
  /// <param name="entityId">
  /// The entity ID
  /// </param>
  /// <param name="version">
  /// The version of the entity
  /// </param>
  /// <param name="acl">
  /// The entity's access control list
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void makeSystemEntity(String entityId, Duration version, ACL acl,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceAcl.value] = acl;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.makeSystemEntity, data, callback);
    _clientRef.sendRequest(serverCall);
  }
}
