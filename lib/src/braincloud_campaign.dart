// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudCampaign {
  final BrainCloudClient _clientRef;

  BrainCloudCampaign(this._clientRef);

/// Returns the list of campaigns the current player is participating in,
/// providing campaign, campaign scenario, and participation details.
/// Service Name - Campaign
/// Service Operation - GET_MY_CAMPAIGNS
///
/// @param optionsJson Optional parameters as a JSON string (reserved for future use).
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getMyCampaigns(
      {Map<String, dynamic>? optionsJson}) {
    Completer<ServerResponse> completer = Completer();

    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceOptionsJson.value] = optionsJson ?? {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.campaign, ServiceOperation.getMyCampaigns, data, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }
}
