import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';

class EndOfBundleMarker extends ServerCall {
  EndOfBundleMarker()
      : super(ServiceName.heartBeat, ServiceOperation.send, null, null);
}
