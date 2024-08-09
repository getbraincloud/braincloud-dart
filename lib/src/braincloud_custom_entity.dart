import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudCustomEntity {
  final BrainCloudClient _clientRef;

  BrainCloudCustomEntity(this._clientRef);

  /// <summary>
  /// Creates a Custom Entity
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - CreateCustomEntity
  /// </remarks>
  /// <param name="entityType">
  /// The Entity Type
  /// </param>
  /// <param name="dataJson">
  /// The entity data
  /// </param>
  /// <param name="acl">
  ///
  /// <param name="isOwned">
  /// The entity data
  /// <param name="timeToLive">
  /// The Entity Type
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
      String dataJson,
      String acl,
      String timeToLive,
      bool isOwned,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceDataJson.Value] =
        jsonDecode(dataJson);
    data[OperationParam.CustomEntityServiceAcl.Value] = jsonDecode(acl);
    data[OperationParam.CustomEntityServiceTimeToLive.Value] = timeToLive;
    data[OperationParam.CustomEntityServiceIsOwned.Value] = isOwned;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.createCustomEntity, data, callback);
    _clientRef.sendRequest(sc);
  }

  void getEntityPage(String entityType, String jsonContext,
      SuccessCallback? success, FailureCallback? failure) {
    var context = jsonDecode(jsonContext);
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceContext.Value] = context;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.getEntityPage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gets the page of custom entity from the
  ///server based on the encoded context and
  ///specified page offset, with language fields
  ///limited to the text for the current or default
  ///language.
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - getCustomEntityPageOffset
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="context">
  /// </param>
  /// <param name="pageOffset">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>this good
  void getEntityPageOffset(String entityType, String context, int pageOffset,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceContext.Value] = context;
    data[OperationParam.CustomEntityServicePageOffset.Value] = pageOffset;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.getCustomEntityPageOffset, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - ReadCustomEntity
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
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
  void readEntity(String entityType, String entityId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.readCustomEntity, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///Increments the specified fields by the specified amount within custom entity data on the server, enforcing ownership/ACL permissions.
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - IncrementData
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
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
  void incrementData(String entityType, String entityId, String fieldsJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;
    data[OperationParam.CustomEntityServiceFieldsJson.Value] =
        jsonDecode(fieldsJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.incrementData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Increments the specified fields, of the singleton owned by the user, by the specified amount within the custom entity data on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - IncrementSingletonData
  /// </remarks>
  /// <param name="entityType">
  /// The type of custom entity being updated.
  /// </param>
  /// <param name="fieldsJson">
  /// Specific fields, as JSON, within entity's custom data, with respective increment amount.
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
  void incrementSingletonData(String entityType, String fieldsJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceFieldsJson.Value] =
        jsonDecode(fieldsJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.incrementSingletonData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - Custom Entity
  /// Service Operation - UpdateCustomEntity
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="dataJson">
  /// </param>
  /// <param name="acl">
  /// </param>
  /// <param name="timeToLive">
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
  void updateEntity(
      String entityType,
      String entityId,
      int version,
      String dataJson,
      String acl,
      String timeToLive,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;
    data[OperationParam.CustomEntityServiceDataJson.Value] =
        jsonDecode(dataJson);
    data[OperationParam.CustomEntityServiceAcl.Value] = jsonDecode(acl);
    data[OperationParam.CustomEntityServiceTimeToLive.Value] = timeToLive;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.updateCustomEntity, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - UpdateCustomEntityFields
  /// </remarks>
  /// <param name="context">
  /// </param>
  /// <param name="pageOffset">
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
  void updateEntityFields(String entityType, String entityId, int version,
      String fieldsJson, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;
    data[OperationParam.CustomEntityServiceFieldsJson.Value] =
        jsonDecode(fieldsJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.updateCustomEntityFields, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// For sharded custom collection entities. Sets the specified fields within custom entity data on the server, enforcing ownership/ACL permissions.
  /// </summary>
  /// <param name="entityType">
  /// The entity type as defined by the user
  /// </param>
  /// <param name="entityId"></param>
  /// <param name="version"></param>
  /// <param name="fieldsJson"></param>
  /// <param name="shardKeyJson">
  /// The shard key field(s) and value(s), as JSON, applicable to the entity being updated.
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
  void updateEntityFieldsSharded(
      String entityType,
      String entityId,
      int version,
      String fieldsJson,
      String shardKeyJson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;
    data[OperationParam.CustomEntityServiceFieldsJson.Value] =
        jsonDecode(fieldsJson);

    data[OperationParam.CustomEntityServiceShardKeyJson.Value] =
        jsonDecode(shardKeyJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.updateCustomEntityFieldsShards, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Deletes Entities based on the criteria passed in
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - DeleteEntities
  /// </remarks>
  /// <param name="entityType">
  /// The Entity Type
  /// </param>
  /// <param name="deleteCriteria">
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
  void deleteEntities(String entityType, String deleteCriteria,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceDeleteCriteria.Value] =
        jsonDecode(deleteCriteria);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.deleteEntities, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - GetCount
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="whereJson">
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
  void getCount(String entityType, String whereJson, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceWhereJson.Value] =
        jsonDecode(whereJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.CustomEntity, ServiceOperation.getCount, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - deleteCustomEntity
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
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
  void deleteEntity(String entityType, String entityId, int version,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceEntityId.Value] = entityId;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.deleteCustomEntity, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///Gets a list of up to maxReturn randomly selected custom entities from the server
  ///based on the entity type and where condition.
  /// </summary>
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - getRandomEntitiesMatching
  /// </remarks>
  /// <param name="entityType">
  /// type of entities
  /// </param>
  /// <param name="whereJson">
  /// Mongo style query string
  /// </param>
  /// <param name="maxReturn">
  /// number of max returns
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
  void getRandomEntitiesMatching(String entityType, String whereJson,
      int maxReturn, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceWhereJson.Value] =
        jsonDecode(whereJson);
    data[OperationParam.CustomEntityServiceMaxReturn.Value] = maxReturn;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.getRandomEntitiesMatching, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///Deletes the specified custom entity singleton, owned by the session's user, for the specified entity type, on the server.
  /// </summary>
  /// <remarks>
  /// Service Name - Custom Entity
  /// Service Operation - deleteSingleton
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="version">
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
  void deleteSingleton(String entityType, int version, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.deleteSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  ///Reads the custom entity singleton owned by the session's user.
  /// </summary>
  /// <remarks>
  /// Service Name - Custom Entity
  /// Service Operation - readSingleton
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="version">
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
  void readSingleton(
      String entityType, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.readSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// </summary>
  ///Partially updates the data, of the singleton owned by the user for the specified custom entity type, with the specified fields, on the server
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation - updateSingletonFields
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
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
  void updateSingletonFields(String entityType, int version, String fieldsJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;
    data[OperationParam.CustomEntityServiceFieldsJson.Value] =
        jsonDecode(fieldsJson);

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.updateSingletonFields, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// </summary>
  ///Updates the singleton owned by the user for the specified custom entity type on the server, creating the singleton if it does not exist. This operation results in the owned singleton's data being completely replaced by the passed in JSON object.
  /// <remarks>
  /// Service Name - CustomEntity
  /// Service Operation -UpdateSingleton
  /// </remarks>
  /// <param name="entityType">
  /// </param>
  /// <param name="entityId">
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
  void updateSingleton(
      String entityType,
      int version,
      String dataJson,
      String acl,
      String timeToLive,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.CustomEntityServiceEntityType.Value] = entityType;
    data[OperationParam.CustomEntityServiceVersion.Value] = version;
    data[OperationParam.CustomEntityServiceDataJson.Value] =
        jsonDecode(dataJson);
    data[OperationParam.CustomEntityServiceAcl.Value] = jsonDecode(acl);
    data[OperationParam.CustomEntityServiceTimeToLive.Value] = timeToLive;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.CustomEntity,
        ServiceOperation.updateSingleton, data, callback);
    _clientRef.sendRequest(sc);
  }
}
