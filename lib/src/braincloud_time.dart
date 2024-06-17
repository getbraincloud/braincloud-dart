import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudTime {
  final BrainCloudClient _clientRef;

  BrainCloudTime(this._clientRef);

  /// <summary>
  /// Method returns the server time in UTC. This is in UNIX millis time format.
  /// For instance 1396378241893 represents 2014-04-01 2:50:41.893 in GMT-4.
  /// </summary>
  /// <remarks>
  /// Service Name - Time
  /// Service Operation - Read
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void readServerTime(SuccessCallback? success, FailureCallback? failure,
      {dynamic cbObject}) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc =
        ServerCall(ServiceName.Time, ServiceOperation.read, null, callback);
    _clientRef.sendRequest(sc);
  }
}
