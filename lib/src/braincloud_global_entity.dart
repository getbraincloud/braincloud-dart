import 'dart:async';

import '/src/common/acl.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/braincloud_client.dart';
import '/src/server_response.dart';

class BrainCloudGlobalEntity {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalEntity(this._clientRef);

  /// Method creates a new entity on the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - Create
  ///
  /// @param entityType
  /// The entity type as defined by the user
  ///
  /// @param timeToLive
  /// Sets expiry time for entity in milliseconds if > 0
  ///
  /// @param jsonEntityAcl
  /// The entity's access control list as json. A null acl implies default
  ///
  /// @param jsonEntityData
  /// The entity's data
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> createEntity(
      {required String entityType,
      int? timeToLive,
      ACL? jsonEntityAcl,
      required Map<String, dynamic> jsonEntityData}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Method creates a new entity on the server with an indexed id.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - CreateWithIndexedId
  ///
  /// @param entityType
  /// The entity type as defined by the user
  ///
  /// @param indexedId
  /// A secondary ID that will be indexed
  ///
  /// @param timeToLive
  /// Sets expiry time for entity in milliseconds if > 0
  ///
  /// @param jsonEntityAcl
  /// The entity's access control list as json. A null acl implies default
  ///
  /// @param jsonEntityData
  /// The entity's data
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> createEntityWithIndexedId(
      {required String entityType,
      required String indexedId,
      int? timeToLive,
      ACL? jsonEntityAcl,
      required Map<String, dynamic> jsonEntityData}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceIndexedId.value] = indexedId;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.createWithIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method updates an existing entity on the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - Update
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity to update
  ///
  /// @param jsonEntityData
  /// The entity's data
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateEntity(
      {required String entityId,
      required int version,
      required Map<String, dynamic> jsonEntityData}) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method updates an existing entity's Acl on the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - UpdateAcl
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity to update
  ///
  /// @param jsonEntityAcl
  /// The entity's access control list as json.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateEntityAcl(
      {required String entityId,
      required int version,
      required ACL jsonEntityAcl}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.updateAcl, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method updates an existing entity's time to live on the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - UpdateTimeToLive
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity to update
  ///
  /// @param timeToLive
  /// Sets expiry time for entity in milliseconds if > 0
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateEntityTimeToLive(
      {required String entityId,
      required int version,
      required int timeToLive}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceTimeToLive.value] = timeToLive;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateTimeToLive, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method deletes an existing entity on the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - Delete
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity to delete
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> deleteEntity(
      {required String entityId, required int version}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.delete, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method reads an existing entity from the server.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - Read
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> readEntity({required String entityId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method gets list of entities from the server base on type and/or where clause
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetList
  ///
  /// @param whereJson
  /// Mongo style query String
  ///
  /// @param orderByJson
  /// Sort order
  ///
  /// @param maxReturn
  /// The maximum number of entities to return
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getList(
      {required Map<String, dynamic> where,
      required Map<String, int> orderBy,
      required int maxReturn}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderBy;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getList, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method gets list of entities from the server base on indexed id
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetListByIndexedId
  ///
  /// @param entityIndexedId
  /// The entity indexed Id
  ///
  /// @param maxReturn
  /// The maximum number of entities to return
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getListByIndexedId(
      {required String entityIndexedId, required int maxReturn}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListByIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method gets a count of entities based on the where clause
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  ///
  /// @param whereJson
  /// Mongo style query String
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getListCount(
      {required Map<String, dynamic> where}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListCount, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Get a count of entities from the server base on where clause and hinting on index hint.
  /// Where clause allows entityType, createdAt, updatedAt, data items.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  ///
  /// @param whereJson
  /// Mongo style query
  ///
  /// @param hintJson
  /// The field index keys to be hinted, as JSON object.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getListCountWithHint(
      {required Map<String, dynamic> where,
      required Map<String, dynamic> hintJson}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListCountWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Get a count of entities from the server base on where clause and hinting on index hint.
  /// Where clause allows entityType, createdAt, updatedAt, data items.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  ///
  /// @param whereJson
  /// Mongo style query
  ///
  /// @param orderByJson
  /// Sort order
  ///
  /// @param maxReturn
  /// The maximum number of entities to return
  ///
  /// @param hintJson
  /// The field index keys to be hinted, as JSON object.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getListWithHint(
      {required Map<String, dynamic> where,
      required Map<String, int> orderBy,
      required int maxReturn,
      required Map<String, dynamic> hintJson}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderBy;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method uses a paging system to iterate through Global Entities.
  /// After retrieving a page of Global Entities with this method,
  /// use GetPageOffset() to retrieve previous or next pages.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetPage
  ///
  /// @param jsonContextThe json context for the page request.
  /// See the portal appendix documentation for format
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPage(
      {required Map<String, dynamic> context}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceContext.value] = context;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getPage, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method to retrieve previous or next pages after having called
  /// the GetPage method.
  ///
  /// Service Name - GlobalEntity
  /// Service Operation - GetPageOffset
  ///
  /// @param context
  /// The context String returned from the server from a previous call
  /// to GetPage() or GetPageOffset()
  ///
  /// @param pageOffset
  /// The positive or negative page offset to fetch. Uses the last page
  /// retrieved using the context String to determine a starting point.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getPageOffset(
      {required String context, required int pageOffset}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceContext.value] = context;
    data[OperationParam.globalEntityServicePageOffset.value] = pageOffset;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getPageOffset, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Partial increment of global entity data field items. Partial set of items incremented as specified.
  ///
  /// Service Name - globalEntity
  /// Service Operation - INCREMENT_GLOBAL_ENTITY_DATA
  ///
  /// @param entityIdThe entity to increment
  ///
  /// @param jsonDataThe subset of data to increment
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> incrementGlobalEntityData(
      {required String entityId,
      required Map<String, dynamic> jsonEntityData}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.incrementGlobalEntityData, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Gets a list of up to randomCount randomly selected entities from the server based on the where condition and specified maximum return count.
  ///
  /// Service Name - globalEntity
  /// Service Operation - GET_RANDOM_ENTITIES_MATCHING
  ///
  /// @param whereMongo style query String
  ///
  /// @param maxReturnThe maximum number of entities to return
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getRandomEntitiesMatching(
      {required Map<String, dynamic> where, required int maxReturn}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getRandomEntitiesMatching, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Gets a list of up to randomCount randomly selected entities from the server based on the where condition and specified maximum return count.
  ///
  /// Service Name - globalEntity
  /// Service Operation - GET_RANDOM_ENTITIES_MATCHING
  ///
  /// @param whereMongo style query
  ///
  /// @param maxReturnThe maximum number of entities to return
  ///
  /// @param hintJsonThe field index keys to be hinted, as JSON object.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getRandomEntitiesMatchingWithHint(
      {required Map<String, dynamic> where,
      required Map<String, dynamic> hintJson,
      required int maxReturn}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = where;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getRandomEntitiesMatchingWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method updates an existing entity's Indexed Id.
  ///
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_INDEXED_ID
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity
  ///
  /// @param entityIndexedId
  /// The id index of the entity
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateEntityIndexedId(
      {required String entityId,
      required int version,
      required String entityIndexedId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method updates an existing entity's Owner and Acl on the server.
  ///
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_OWNER_AND_ACL
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity
  ///
  /// @param ownerId
  /// The owner ID
  ///
  /// @param acl
  /// The entity's access control list
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> updateEntityOwnerAndAcl(
      {required String entityId,
      required int version,
      required String ownerId,
      required ACL jsonEntityAcl}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.ownerId.value] = ownerId;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityOwnerAndAcl, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method clears the owner id of an existing entity and sets the Acl on the server.
  ///
  /// Service Name - globalEntity
  /// Service Operation - UPDATE_ENTITY_OWNER_AND_ACL
  ///
  /// @param entityId
  /// The entity ID
  ///
  /// @param version
  /// The version of the entity
  ///
  /// @param acl
  /// The entity's access control list
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> makeSystemEntity(
      {required String entityId,
      required int version,
      required ACL jsonEntityAcl}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.makeSystemEntity, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
