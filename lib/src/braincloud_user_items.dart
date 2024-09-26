import 'dart:async';
import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

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
  Future<ServerResponse> awardUserItem(
      {required String defId,
      required int quantity,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceDefId.value] = defId;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.awardUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> dropUserItem(
      {required String itemId,
      required int quantity,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.dropUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> getUserItemsPage(
      {required String context, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    var contextData = jsonDecode(context);
    data[OperationParam.userItemsServiceContext.value] = contextData;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getUserItemsPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> getUserItemsPageOffset(
      {required String context,
      required int pageOffset,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceContext.value] = context;
    data[OperationParam.userItemsServicePageOffset.value] = pageOffset;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getUserItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> getUserItem(
      {required String itemId, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.getUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> giveUserItemTo(
      {required String profileId,
      required String itemId,
      required int version,
      required int quantity,
      required bool immediate}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceProfileId.value] = profileId;
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceImmediate.value] = immediate;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.giveUserItemTo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> purchaseUserItem(
      {required String defId,
      required int quantity,
      String? shopId,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceDefId.value] = defId;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceShopId.value] = shopId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.purchaseUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> receiveUserItemFrom(
      {required String profileId, required String itemId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceProfileId.value] = profileId;
    data[OperationParam.userItemsServiceItemId.value] = itemId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.receiveUserItemFrom, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> sellUserItem(
      {required String itemId,
      required int version,
      required int quantity,
      String? shopId,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceShopId.value] = shopId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.sellUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> updateUserItemData(
      {required String itemId,
      required int version,
      required String newItemData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    var newItemDataDict = jsonDecode(newItemData);
    data[OperationParam.userItemsServiceNewItemData.value] = newItemDataDict;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.updateUserItemData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> useUserItem(
      {required String itemId,
      required int version,
      required String newItemData,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    var newItemDataDict = jsonDecode(newItemData);
    data[OperationParam.userItemsServiceNewItemData.value] = newItemDataDict;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.useUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> publishUserItemToBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.publishUserItemToBlockchain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Syncs the caller's user items with the item management attached blockchain. Results are reported asynchronously via an RTT event.
  /// </summary>
  /// <remarks>
  /// Service Name - UserInventoryManagement
  /// Service Operation - RefreshBlockchainUserItems
  Future<ServerResponse> refreshBlockchainUserItems() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.refreshBlockchainUserItems, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
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
  Future<ServerResponse> removeUserItemFromBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse(statusCode: 200, body: response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              statusMessage: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.removeUserItemFromBlockchain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
