// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';
import '/src/util.dart';

class BrainCloudAppStore {
  final BrainCloudClient _clientRef;

  BrainCloudAppStore(this._clientRef);

/// Method gets the active sales inventory for the passed-in
/// currency type.
/// Service Name - AppStore
/// Service Operation - GetInventory
///
/// @param platform The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param userCurrency The currency type to retrieve the sales inventory for.
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getSalesInventory(
      {required String storeId, required String userCurrency}) {
    return getSalesInventoryByCategory(
        storeId: storeId, userCurrency: userCurrency);
  }

/// Method gets the active sales inventory for the passed-in
/// currency type.
/// Service Name - AppStore
/// Service Operation - GetInventory
///
/// @param storeId The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param userCurrency The currency type to retrieve the sales inventory for.
/// @param category The product category
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getSalesInventoryByCategory(
      {required String storeId,
      required String userCurrency,
      String? category}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    Map<String, dynamic> priceInfoCriteria = {};
    if (Util.isOptionalParameterValid(userCurrency)) {
      priceInfoCriteria[OperationParam.appStoreServiceUserCurrency.value] =
          userCurrency;
    }
    data[OperationParam.appStoreServicePriceInfoCriteria.value] =
        priceInfoCriteria;

    if (Util.isOptionalParameterValid(category)) {
      data[OperationParam.appStoreServiceCategory.value] = category;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.getInventory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Returns the eligible promotions for the player.
/// Service Name - AppStore
/// Service Operation - EligiblePromotions
///
/// @return Future<ServerResponse>
///
  Future<ServerResponse> getEligiblePromotions() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.eligiblePromotions, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

/// Verifies that purchase was properly made at the store.
/// Service Name - AppStore
/// Service Operation - VerifyPurchase
///
/// @param storeId The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param receiptData the specific store data required
/// @return Future<ServerResponse>
///
  Future<ServerResponse> verifyPurchase(
      {required String storeId, required Map<String, dynamic> receiptData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    data[OperationParam.appStoreServiceReceiptData.value] = receiptData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.verifyPurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Start A Two Staged Purchase Transaction
/// Service Name - AppStore
/// Service Operation - StartPurchase
///
/// @param storeId The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param purchaseData specific data for purchasing 2 staged purchases
/// @return Future<ServerResponse>
///
  Future<ServerResponse> startPurchase(
      {required String storeId, required Map<String, dynamic> purchaseData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    data[OperationParam.appStoreServicePurchaseData.value] = purchaseData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.startPurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Finalize A Two Staged Purchase Transaction
/// Service Name - AppStore
/// Service Operation - FinalizePurchase
///
/// @param storeId The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param transactionId the transactionId returned from start Purchase
/// @param transactionData specific data for purchasing 2 staged purchases
/// @return Future<ServerResponse>
///
  Future<ServerResponse> finalizePurchase(
      {required String storeId,
      required String transactionId,
      required Map<String, dynamic> transactionData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;
    data[OperationParam.appStoreServiceTransactionId.value] = transactionId;

    data[OperationParam.appStoreServiceTransactionData.value] = transactionData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.finalizePurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Returns up-to-date eligible 'promotions' for the user and a 'promotionsRefreshed' flag indicating whether the user's promotion info required refreshing.
/// Service Name - AppStore
/// Service Operation - RefreshPromotions
///
/// @return Future<ServerResponse>
///
  Future<ServerResponse> refreshPromotions() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = ServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.refreshPromotions, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

/// Before making a purchase with the IAP store, you will need to store the purchase
/// payload context on brainCloud so that the purchase can be verified for the proper IAP product.
/// This payload will be used during the VerifyPurchase method to ensure the
/// user properly paid for the correct product before awarding them the IAP product.
/// Service Name - AppStore
/// Service Operation - CachePurchasePayloadContext
///
/// @param storeId The store platform. Valid stores are:
///        itunes
///        facebook
///        appworld
///        steam
///        windows
///        windowsPhone
///        googlePlay
/// @param transactionId the transactionId returned from start Purchase
/// @param transactionData specific data for purchasing 2 staged purchases
/// @return Future<ServerResponse>
///
  Future<ServerResponse> cachePurchasePayloadContext(
      {required String storeId,
      required String iapId,
      required String payload}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.appStoreServiceStoreId.value] = storeId;
    data[OperationParam.appStoreServiceIAPId.value] = iapId;
    data[OperationParam.appStoreServicePayload.value] = payload;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));

    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.cachePurchasePayloadContext, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
