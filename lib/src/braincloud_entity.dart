import 'dart:async';

import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudEntity {
  final BrainCloudClient _clientRef;

  BrainCloudEntity(this._clientRef);

  /// Method creates a new entity on the server.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Create
  ///
  /// @param entityType
  /// The entity type as defined by the user
  ///
  /// @param jsonEntityData
  /// The entity's data
  ///
  /// @param jsonEntityAcl
  /// The entity's access control list as json. A null acl implies default
  /// permissions which make the entity readable/writeable by only the user.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> createEntity(
      {required String entityType,
      required Map<String, dynamic> jsonEntityData,
      Map<String, dynamic>? jsonEntityAcl}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityType.value] = entityType;
    data[OperationParam.entityServiceData.value] = jsonEntityData;
    data[OperationParam.entityServiceAcl.value] = jsonEntityAcl;

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

    var serverCall =
        ServerCall(ServiceName.entity, ServiceOperation.create, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Method returns all user entities that match the given type.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - ReadByType
  ///
  /// @param entityType
  ///
  /// The entity type to search for
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getEntitiesByType({required String entityType}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityType.value] = entityType;
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
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readByType, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method updates a new entity on the server.
  ///
  /// This operation results in the entity
  /// data being completely replaced by the passed in JSON String.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Update
  ///
  /// @param entityId
  ///
  /// The id of the entity to update
  ///
  /// @param entityType
  /// The entity type as defined by the user
  ///
  /// @param jsonEntityData
  /// The entity's data.
  ///
  /// @param jsonEntityAcl
  ///
  /// The entity's access control list as json. A null acl implies default
  /// permissions which make the entity readable/writeable by only the user.
  ///
  /// @param version
  ///
  /// Current version of the entity. If the version of the
  /// entity on the server does not match the version passed in, the
  /// server operation will fail. Use -1 to skip version checking.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateEntity(
      {required String entityId,
      required String entityType,
      required Map<String, dynamic> jsonEntityData,
      Map<String, dynamic>? jsonEntityAcl,
      required int version}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityId.value] = entityId;
    data[OperationParam.entityServiceEntityType.value] = entityType;

    data[OperationParam.entityServiceData.value] = jsonEntityData;

    // if (jsonEntityAcl != null) {
    data[OperationParam.entityServiceAcl.value] = jsonEntityAcl;
    // }
    data[OperationParam.entityServiceVersion.value] = version;

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

    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.update, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method updates a shared entity owned by another user. This operation results in the entity
  /// data being completely replaced by the passed in JSON String.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - UpdateShared
  ///
  /// @param entityId
  ///
  /// The id of the entity to update
  ///
  /// @param targetProfileId
  ///
  /// The id of the entity's owner
  ///
  /// @param entityType
  ///
  /// The entity type as defined by the user
  ///
  /// @param jsonEntityData
  ///
  /// The entity's data.
  ///
  /// @param version
  ///
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateSharedEntity(
      {required String entityId,
      required String targetProfileId,
      required String entityType,
      required Map<String, dynamic> jsonEntityData,
      required int version}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityId.value] = entityId;
    data[OperationParam.entityServiceTargetPlayerId.value] = targetProfileId;
    data[OperationParam.entityServiceEntityType.value] = entityType;
    data[OperationParam.entityServiceData.value] = jsonEntityData;
    data[OperationParam.entityServiceVersion.value] = version;

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

    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.updateShared, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method deletes the given entity on the server.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Delete
  ///
  /// @param entityId
  ///
  /// The id of the entity to update
  ///
  /// @param version
  ///
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deleteEntity(
      {required String entityId, required int version}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityId.value] = entityId;
    data[OperationParam.entityServiceVersion.value] = version;

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

    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.delete, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method updates a singleton entity on the server. This operation results in the entity
  /// data being completely replaced by the passed in JSON String. If the entity doesn't exist it is created.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Update_Singleton
  ///
  /// @param entityType
  ///
  /// The entity type as defined by the user
  ///
  /// @param jsonEntityData
  ///
  /// The entity's data.
  ///
  /// @param jsonEntityAcl
  ///
  /// The entity's access control list as json. A null acl implies default
  ///
  /// @param version
  ///
  /// Current version of the entity. If the version of the
  /// entity on the server does not match the version passed in, the
  /// server operation will fail. Use -1 to skip version checking.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> updateSingleton(
      {required String entityType,
      required Map<String, dynamic> jsonEntityData,
      required Map<String, int> jsonEntityAcl,
      required int version}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityType.value] = entityType;
    data[OperationParam.entityServiceData.value] = jsonEntityData;
    data[OperationParam.entityServiceAcl.value] = jsonEntityAcl;
    data[OperationParam.entityServiceVersion.value] = version;

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

    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.updateSingleton, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method deletes the given singleton on the server.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Delete
  ///
  /// @param entityType
  ///
  /// The entity type as defined by the user
  ///
  /// @param version
  ///
  /// Current version of the entity. If the version of the
  ///  entity on the server does not match the version passed in, the
  ///  server operation will fail. Use -1 to skip version checking.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> deleteSingleton(
      {required String entityType, required int version}) {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityType.value] = entityType;
    data[OperationParam.entityServiceVersion.value] = version;

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
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.deleteSingleton, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Method to get a specific entity.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - Read
  ///
  /// @param entityId
  ///
  /// The id of the entity
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getEntity({required String entityId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityId.value] = entityId;

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

    var sc =
        ServerCall(ServiceName.entity, ServiceOperation.read, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method retrieves a singleton entity on the server. If the entity doesn't exist, null is returned.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - ReadSingleton
  ///
  /// @param entityType
  ///
  /// The entity type as defined by the user
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSingleton({required String entityType}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceEntityType.value] = entityType;

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

    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readSingleton, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns a shared entity for the given profile and entity ID.
  /// An entity is shared if its ACL allows for the currently logged
  /// in user to read the data.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - READ_SHARED_ENTITY
  ///
  /// @param profileId
  ///
  /// The the profile ID of the user who owns the entity
  ///
  /// @param entityId
  ///
  /// The ID of the entity that will be retrieved
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSharedEntityForProfileId(
      {required String profileId, required String entityId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceTargetPlayerId.value] = profileId;
    data[OperationParam.entityServiceEntityId.value] = entityId;

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
    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readSharedEntity, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method returns all shared entities for the given profile id.
  /// An entity is shared if its ACL allows for the currently logged
  /// in user to read the data.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - ReadShared
  ///
  /// @param profileId
  ///
  /// The profile id to retrieve shared entities for
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSharedEntitiesForProfileId(
      {required String profileId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.entityServiceTargetPlayerId.value] = profileId;

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

    var sc = ServerCall(
        ServiceName.entity, ServiceOperation.readShared, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Method gets list of entities from the server base on type and/or where clause
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - GET_LIST
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
  /// returns Future<ServerResponse>
  Future<ServerResponse> getList(
      {required Map<String, dynamic> whereJson,
      required Map<String, int> orderByJson,
      required int maxReturn}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderByJson;
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
        ServiceName.entity, ServiceOperation.getList, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method gets list of shared entities for the specified user based on type and/or where clause
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - GET_LIST
  ///
  /// @param profileId
  ///
  /// The profile ID to retrieve shared entities for
  ///
  /// @param whereJson
  ///
  /// Mongo style query String
  ///
  /// @param orderByJson
  ///
  /// Sort order
  ///
  /// @param maxReturn
  ///
  /// The maximum number of entities to return
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSharedEntitiesListForProfileId(
      {required String profileId,
      required Map<String, dynamic> whereJson,
      required Map<String, int> orderByJson,
      required int maxReturn}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.entityServiceTargetPlayerId.value] = profileId;
    data[OperationParam.globalEntityServiceWhere.value] = whereJson;
    data[OperationParam.globalEntityServiceOrderBy.value] = orderByJson;
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

    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.readSharedEntitiesList, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method gets a count of entities based on the where clause
  /// Service Name - Entity
  ///
  /// Service Operation - GetListCount
  ///
  /// @param whereJson
  ///
  /// Mongo style query String
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getListCount(
      {required Map<String, dynamic> whereJson}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceWhere.value] = whereJson;

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
        ServiceName.entity, ServiceOperation.getListCount, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method uses a paging system to iterate through user entities.
  /// After retrieving a page of entities with this method,
  /// use GetPageOffset() to retrieve previous or next pages.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - GetPage
  ///
  /// @param jsonContextThe
  ///
  /// json context for the page request.
  ///
  /// See the portal appendix documentation for format
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getPage(
      {required Map<String, dynamic> jsonContext}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.globalEntityServiceContext.value] = jsonContext;

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
        ServiceName.entity, ServiceOperation.getPage, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Method to retrieve previous or next pages after having called
  /// the GetPage method.
  ///
  /// Service Name - Entity
  ///
  /// Service Operation - GetPageOffset
  ///
  /// @param context
  ///
  /// The context String returned from the server from a previous call
  /// to GetPage() or GetPageOffset()
  ///
  /// @param pageOffset
  ///
  /// The positive or negative page offset to fetch. Uses the last page
  /// retrieved using the context String to determine a starting point.
  ///
  /// returns Future<ServerResponse>
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

    var serverCall = ServerCall(
        ServiceName.entity, ServiceOperation.getPageOffset, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Partial increment of entity data field items. Partial set of items incremented as specified.
  ///
  /// Service Name - entity
  ///
  /// Service Operation - INCREMENT_USER_ENTITY_DATA
  ///
  /// @param entityIdThe entity to increment
  ///
  /// @param jsonDataThe subset of data to increment
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> incrementUserEntityData(
      {required String entityId,
      required Map<String, dynamic> jsonData}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.entityServiceEntityId.value] = entityId;
    data[OperationParam.entityServiceData.value] = jsonData;

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

    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.incrementUserEntityData, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Partial increment of shared entity data field items. Partial set of items incremented as specified.
  ///
  /// Service Name - entity
  ///
  /// Service Operation - INCREMENT_SHARED_USER_ENTITY_DATA
  ///
  /// @param entityIdThe
  /// entity to increment
  ///
  /// @param targetProfileIdProfile
  ///  ID of the entity owner
  ///
  /// @param jsonDataThe
  ///  subset of data to increment
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> incrementSharedUserEntityData(
      {required String entityId,
      required String targetProfileId,
      required Map<String, dynamic> jsonData}) async {
    Map<String, dynamic> data = {};

    data[OperationParam.entityServiceEntityId.value] = entityId;
    data[OperationParam.entityServiceTargetPlayerId.value] = targetProfileId;
    data[OperationParam.entityServiceData.value] = jsonData;

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

    var serverCall = ServerCall(ServiceName.entity,
        ServiceOperation.incrementSharedUserEntityData, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
