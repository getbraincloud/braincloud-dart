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

class BrainCloudAppStore {
  final BrainCloudClient _clientRef;

  BrainCloudAppStore(this._clientRef);

  /// Method gets the active sales inventory for the passed-in
  /// currency type.
  ///
  /// Service Name - AppStore
  /// Service Operation - GetInventory
  ///
  /// @param platform
  /// The store platform. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  ///
  /// @param userCurrency
  /// The currency to retrieve the sales
  /// inventory for. This is only used for Steam and Facebook stores.
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getSalesInventory(
      {required String platform, required String userCurrency}) {
    return getSalesInventoryByCategory(
        storeId: platform, userCurrency: userCurrency);
  }

  /// Method gets the active sales inventory for the passed-in
  /// currency type and category.
  ///
  /// Service Name - AppStore
  /// Service Operation - GetInventory
  ///
  /// @param storeId
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  ///
  /// @param userCurrency
  /// The currency to retrieve the sales
  /// inventory for. This is only used for Steam and Facebook stores.
  ///
  /// @param category
  /// The AppStore category
  ///
  /// returns Future<ServerResponse>
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
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.getInventory, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns the eligible promotions for the player.
  ///
  /// Service Name - AppStore
  /// Service Operation - EligiblePromotions
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getEligiblePromotions() {
    Completer<ServerResponse> completer = Completer();
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.eligiblePromotions, null, callback);
    _clientRef.sendRequest(sc);
    return completer.future;
  }

  /// Verify Purchase with the associated StoreId
  ///
  /// Service Name - AppStore
  /// Service Operation - VERIFY_PURCHASE
  ///
  /// @param storeId
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  ///
  /// @param receiptJson
  /// The specific store data required
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> verifyPurchase(
      {required String storeId, required String receiptJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    var receiptData = jsonDecode(receiptJson);
    data[OperationParam.appStoreServiceReceiptData.value] = receiptData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.verifyPurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Start A Two Staged Purchase Transaction
  ///
  /// Service Name - AppStore
  /// Service Operation - START_PURCHASE
  /// @param storeId
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  ///
  /// @param purchaseJson
  /// The specific store data required
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> startPurchase(
      {required String storeId, required String purchaseJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    var purchaseData = jsonDecode(purchaseJson);
    data[OperationParam.appStoreServicePurchaseData.value] = purchaseData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.startPurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Finalize A Two Staged Purchase Transaction
  ///
  /// Service Name - AppStore
  /// Service Operation - FINALIZE_PURCHASE
  ///
  /// @param storeId
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  ///
  /// /// @param transactionId
  /// The Transaction Id returned in Start Transaction
  ///
  /// @param transactionJson
  /// The specific store data required
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> finalizePurchase(
      {required String storeId,
      required String transactionId,
      required String transactionJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;
    data[OperationParam.appStoreServiceTransactionId.value] = transactionId;

    var transactionData = jsonDecode(transactionJson);
    data[OperationParam.appStoreServiceTransactionData.value] = transactionData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.finalizePurchase, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns up-to-date eligible 'promotions' for the user and a 'promotionsRefreshed' flag indicating whether the user's promotion info required refreshing
  ///
  /// Service Name - appStore
  /// Service Operation - RefreshPromotions
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> refreshPromotions() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = ServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.refreshPromotions, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
