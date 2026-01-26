// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudGlobalApp {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalApp(this._clientRef);

  /// Read game's global properties
  /// Service Name - GlobalApp
  /// Service Operation - ReadProperties
  ///
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> readProperties() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(
        ServiceName.globalApp, ServiceOperation.readProperties, null, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Returns a list of properties, identified by the property names provided.
  /// If a property from the list isn't found, it just isn't returned (no error).
  /// Service Name - GlobalApp
  /// Service Operation - READ_SELECTED_PROPERTIES
  ///
  /// @param propertyNames Specifies which properties to return
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> readSelectedProperties(
      {required List<String> propertyNames}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.globalAppPropertyNames.value] = propertyNames;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readSelectedProperties, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Returns a list of properties, identified by the categories provided.
  /// If a category from the list isn't found, it just isn't returned (no error).
  /// Service Name - GlobalApp
  /// Service Operation - READ_PROPERTIES_IN_CATEGORIES
  ///
  /// @param categories Specifies which category to return
  /// @param in_callback The method to be invoked when the server response is received
  ///
  Future<ServerResponse> readPropertiesInCategories(
      {required List<String> categories}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.globalAppCategories.value] = categories;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readPropertiesInCategories, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
