import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudTime {
  final BrainCloudClient _clientRef;

  BrainCloudTime(this._clientRef);

  /// Method returns the server time in UTC. This is in UNIX millis time format.
  /// 
  /// For instance 1396378241893 represents 2014-04-01 2:50:41.893 in GMT-4.
  /// 
  /// Service Name - Time
  /// Service Operation - Read
  /// 
  /// returns Future<ServerResponse>
  Future<ServerResponse> readServerTime() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc =
        ServerCall(ServiceName.time, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
