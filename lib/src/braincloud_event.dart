import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudEvent {
  final BrainCloudClient _clientRef;

  BrainCloudEvent(this._clientRef);

  /// <summary>
  /// Sends an event to the designated profile id with the attached json data.
  /// Any events that have been sent to a user will show up in their
  /// incoming event mailbox. If the recordLocally flag is set to true,
  /// a copy of this event (with the exact same event id) will be stored
  /// in the sending user's "sent" event mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - Event
  /// Service Operation - Send
  /// </remarks>
  /// <param name="toProfileId">
  /// The id of the user who is being sent the event
  /// </param>
  /// <param name="eventType">
  /// The user-defined type of the event.
  /// </param>
  /// <param name="jsonEventData">
  /// The user-defined data for this event encoded in JSON.
  /// </param>
  Future<ServerResponse> sendEvent(
      {required String toProfileId,
      required String eventType,
      required String jsonEventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.eventServiceSendToId.value] = toProfileId;
    data[OperationParam.eventServiceSendEventType.value] = eventType;

    if (Util.isOptionalParameterValid(jsonEventData)) {
      Map<String, dynamic> eventData = jsonDecode(jsonEventData);
      data[OperationParam.eventServiceSendEventData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc =
        ServerCall(ServiceName.event, ServiceOperation.send, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Updates an event in the user's incoming event mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - Event
  /// Service Operation - UpdateEventData
  /// </remarks>
  /// <param name="evId">
  /// The event id
  /// </param>
  /// <param name="jsonEventData">
  /// The user-defined data for this event encoded in JSON.
  /// </param>
  Future<ServerResponse> updateIncomingEventData(
      {required String evId, required String jsonEventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    if (Util.isOptionalParameterValid(jsonEventData)) {
      Map<String, dynamic> eventData = jsonDecode(jsonEventData);
      data[OperationParam.eventServiceUpdateEventDataData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.updateEventData, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Delete an event out of the user's incoming mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - Event
  /// Service Operation - DeleteIncoming
  /// </remarks>
  /// <param name="evId">
  /// The event id
  /// </param>
  Future<ServerResponse> deleteIncomingEvent({required String evId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.deleteIncoming, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Delete a list of events out of the user's incoming mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS
  /// </remarks>
  /// <param name="in_eventIds">
  /// Collection of event ids
  /// </param>
  Future<ServerResponse> deleteIncomingEvents(
      {required List<String> inEventids}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceEvIds.value] = inEventids;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEvents, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// /// <summary>
  /// Delete any events older than the given date out of the user's incoming mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_OLDER_THAN
  /// </remarks>
  /// <param name="in_dateMillis">
  /// CreatedAt cut-off time whereby older events will be deleted (In UTC since Epoch)
  /// </param>
  Future<ServerResponse> deleteIncomingEventsOlderThan(
      {required int inDatemillis}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceDateMillis.value] = inDatemillis;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Delete any events of the given type older than the given date out of the user's incoming mailbox.
  /// </summary>
  /// <remarks>
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_BY_TYPE_OLDER_THAN
  /// </remarks>
  /// <param name="in_eventId">
  /// The event id
  /// </param>
  /// <param name="in_dateMillis">
  /// CreatedAt cut-off time whereby older events will be deleted (In UTC since Epoch)
  /// </param>
  Future<ServerResponse> deleteIncomingEventsByTypeOlderThan(
      {required String inEventid, required int inDatemillis}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceDateMillis.value] = inDatemillis;
    data[OperationParam.eventServiceEventType.value] = inEventid;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsByTypeOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// <summary>
  /// Get the events currently queued for the user.
  /// </summary>
  Future<ServerResponse> getEvents() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
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
