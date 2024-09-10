import 'dart:async';

import 'package:braincloud_dart/src/common/acl.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_response.dart';

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
  Future<ServerResponse> createEntity(String entityType, Duration? timeToLive,
      ACL? jsonEntityAcl, Map<String, dynamic> jsonEntityData) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceTimeToLive.value] =
        timeToLive?.inMilliseconds;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
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

  Future<ServerResponse> createEntityWithIndexedId(
      String entityType,
      String indexedId,
      Duration? timeToLive,
      ACL? jsonEntityAcl,
      Map<String, dynamic> jsonEntityData) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityType.value] = entityType;
    data[OperationParam.globalEntityServiceIndexedId.value] = indexedId;
    data[OperationParam.globalEntityServiceTimeToLive.value] =
        timeToLive?.inMilliseconds;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.createWithIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> updateEntity(
      String entityId, int version, Map<String, dynamic> jsonEntityData) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceData.value] = jsonEntityData;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> updateEntityAcl(
      String entityId, int version, ACL jsonEntityAcl) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceAcl.value] = jsonEntityAcl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.updateAcl, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> updateEntityTimeToLive(
      String entityId, int version, Duration timeToLive) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceTimeToLive.value] =
        timeToLive.inMilliseconds;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateTimeToLive, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> deleteEntity(String entityId, int version) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.delete, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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

  Future<ServerResponse> readEntity(String entityId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> getList(Map<String, dynamic> whereJson,
      Map<String, int> orderByJson, int maxReturn) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderByJson;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getList, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> getListByIndexedId(
      String entityIndexedId, int maxReturn) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListByIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> getListCount(Map<String, dynamic> whereJson) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListCount, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// <summary>
  /// Get a count of entities from the server base on where clause and hinting on index hint.
  /// Where clause allows entityType, createdAt, updatedAt, data items.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  /// </remarks>
  /// <param name="whereJson">
  /// Mongo style query
  /// </param>
  /// <param name="hintJson">
  /// The field index keys to be hinted, as JSON object.
  /// </param>
  Future<ServerResponse> getListCountWithHint(
      Map<String, dynamic> whereJson, Map<String, dynamic> hintJson) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListCountWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// <summary>
  /// Get a count of entities from the server base on where clause and hinting on index hint.
  /// Where clause allows entityType, createdAt, updatedAt, data items.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalEntity
  /// Service Operation - GetListCount
  /// </remarks>
  /// <param name="whereJson">
  /// Mongo style query
  /// </param>
  /// <param name="orderByJson">
  /// Sort order
  /// </param>
  /// <param name="maxReturn">
  /// The maximum number of entities to return
  /// </param>
  /// <param name="hintJson">
  /// The field index keys to be hinted, as JSON object.
  /// </param>
  Future<ServerResponse> getListWithHint(
      Map<String, dynamic> whereJson,
      Map<String, int> orderByJson,
      int maxReturn,
      Map<String, dynamic> hintJson) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderByJson;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getListWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  ///
  Future<ServerResponse> getPage(Map<String, dynamic> jsonContext) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceContext.value] = jsonContext;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(
        ServiceName.globalEntity, ServiceOperation.getPage, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  ///
  Future<ServerResponse> getPageOffset(String context, int pageOffset) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceContext.value] = context;
    data[OperationParam.globalEntityServicePageOffset.value] = pageOffset;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getPageOffset, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> incrementGlobalEntityData(
      String entityId, Map<String, dynamic> jsonData) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceData.value] = jsonData;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.incrementGlobalEntityData, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> getRandomEntitiesMatching(
      Map<String, dynamic> whereJson, int maxReturn) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getRandomEntitiesMatching, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// <summary>
  /// Gets a list of up to randomCount randomly selected entities from the server based on the where condition and specified maximum return count.
  /// </summary>
  /// <remarks>
  /// Service Name - globalEntity
  /// Service Operation - GET_RANDOM_ENTITIES_MATCHING
  /// </remarks>
  /// <param name="where">Mongo style query</param>
  /// <param name="maxReturn">The maximum number of entities to return</param>
  /// <param name="hintJson">The field index keys to be hinted, as JSON object.</param>
  Future<ServerResponse> getRandomEntitiesMatchingWithHint(
      Map<String, dynamic> whereJson,
      Map<String, dynamic> hintJson,
      int maxReturn) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceHint.value] = hintJson;
    data[OperationParam.globalEntityServiceMaxReturn.value] = maxReturn;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.getRandomEntitiesMatchingWithHint, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> updateEntityIndexedId(
      String entityId, int version, String entityIndexedId) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceIndexedId.value] = entityIndexedId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityIndexedId, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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
  Future<ServerResponse> updateEntityOwnerAndAcl(
      String entityId, int version, String ownerId, ACL acl) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.ownerId.value] = ownerId;
    data[OperationParam.globalEntityServiceAcl.value] = acl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.updateEntityOwnerAndAcl, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
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

  Future<ServerResponse> makeSystemEntity(
      String entityId, int version, ACL acl) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalEntityServiceEntityId.value] = entityId;
    data[OperationParam.globalEntityServiceVersion.value] = version;
    data[OperationParam.globalEntityServiceAcl.value] = acl;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    var serverCall = ServerCall(ServiceName.globalEntity,
        ServiceOperation.makeSystemEntity, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
