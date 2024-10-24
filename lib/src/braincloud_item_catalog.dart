import 'dart:async';

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

  /// Reads an existing item definition from the
  ///server, with language fields limited to the
  /// current or default language.
  ///
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  ///
  /// @param defId
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemDefinition, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves page of catalog items from the server,
  ///with language fields limited to the text for the
  ///current or default language.
  ///
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  ///
  /// @param context
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPage, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Gets the page of catalog items from the
  ///server based on the encoded context and
  ///specified page offset, with language fields
  ///limited to the text for the current or default
  ///language.
  ///
  /// Service Name - ItemCatalog
  /// Service Operation - GetCatalogItemDefinition
  ///
  /// @param context
  ///
  /// @param pageOffset
  ///
  /// returns Future<ServerResponse>
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
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.itemCatalog,
        ServiceOperation.getCatalogItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
