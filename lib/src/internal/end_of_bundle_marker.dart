import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';

class EndOfBundleMarker extends ServerCall {
  EndOfBundleMarker()
      : super(ServiceName.HeartBeat, ServiceOperation.send, null, null);
}
