import 'dart:convert';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudEntity {
  final BrainCloudClient _clientRef;

  BrainCloudEntity(this._clientRef);

  /// <summary>
  /// Method creates a new entity on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Create
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json. A null acl implies default
  /// permissions which make the entity readable/writeable by only the user.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void createEntity(
      String entityType,
      String jsonEntityData,
      String? jsonEntityAcl,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var entityData = jsonDecode(jsonEntityData);
    data[OperationParam.EntityServiceData.Value] = entityData;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      var acl = jsonDecode(jsonEntityAcl!);
      data[OperationParam.EntityServiceAcl.Value] = acl;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall =
        ServerCall(ServiceName.entity, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary> Method returns all user entities that match the given type.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - ReadByType
  /// </remarks>
  /// <param name="entityType">
  /// The entity type to search for
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getEntitiesByType(String entityType, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readByType, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method updates a new entity on the server. This operation results in the entity
  /// data being completely replaced by the passed in JSON String.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Update
  /// </remarks>
  /// <param name="entityId">
  /// The id of the entity to update
  /// </param>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String.
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json. A null acl implies default
  /// permissions which make the entity readable/writeable by only the user.
  /// </param>
  /// <param name="version">
  /// Current version of the entity. If the version of the
  /// entity on the server does not match the version passed in, the
  /// server operation will fail. Use -1 to skip version checking.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void updateEntity(
      String entityId,
      String entityType,
      String jsonEntityData,
      String? jsonEntityAcl,
      int version,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityId.Value] = entityId;
    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var entityData = jsonDecode(jsonEntityData);
    data[OperationParam.EntityServiceData.Value] = entityData;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      var acl = jsonDecode(jsonEntityAcl!);
      data[OperationParam.EntityServiceAcl.Value] = acl;
    }
    data[OperationParam.EntityServiceVersion.Value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method updates a shared entity owned by another user. This operation results in the entity
  /// data being completely replaced by the passed in JSON String.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - UpdateShared
  /// </remarks>
  /// <param name="entityId">
  /// The id of the entity to update
  /// </param>
  /// <param name="targetProfileId">
  /// The id of the entity's owner
  /// </param>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String.
  /// </param>
  /// <param name="version">
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void updateSharedEntity(
      String entityId,
      String targetProfileId,
      String entityType,
      String jsonEntityData,
      int version,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityId.Value] = entityId;
    data[OperationParam.EntityServiceTargetPlayerId.Value] = targetProfileId;

    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var entityData = jsonDecode(jsonEntityData);
    data[OperationParam.EntityServiceData.Value] = entityData;

    data[OperationParam.EntityServiceVersion.Value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.updateShared, data, callback);
    _clientRef.sendRequest(sc);
  }

  /*Unavailable for now...
         * void UpdateEntityPartial(String entityId, String entityType, String jsonEntityData, SuccessCallback? success, FailureCallback? failure, dynamic cbObject)
        {
            // TODO: actually call the right method...
            UpdateEntity(entityId, entityType, jsonEntityData, success, failure, cbObject: cbObject);
        }
         */

  /// <summary>
  /// Method deletes the given entity on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="entityId">
  /// The id of the entity to update
  /// </param>
  /// <param name="version">
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void deleteEntity(String entityId, int version, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityId.Value] = entityId;
    data[OperationParam.EntityServiceVersion.Value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.delete, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method updates a singleton entity on the server. This operation results in the entity
  /// data being completely replaced by the passed in JSON String. If the entity doesn't exist it is created.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Update_Singleton
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="jsonEntityData">
  /// The entity's data as a json String.
  /// </param>
  /// <param name="jsonEntityAcl">
  /// The entity's access control list as json. A null acl implies default
  /// </param>
  /// <param name="version">
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void updateSingleton(
      String entityType,
      String jsonEntityData,
      String jsonEntityAcl,
      int version,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var entityData = jsonDecode(jsonEntityData);
    data[OperationParam.EntityServiceData.Value] = entityData;

    if (Util.isOptionalParameterValid(jsonEntityAcl)) {
      var acl = jsonDecode(jsonEntityAcl);
      data[OperationParam.EntityServiceAcl.Value] = acl;
    }

    data[OperationParam.EntityServiceVersion.Value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.updateSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method deletes the given singleton on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Delete
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="version">
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void deleteSingleton(String entityType, int version, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityType.Value] = entityType;
    data[OperationParam.EntityServiceVersion.Value] = version;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.deleteSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method to get a specific entity.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - Read
  /// </remarks>
  /// <param name="entityId">
  /// The id of the entity
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getEntity(String entityId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityId.Value] = entityId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method retrieves a singleton entity on the server. If the entity doesn't exist, null is returned.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - ReadSingleton
  /// </remarks>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getSingleton(String entityType, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceEntityType.Value] = entityType;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns a shared entity for the given profile and entity ID.
  /// An entity is shared if its ACL allows for the currently logged
  /// in user to read the data.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - READ_SHARED_ENTITY
  /// </remarks>
  /// <param name="profileId">
  /// The the profile ID of the user who owns the entity
  /// </param>
  /// <param name="entityId">
  /// The ID of the entity that will be retrieved
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getSharedEntityForProfileId(String profileId, String entityId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceTargetPlayerId.Value] = profileId;
    data[OperationParam.EntityServiceEntityId.Value] = entityId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readSharedEntity, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method returns all shared entities for the given profile id.
  /// An entity is shared if its ACL allows for the currently logged
  /// in user to read the data.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - ReadShared
  /// </remarks>
  /// <param name="profileId">
  /// The profile id to retrieve shared entities for
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user dynamic sent to the callback.
  /// </param>
  void getSharedEntitiesForProfileId(String profileId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.EntityServiceTargetPlayerId.Value] = profileId;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readShared, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Method gets list of entities from the server base on type and/or where clause
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - GET_LIST
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
  /// The user dynamic sent to the callback.
  /// </param>
  void getList(String whereJson, String orderByJson, int maxReturn,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(whereJson)) {
      var where = jsonDecode(whereJson);
      data[OperationParam.GlobalEntityServiceWhere.Value] = where;
    }
    if (Util.isOptionalParameterValid(orderByJson)) {
      var orderBy = jsonDecode(orderByJson);
      data[OperationParam.GlobalEntityServiceOrderBy.Value] = orderBy;
    }
    data[OperationParam.GlobalEntityServiceMaxReturn.Value] = maxReturn;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.entity, ServiceOperation.getList, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method gets list of shared entities for the specified user based on type and/or where clause
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - GET_LIST
  /// </remarks>
  /// <param name="profileId">
  /// The profile ID to retrieve shared entities for
  /// </param>
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
  /// The user dynamic sent to the callback.
  /// </param>
  void getSharedEntitiesListForProfileId(
      String profileId,
      String whereJson,
      String orderByJson,
      int maxReturn,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.EntityServiceTargetPlayerId.Value] = profileId;
    if (Util.isOptionalParameterValid(whereJson)) {
      var where = jsonDecode(whereJson);
      data[OperationParam.GlobalEntityServiceWhere.Value] = where;
    }
    if (Util.isOptionalParameterValid(orderByJson)) {
      var orderBy = jsonDecode(orderByJson);
      data[OperationParam.GlobalEntityServiceOrderBy.Value] = orderBy;
    }
    data[OperationParam.GlobalEntityServiceMaxReturn.Value] = maxReturn;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.readSharedEntitiesList, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method gets a count of entities based on the where clause
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
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
  /// The user dynamic sent to the callback.
  /// </param>
  void getListCount(String whereJson, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(whereJson)) {
      var where = jsonDecode(whereJson);
      data[OperationParam.GlobalEntityServiceWhere.Value] = where;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.entity, ServiceOperation.getListCount, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method uses a paging system to iterate through user entities.
  /// After retrieving a page of entities with this method,
  /// use GetPageOffset() to retrieve previous or next pages.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
  /// Service Operation - GetPage
  /// </remarks>
  /// <param name="jsonContext">The json context for the page request.
  /// See the portal appendix documentation for format</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback dynamic</param>
  ///
  void getPage(String jsonContext, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    var context = jsonDecode(jsonContext);
    data[OperationParam.GlobalEntityServiceContext.Value] = context;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.entity, ServiceOperation.getPage, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Method to retrieve previous or next pages after having called
  /// the GetPage method.
  /// </summary>
  /// <remarks>
  /// Service Name - Entity
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
  /// <param name="cbObject">The callback dynamic</param>
  ///
  void getPageOffset(String context, int pageOffset, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.GlobalEntityServiceContext.Value] = context;
    data[OperationParam.GlobalEntityServicePageOffset.Value] = pageOffset;

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(
        ServiceName.entity, ServiceOperation.getPageOffset, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Partial increment of entity data field items. Partial set of items incremented as specified.
  /// </summary>
  /// <remarks>
  /// Service Name - entity
  /// Service Operation - INCREMENT_USER_ENTITY_DATA
  /// </remarks>
  /// <param name="entityId">The entity to increment</param>
  /// <param name="jsonData">The subset of data to increment</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback dynamic</param>
  void incrementUserEntityData(String entityId, String jsonData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.EntityServiceEntityId.Value] = entityId;
    if (Util.isOptionalParameterValid(jsonData)) {
      var where = jsonDecode(jsonData);
      data[OperationParam.EntityServiceData.Value] = where;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.incrementUserEntityData, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Partial increment of shared entity data field items. Partial set of items incremented as specified.
  /// </summary>
  /// <remarks>
  /// Service Name - entity
  /// Service Operation - INCREMENT_SHARED_USER_ENTITY_DATA
  /// </remarks>
  /// <param name="entityId">The entity to increment</param>
  /// <param name="targetProfileId">Profile ID of the entity owner</param>
  /// <param name="jsonData">The subset of data to increment</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback dynamic</param>
  void incrementSharedUserEntityData(
      String entityId,
      String targetProfileId,
      String jsonData,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};

    data[OperationParam.EntityServiceEntityId.Value] = entityId;
    data[OperationParam.EntityServiceTargetPlayerId.Value] = targetProfileId;
    if (Util.isOptionalParameterValid(jsonData)) {
      var where = jsonDecode(jsonData);
      data[OperationParam.EntityServiceData.Value] = where;
    }

    var callback = BrainCloudClient.createServerCallback(success, failure,
        cbObject: cbObject);
    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.incrementSharedUserEntityData, data, callback);
    _clientRef.sendRequest(serverCall);
  }
}
