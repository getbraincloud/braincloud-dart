import '/src/internal/braincloud_comms.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';

class ServerCall {
  final ServerCallback? _callback;
  final Map<String, dynamic>? _jsonData;
  final ServiceOperation _operation;
  final ServiceName _service;

  ServerCall(this._service, this._operation, this._jsonData, this._callback);

  int packetID = BrainCloudComms.noPacketExpected;

  /// Get the type of operation to perform with this service. This value usually represents
  /// a particular server method, ie: read, update, create...

  /// returns The operation
  ServiceOperation get getOperation => _operation;

  /// Get the service name (or type) for this service. This value is usually mapped to
  /// a particular server key used to identify this service.

  /// returns  Name to identify what type of service this is.
  ServiceName get getService => _service;

  ServerCallback? get getCallback => _callback;

  /// Get the Json Data associated for this service. The original json data going out
  /// with the server call

  /// returns  Name to identify what type of service this is.
  Map<String, dynamic>? get getJsonData => _jsonData;
}
