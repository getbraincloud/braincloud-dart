import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudEvent {
  final BrainCloudClient _clientRef;

  BrainCloudEvent(this._clientRef);

  /// Sends an event to the designated profile id with the attached json data.
  /// Any events that have been sent to a user will show up in their
  /// incoming event mailbox. If the recordLocally flag is set to true,
  /// a copy of this event (with the exact same event id) will be stored
  /// in the sending user's "sent" event mailbox.

  /// Service Name - Event
  /// Service Operation - Send

  /// @param toProfileId
  /// The id of the user who is being sent the event

  /// @param eventType
  /// The user-defined type of the event.

  /// @param jsonEventData
  /// The user-defined data for this event encoded in JSON.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> sendEvent(
      {required String toProfileId,
      required String eventType,
      Map<String, dynamic>? jsonEventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.eventServiceSendToId.value] = toProfileId;
    data[OperationParam.eventServiceSendEventType.value] = eventType;

    if (jsonEventData != null) {
      data[OperationParam.eventServiceSendEventData.value] = jsonEventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc =
        ServerCall(ServiceName.event, ServiceOperation.send, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Updates an event in the user's incoming event mailbox.

  /// Service Name - Event
  /// Service Operation - UpdateEventData

  /// @param evId
  /// The event id

  /// @param jsonEventData
  /// The user-defined data for this event encoded in JSON.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateIncomingEventData(
      {required String evId, Map<String, dynamic>? jsonEventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    if (jsonEventData != null) {
      data[OperationParam.eventServiceUpdateEventDataData.value] =
          jsonEventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.updateEventData, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Updates an event in the user's incoming event mailbox.
  /// Returns the same data as UpdateIncomingEventData, but does not return an error if the event does not exist.

  /// Service Name - Event
  /// Service Operation - UpdateEventData

  /// @param evId
  /// The event id

  /// @param jsonEventData
  /// The user-defined data for this event encoded in JSON.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateIncomingEventDataIfExists(
      {required String evId, Map<String, dynamic>? jsonEventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    if (jsonEventData != null) {
      data[OperationParam.eventServiceUpdateEventDataData.value] =
          jsonEventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));

    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.updateEventDataIfExists, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete an event out of the user's incoming mailbox.

  /// Service Name - Event
  /// Service Operation - DeleteIncoming

  /// @param evId
  /// The event id

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteIncomingEvent({required String evId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.deleteIncoming, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete a list of events out of the user's incoming mailbox.

  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS

  /// @param in_eventIds
  /// Collection of event ids

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteIncomingEvents(
      {required List<String> inEventids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceEvIds.value] = inEventids;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEvents, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  ///
  /// Delete any events older than the given date out of the user's incoming mailbox.

  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_OLDER_THAN

  /// @param in_dateMillis
  /// CreatedAt cut-off time whereby older events will be deleted (In UTC since Epoch)

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteIncomingEventsOlderThan(
      {required int inDatemillis}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceDateMillis.value] = inDatemillis;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete any events of the given type older than the given date out of the user's incoming mailbox.

  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_BY_TYPE_OLDER_THAN

  /// @param in_eventId
  /// The event id

  /// @param in_dateMillis
  /// CreatedAt cut-off time whereby older events will be deleted (In UTC since Epoch)

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteIncomingEventsByTypeOlderThan(
      {required String eventType, required int dateMillis}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceDateMillis.value] = dateMillis;
    data[OperationParam.eventServiceEventType.value] = eventType;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsByTypeOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Get the events currently queued for the user.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getEvents() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.getEvents, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
