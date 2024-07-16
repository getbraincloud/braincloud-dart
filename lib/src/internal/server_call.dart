import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class ServerCall {
  late ServerCallback? _callback;
  late Map<String, dynamic>? _jsonData;
  ServiceOperation _operation;
  ServiceName _service;

  ServerCall(this._service, this._operation, this._jsonData, this._callback);

  int _id = BrainCloudComms.noPacketExpected;

  int get PacketID => _id;
  set PacketID(int value) => _id = value;

  /// <summary>
  /// Get the type of operation to perform with this service. This value usually represents
  /// a particular server method, ie: read, update, create...
  /// </param>
  /// <returns>The operation</returns>
  ServiceOperation get GetOperation => _operation;

  /// <summary>
  /// Get the service name (or type) for this service. This value is usually mapped to
  /// a particular server key used to identify this service.
  /// </param>
  /// <returns> Name to identify what type of service this is.</returns>
  ServiceName get GetService => _service;

  ServerCallback? get GetCallback => _callback;

  /// <summary>
  /// Get the Json Data associated for this service. The original json data going out
  /// with the server call
  /// </param>
  /// <returns> Name to identify what type of service this is.</returns>
  Map<String, dynamic>? get GetJsonData => _jsonData;
}
