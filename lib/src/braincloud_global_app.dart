import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudGlobalApp {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalApp(this._clientRef);

  /// Method reads all the global properties of the game
  ///
  /// Service Name - GlobalApp
  /// Service Operation - ReadProperties
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> readProperties() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(
        ServiceName.globalApp, ServiceOperation.readProperties, null, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Returns a list of properties, identified by the propertyNames provided.
  /// If a property from the list isn't found, it just isn't returned (no error).
  ///
  /// Service Name - GlobalApp
  /// Service Operation - ReadSelectedProperties
  ///
  /// @param propertyNames
  /// Specifies which properties to return
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readSelectedProperties, data, callback);
    _clientRef.sendRequest(serverCall);
    return completer.future;
  }

  /// Returns a list of properties, identified by the categories provided.
  ///
  /// If a category from the list isn't found, it just isn't returned (no error).
  ///
  /// Service Name - GlobalApp
  /// Service Operation - ReadPropertiesInCategories
  ///
  /// @param categories
  /// Specifies which categories to return
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readPropertiesInCategories, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
