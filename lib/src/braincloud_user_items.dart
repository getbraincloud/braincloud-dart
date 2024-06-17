import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudUserItems {
  final BrainCloudClient _clientRef;

  BrainCloudUserItems(this._clientRef);

  /// <summary>
  /// Allows item(s) to be awarded to a user without collecting
  ///the purchase amount. If includeDef is true, response
  ///includes associated itemDef with language fields limited
  ///to the current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - AwardUserItem
  /// </remarks>
  /// <param name="defId">
  /// </param>
  /// <param name="quantity">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void awardUserItem(String defId, int quantity, bool includeDef,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceDefId.Value] = defId;
    data[OperationParam.UserItemsServiceQuantity.Value] = quantity;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.awardUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Allows a quantity of a specified user item to be dropped,
  ///without any recovery of the money paid for the item. If any
  ///quantity of the user item remains, it will be returned, potentially
  ///with the associated itemDef (with language fields limited to the
  ///current or default language).
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - DropUserItem
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="quantity">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void dropUserItem(String itemId, int quantity, bool includeDef,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceQuantity.Value] = quantity;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.dropUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the page of user's inventory from the server
  ///based on the context. If includeDef is true, response includes
  /// associated itemDef with each user item, with language fields
  ///limited to the current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserInventoryPage
  /// </remarks>
  /// <param name="context">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getUserItemsPage(String context, bool includeDef,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    var contextData = jsonDecode(context);
    data[OperationParam.UserItemsServiceContext.Value] = contextData;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.getUserItemsPage, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the page of user's inventory
  ///from the server based on the encoded context.
  ///If includeDef is true, response includes associated
  ///itemDef with each user item, with language fields limited
  ///to the current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserInventoryPageOffset
  /// </remarks>
  /// <param name="context">
  /// </param>
  /// <param name="pageOffset">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getUserItemsPageOffset(String context, int pageOffset, bool includeDef,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceContext.Value] = context;
    data[OperationParam.UserItemsServicePageOffset.Value] = pageOffset;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.getUserItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the identified user item from the server.
  /// If includeDef is true, response includes associated
  /// itemDef with language fields limited to the current
  ///or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getUserItem(String itemId, bool includeDef, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.getUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Gifts item to the specified player.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem
  /// </remarks>
  /// <param name="profileId">
  /// </param>
  /// <param name="itemId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="quantity">
  /// </param>
  /// <param name="immediate">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void giveUserItemTo(
      String profileId,
      String itemId,
      int version,
      int quantity,
      bool immediate,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceProfileId.Value] = profileId;
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;
    data[OperationParam.UserItemsServiceQuantity.Value] = quantity;
    data[OperationParam.UserItemsServiceImmediate.Value] = immediate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.giveUserItemTo, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Purchases a quantity of an item from the specified store,
  ///if the user has enough funds. If includeDef is true,
  ///response includes associated itemDef with language fields
  /// limited to the current or default language.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem
  /// </remarks>
  /// <param name="defId">
  /// </param>
  /// <param name="quatity">
  /// </param>
  /// <param name="shopId">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void purchaseUserItem(
      String defId,
      int quantity,
      String shopId,
      bool includeDef,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceDefId.Value] = defId;
    data[OperationParam.UserItemsServiceQuantity.Value] = quantity;
    data[OperationParam.UserItemsServiceShopId.Value] = shopId;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.purchaseUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves and transfers the gift item from the specified player,
  //who must have previously called giveUserItemTo.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem
  /// </remarks>
  /// <param name="defId">
  /// </param>
  /// <param name="quatity">
  /// </param>
  /// <param name="shopId">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void receiveUserItemFrom(String profileId, String itemId,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceProfileId.Value] = profileId;
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.receiveUserItemFrom, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Allows a quantity of a specified user item to be sold.
  ///If any quantity of the user item remains,
  ///it will be returned, potentially with the associated
  ///itemDef (with language fields limited to the current
  ///or default language), along with the currency refunded
  ///and currency balances.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - SellUserItem
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="quantity">
  /// </param>
  /// <param name="shopId">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void sellUserItem(
      String itemId,
      int version,
      int quantity,
      String shopId,
      bool includeDef,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;
    data[OperationParam.UserItemsServiceQuantity.Value] = quantity;
    data[OperationParam.UserItemsServiceShopId.Value] = shopId;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.sellUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Updates the item data on the specified user item.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - UpdateUserItemData
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="newItemData">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void updateUserItemData(String itemId, int version, String newItemData,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;
    var newItemDataDict = jsonDecode(newItemData);
    data[OperationParam.UserItemsServiceNewItemData.Value] = newItemDataDict;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.updateUserItemData, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Uses the specified item, potentially consuming it.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - UseUserItem
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="newItemData">
  /// </param>
  /// <param name="includeDef">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void useUserItem(
      String itemId,
      int version,
      String newItemData,
      bool includeDef,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;
    data[OperationParam.UserItemsServiceIncludeDef.Value] = includeDef;

    var newItemDataDict = jsonDecode(newItemData);
    data[OperationParam.UserItemsServiceNewItemData.Value] = newItemDataDict;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.UserItems, ServiceOperation.useUserItem, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Publishes the specified item to the item management attached blockchain. Results are reported asynchronously via an RTT event.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - PublishUserItemToBlockchain
  /// </remarks>
  /// <param name="itemId">
  /// </param>
  /// <param name="version">
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void publishUserItemToBlockchain(String itemId, int version,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.publishUserItemToBlockchain, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Syncs the caller's user items with the item management attached blockchain. Results are reported asynchronously via an RTT event.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - RefreshBlockchainUserItems
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void refreshBlockchainUserItems(
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.refreshBlockchainUserItems, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// removes item from a blockchain.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - RemoveUserItemFromBlockchain
  ///
  /// </param>
  /// <param name="itemId">
  ///
  /// </param>
  /// <param name="version">
  ///
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void removeUserItemFromBlockchain(String itemId, int version,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserItemsServiceItemId.Value] = itemId;
    data[OperationParam.UserItemsServiceVersion.Value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.UserItems,
        ServiceOperation.removeUserItemFromBlockchain, data, callback);
    _clientRef.sendRequest(sc);
  }
}
