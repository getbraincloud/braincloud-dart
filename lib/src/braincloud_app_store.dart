import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudAppStore {
  final BrainCloudClient _clientRef;

  BrainCloudAppStore(this._clientRef);

  /// <summary>
  /// Method gets the active sales inventory for the passed-in
  /// currency type.
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - GetInventory
  /// </remarks>
  /// <param name="platform">
  /// The store platform. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  /// </param>
  /// <param name="userCurrency">
  /// The currency to retrieve the sales
  /// inventory for. This is only used for Steam and Facebook stores.
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getSalesInventory(String platform, String userCurrency,
      SuccessCallback? success, FailureCallback? failure) {
    getSalesInventoryByCategory(platform, userCurrency, null, success, failure);
  }

  /// <summary>
  /// Method gets the active sales inventory for the passed-in
  /// currency type and category.
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - GetInventory
  /// </remarks>
  /// <param name="storeId">
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  /// </param>
  /// <param name="userCurrency">
  /// The currency to retrieve the sales
  /// inventory for. This is only used for Steam and Facebook stores.
  /// </param>
  /// <param name="category">
  /// The AppStore category
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getSalesInventoryByCategory(String storeId, String userCurrency,
      String? category, SuccessCallback? success, FailureCallback? failure) {
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

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.getInventory, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns the eligible promotions for the player.
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - EligiblePromotions
  /// </remarks>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getEligiblePromotions(
      SuccessCallback? success, FailureCallback? failure) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.eligiblePromotions, null, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Verify Purchase with the associated StoreId
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - VERIFY_PURCHASE
  /// </remarks>
  /// <param name="storeId">
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  /// </param>
  /// <param name="receiptJson">
  /// The specific store data required
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void verifyPurchase(String storeId, String receiptJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    var receiptData = jsonDecode(receiptJson);
    data[OperationParam.appStoreServiceReceiptData.value] = receiptData;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.verifyPurchase, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Start A Two Staged Purchase Transaction
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - START_PURCHASE
  /// </remarks>
  /// <param name="storeId">
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  /// </param>
  /// <param name="purchaseJson">
  /// The specific store data required
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void startPurchase(String storeId, String purchaseJson,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;

    var purchaseData = jsonDecode(purchaseJson);
    data[OperationParam.appStoreServicePurchaseData.value] = purchaseData;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(
        ServiceName.appStore, ServiceOperation.startPurchase, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Finalize A Two Staged Purchase Transaction
  /// </summary>
  /// <remarks>
  /// Service Name - AppStore
  /// Service Operation - FINALIZE_PURCHASE
  /// </remarks>
  /// <param name="storeId">
  /// The store storeId. Valid stores are:
  /// - itunes
  /// - facebook
  /// - appworld
  /// - steam
  /// - windows
  /// - windowsPhone
  /// - googlePlay
  /// </param>
  /// /// <param name="transactionId">
  /// The Transaction Id returned in Start Transaction
  /// </param>
  /// <param name="transactionJson">
  /// The specific store data required
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void finalizePurchase(
      String storeId,
      String transactionId,
      String transactionJson,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.appStoreServiceStoreId.value] = storeId;
    data[OperationParam.appStoreServiceTransactionId.value] = transactionId;

    var transactionData = jsonDecode(transactionJson);
    data[OperationParam.appStoreServiceTransactionData.value] = transactionData;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.finalizePurchase, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns up-to-date eligible 'promotions' for the user and a 'promotionsRefreshed' flag indicating whether the user's promotion info required refreshing
  /// Service Name - appStore
  /// Service Operation - RefreshPromotions
  /// /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// </summary>
  void refreshPromotions(SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = ServerCallback(success, failure);
    ServerCall sc = ServerCall(ServiceName.appStore,
        ServiceOperation.refreshPromotions, data, callback);
    _clientRef.sendRequest(sc);
  }
}
