import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudGlobalApp {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalApp(this._clientRef);

  /// <summary>
  /// Method reads all the global properties of the game
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalApp
  /// Service Operation - ReadProperties
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void readProperties(SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(
        ServiceName.globalApp, ServiceOperation.readProperties, null, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Returns a list of properties, identified by the propertyNames provided.
  /// If a property from the list isn't found, it just isn't returned (no error).
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalApp
  /// Service Operation - ReadSelectedProperties
  /// </remarks>
  /// <param name="propertyNames">
  /// Specifies which properties to return
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void readSelectedProperties(List<String> propertyNames,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalAppPropertyNames.value] = propertyNames;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readSelectedProperties, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Returns a list of properties, identified by the categories provided.
  /// If a category from the list isn't found, it just isn't returned (no error).
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalApp
  /// Service Operation - ReadPropertiesInCategories
  /// </remarks>
  /// <param name="categories">
  /// Specifies which categories to return
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void readPropertiesInCategories(List<String> categories,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalAppCategories.value] = categories;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(ServiceName.globalApp,
        ServiceOperation.readPropertiesInCategories, data, callback);
    _clientRef.sendRequest(serverCall);
  }
}
