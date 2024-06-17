import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getCatalogItemDefinition(String defId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.ItemCatalogServiceDefId.Value] = defId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.ItemCatalog,
        ServiceOperation.getCatalogItemDefinition, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getCatalogItemsPage(String context, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    var contextData = jsonDecode(context);
    data[OperationParam.ItemCatalogServiceContext.Value] = contextData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.ItemCatalog,
        ServiceOperation.getCatalogItemsPage, data, callback);
    _clientRef.sendRequest(sc);
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
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getCatalogItemsPageOffset(String context, int pageOffset,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.ItemCatalogServiceContext.Value] = context;
    data[OperationParam.ItemCatalogServicePageOffset.Value] = pageOffset;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.ItemCatalog,
        ServiceOperation.getCatalogItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);
  }
}
