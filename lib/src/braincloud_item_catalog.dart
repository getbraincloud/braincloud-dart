// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudItemCatalog {
  final BrainCloudClient _clientRef;

  BrainCloudItemCatalog(this._clientRef);

  /// Reads an existing item definition from the server, with language fields
  /// limited to the current or default language.
  /// Service Name - ItemCatalog
  /// Service Operation - GET_CATALOG_ITEM_DEFINITION
  ///
  /// @param in_defId The identifier of the catalog item definition to retrieve
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getCatalogItemDefinition({required String defId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.itemCatalogServiceDefId.value] = defId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemDefinition, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieve a page of catalog items from the server, with language fields
  /// limited to the text for the current or default language.
  /// Service Name - ItemCatalog
  /// Service Operation - GET_CATALOG_ITEMS_PAGE
  ///
  /// @param in_context The pagination context returned from a previous catalog page request
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getCatalogItemsPage(
      {required Map<String, dynamic> context}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.itemCatalogServiceContext.value] = context;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Gets a page of catalog items from the server based on the encoded
  /// context and specified page offset, with language fields limited to the
  /// text for the current or default language.
  /// Service Name - ItemCatalog
  /// Service Operation - GET_CATALOG_ITEMS_PAGE_OFFSET
  ///
  /// @param in_context The pagination context returned from a previous catalog page request
  /// @param in_pageOffset The page offset relative to the current context
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getCatalogItemsPageOffset(
      {required String context, required int pageOffset}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.itemCatalogServiceContext.value] = context;
    data[OperationParam.itemCatalogServicePageOffset.value] = pageOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
