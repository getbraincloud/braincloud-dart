import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudItemCatalog {
  final BrainCloudClient _clientRef;

  BrainCloudItemCatalog(this._clientRef);

  /// <summary>
  /// Reads an existing item definition from the
  ///server, with language fields limited to the
  /// current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  /// </remarks>
  /// <param name="defId">
  /// </param>
  Future<ServerResponse> getCatalogItemDefinition({required String defId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.itemCatalogServiceDefId.value] = defId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemDefinition, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Retrieves page of catalog items from the server,
  ///with language fields limited to the text for the
  ///current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  /// </remarks>
  /// <param name="context">
  /// </param>
  Future<ServerResponse> getCatalogItemsPage({required String context}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    var contextData = jsonDecode(context);
    data[OperationParam.itemCatalogServiceContext.value] = contextData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Gets the page of catalog items from the
  ///server based on the encoded context and
  ///specified page offset, with language fields
  ///limited to the text for the current or default
  ///language.
  /// </summary>
  /// <remarks>
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  /// </remarks>
  /// <param name="context">
  /// </param>
  /// <param name="pageOffset">
  /// </param>
  Future<ServerResponse> getCatalogItemsPageOffset(
      {required String context, required int pageOffset}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.itemCatalogServiceContext.value] = context;
    data[OperationParam.itemCatalogServicePageOffset.value] = pageOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
