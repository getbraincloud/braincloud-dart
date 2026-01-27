// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudEvent {
  final BrainCloudClient _clientRef;

  BrainCloudEvent(this._clientRef);

  /// Sends an event to the designated user id with the attached json data.
  /// Any events that have been sent to a user will show up in their
  /// incoming event mailbox. If the recordLocally flag is set to true,
  /// a copy of this event (with the exact same event id) will be stored
  /// in the sending user's "sent" event mailbox.
  /// Note that the list of sent and incoming events for a user is returned
  /// in the "ReadPlayerState" call (in the BrainCloudPlayer module).
  /// Service Name - event
  /// Service Operation - SEND
  ///
  /// @param toProfileId The id of the user who is being sent the event
  /// @param eventType The user-defined type of the event.
  /// @param jsonEventData The user-defined data for this event encoded in JSON.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendEvent(
      {required String toProfileId,
      required String eventType,
      Map<String, dynamic>? eventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.eventServiceSendToId.value] = toProfileId;
    data[OperationParam.eventServiceSendEventType.value] = eventType;

    if (eventData != null) {
      data[OperationParam.eventServiceSendEventData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc =
        ServerCall(ServiceName.event, ServiceOperation.send, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Sends an event to multiple users with the attached json data.
  /// Service Name - event
  /// Service Operation - SEND_EVENT_TO_PROFILES
  ///
  /// @param toIds The profile ids of the users to send the event
  /// @param eventType The user-defined type of the event
  /// @param eventData The user-defined data for this event encoded in JSON
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> sendEventToProfiles(
      {required List<String> toIds,
      required String eventType,
      Map<String, dynamic>? eventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.eventServiceSendToIds.value] = toIds;
    data[OperationParam.eventServiceSendEventType.value] = eventType;

    if (eventData != null) {
      data[OperationParam.eventServiceSendEventData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.sendEventToProfiles, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Updates an event in the user's incoming event mailbox.
  /// Service Name - event
  /// Service Operation - UPDATE_EVENT_DATA
  ///
  /// @param evId The event id
  /// @param jsonEventData The user-defined data for this event encoded in JSON.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateIncomingEventData(
      {required String evId, Map<String, dynamic>? eventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    if (eventData != null) {
      data[OperationParam.eventServiceUpdateEventDataData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.updateEventData, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Updates an event in the user's incoming event mailbox.
  /// Returns the same data as updateIncomingEventData, but returns null instead of an error if none exists.
  /// Service Name - event
  /// Service Operation - UPDATE_EVENT_DATA
  ///
  /// @param evId The event id
  /// @param jsonEventData The user-defined data for this event encoded in JSON.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateIncomingEventDataIfExists(
      {required String evId, Map<String, dynamic>? eventData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.evId.value] = evId;

    if (eventData != null) {
      data[OperationParam.eventServiceUpdateEventDataData.value] = eventData;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));

    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.updateEventDataIfExists, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete an event out of the user's incoming mailbox.
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING
  ///
  /// @param evId The event id
  /// @return Future<ServerResponse>
  ///
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
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.deleteIncoming, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete a list of events out of the user's incoming mailbox.
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS
  ///
  /// @param eventIds Collection of event ids
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> deleteIncomingEvents({required List<String> evIds}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceEvIds.value] = evIds;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEvents, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete any events older than the given date out of the user's incoming mailbox.
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_OLDER_THAN
  ///
  /// @param dateMillis createdAt cut-off time whereby older events will be deleted (In UTC since Epoch)
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> deleteIncomingEventsOlderThan(
      {required int dateMillis}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.eventServiceDateMillis.value] = dateMillis;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Delete any events of the given type older than the given date out of the user's incoming mailbox.
  /// Service Name - event
  /// Service Operation - DELETE_INCOMING_EVENTS_BY_TYPE_OLDER_THAN
  ///
  /// @param eventType The user-defined type of the event
  /// @param dateMillis createdAt cut-off time whereby older events will be deleted (In UTC since Epoch)
  /// @return Future<ServerResponse>
  ///
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
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.event,
        ServiceOperation.deleteIncomingEventsByTypeOlderThan, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Get the events currently queued for the user.
  /// Service Name - event
  /// Service Operation - GET_EVENTS
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getEvents() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.event, ServiceOperation.getEvents, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
