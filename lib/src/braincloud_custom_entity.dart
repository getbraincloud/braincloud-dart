import 'dart:async';

import 'package:braincloud_dart/src/common/acl.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudCustomEntity {
  final BrainCloudClient _clientRef;

  BrainCloudCustomEntity(this._clientRef);

  /// Creates a Custom Entity
  ///
  /// Service Name - CustomEntity
  /// Service Operation - CreateCustomEntity
  ///
  /// @param entityType
  /// The Entity Type
  ///
  /// @param dataJson
  /// The entity data
  ///
  /// @param acl
  ///
  /// @param isOwned
  /// The entity data
  /// @param timeToLive
  /// The Entity Type
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> createEntity(
      String entityType,
      Map<String, dynamic> dataJson,
      ACL acl,
      Duration timeToLive,
      bool isOwned) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceDataJson.value] = dataJson;
    data[OperationParam.customEntityServiceAcl.value] = acl;
    data[OperationParam.customEntityServiceTimeToLive.value] =
        timeToLive.inMilliseconds;
    data[OperationParam.customEntityServiceIsOwned.value] = isOwned;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.createCustomEntity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves the first page of custom entities from
  /// the server based on the custom entity type and
  /// specified query context.
  ///language.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - getCustomEntityPageOffset
  ///
  /// @param entityType
  ///
  /// @param context
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getEntityPage(
      String entityType, Map<String, dynamic> jsonContext) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceContext.value] = jsonContext;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.getEntityPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gets the page of custom entity from the
  ///server based on the encoded context and
  ///specified page offset, with language fields
  ///limited to the text for the current or default
  ///language.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - getCustomEntityPageOffset
  ///
  /// @param entityType
  ///
  /// @param context
  ///
  /// @param pageOffset
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getEntityPageOffset(
      String entityType, String context, int pageOffset) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceContext.value] = context;
    data[OperationParam.customEntityServicePageOffset.value] = pageOffset;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.getCustomEntityPageOffset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Service Name - CustomEntity
  /// Service Operation - ReadCustomEntity
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> readEntity(String entityType, String entityId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.readCustomEntity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Increments the specified fields by the specified amount within custom entity data on the server, enforcing ownership/ACL permissions.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - IncrementData
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> incrementData(String entityType, String entityId,
      Map<String, dynamic> fieldsJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.incrementData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Increments the specified fields by the specified amount within custom entity data on the server, enforcing ownership/ACL permissions.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - IncrementData
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// @param shardKeyJson
  /// The shard key field(s) and value(s), as JSON, applicable to the entity being updated. If entity is owned, ownerId must be specified in the shardKeyJson info; otherwise, shardKeyJson must indicate values for all fields in the applicable shard key index.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> incrementDataSharded(
      String entityType,
      String entityId,
      Map<String, dynamic> fieldsJson,
      Map<String, dynamic> shardKeyJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;
    data[OperationParam.customEntityServiceShardKeyJson.value] = shardKeyJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.incrementDataSharded, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Increments the specified fields, of the singleton owned by the user, by the specified amount within the custom entity data on the server.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - IncrementSingletonData
  ///
  /// @param entityType
  /// The type of custom entity being updated.
  ///
  /// @param fieldsJson
  /// Specific fields, as JSON, within entity's custom data, with respective increment amount.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> incrementSingletonData(
      String entityType, Map<String, dynamic> fieldsJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.incrementSingletonData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Service Name - Custom Entity
  /// Service Operation - UpdateCustomEntity
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// @param version
  ///
  /// @param dataJson
  ///
  /// @param acl
  ///
  /// @param timeToLive
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateEntity(
      String entityType,
      String entityId,
      int version,
      Map<String, dynamic> dataJson,
      ACL acl,
      Duration timeToLive) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceVersion.value] = version;
    data[OperationParam.customEntityServiceDataJson.value] = dataJson;
    data[OperationParam.customEntityServiceAcl.value] = acl;
    data[OperationParam.customEntityServiceTimeToLive.value] =
        timeToLive.inMilliseconds;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.updateCustomEntity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Service Name - CustomEntity
  /// Service Operation - UpdateCustomEntityFields
  ///
  /// @param context
  ///
  /// @param pageOffset
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateEntityFields(String entityType, String entityId,
      int version, Map<String, dynamic> fieldsJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceVersion.value] = version;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.updateCustomEntityFields, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// For sharded custom collection entities. Sets the specified fields within custom entity data on the server, enforcing ownership/ACL permissions.
  ///
  /// @param entityType
  /// The entity type as defined by the user
  ///
  /// @param entityId
  ///
  /// @param version
  ///
  /// @param fieldsJson
  ///
  /// @param shardKeyJson
  /// The shard key field(s) and value(s), as JSON, applicable to the entity being updated.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateEntityFieldsSharded(
      String entityType,
      String entityId,
      int version,
      Map<String, dynamic> fieldsJson,
      Map<String, dynamic> shardKeyJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceVersion.value] = version;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;
    data[OperationParam.customEntityServiceShardKeyJson.value] = shardKeyJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.updateCustomEntityFieldsShards, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deletes Entities based on the criteria passed in
  ///
  /// Service Name - CustomEntity
  /// Service Operation - DeleteEntities
  ///
  /// @param entityType
  /// The Entity Type
  ///
  /// @param deleteCriteria
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deleteEntities(
      String entityType, Map<String, dynamic> deleteCriteria) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceDeleteCriteria.value] =
        deleteCriteria;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.deleteEntities, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Service Name - CustomEntity
  /// Service Operation - GetCount
  ///
  /// @param entityType
  ///
  /// @param whereJson
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getCount(
      String entityType, Map<String, dynamic> whereJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceWhereJson.value] = whereJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.customEntity, ServiceOperation.getCount, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Service Name - CustomEntity
  /// Service Operation - deleteCustomEntity
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deleteEntity(
      String entityType, String entityId, int version) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceEntityId.value] = entityId;
    data[OperationParam.customEntityServiceVersion.value] = version;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.deleteCustomEntity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Gets a list of up to maxReturn randomly selected custom entities from the server
  ///based on the entity type and where condition.
  ///
  /// Service Name - CustomEntity
  /// Service Operation - getRandomEntitiesMatching
  ///
  /// @param entityType
  /// type of entities
  ///
  /// @param whereJson
  /// Mongo style query string
  ///
  /// @param maxReturn
  /// number of max returns
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getRandomEntitiesMatching(
      String entityType, Map<String, dynamic> whereJson, int maxReturn) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceWhereJson.value] = whereJson;
    data[OperationParam.customEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.getRandomEntitiesMatching, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Deletes the specified custom entity singleton, owned by the session's user, for the specified entity type, on the server.
  ///
  /// Service Name - Custom Entity
  /// Service Operation - deleteSingleton
  ///
  /// @param entityType
  ///
  /// @param version
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deleteSingleton(String entityType, int version) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceVersion.value] = version;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.deleteSingleton, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Reads the custom entity singleton owned by the session's user.
  ///
  /// Service Name - Custom Entity
  /// Service Operation - readSingleton
  ///
  /// @param entityType
  ///
  /// @param version
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> readSingleton(String entityType) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.readSingleton, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  ///Partially updates the data, of the singleton owned by the user for the specified custom entity type, with the specified fields, on the server
  ///
  /// Service Name - CustomEntity
  /// Service Operation - updateSingletonFields
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateSingletonFields(
      String entityType, int version, Map<String, dynamic> fieldsJson) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceVersion.value] = version;
    data[OperationParam.customEntityServiceFieldsJson.value] = fieldsJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.updateSingletonFields, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates the singleton owned by the user for the specified custom entity type on the server, creating the singleton if it does not exist. This operation results in the owned singleton's data being completely replaced by the passed in JSON object.
  ///
  /// Service Name - CustomEntity
  /// Service Operation -UpdateSingleton
  ///
  /// @param entityType
  ///
  /// @param entityId
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateSingleton(String entityType, int version,
      Map<String, dynamic> dataJson, ACL acl, Duration timeToLive) async {
    Map<String, dynamic> data = {};
    data[OperationParam.customEntityServiceEntityType.value] = entityType;
    data[OperationParam.customEntityServiceVersion.value] = version;
    data[OperationParam.customEntityServiceDataJson.value] = dataJson;
    data[OperationParam.customEntityServiceAcl.value] = acl;
    data[OperationParam.customEntityServiceTimeToLive.value] =
        timeToLive.inMilliseconds;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(ServiceName.customEntity,
        ServiceOperation.updateSingleton, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
