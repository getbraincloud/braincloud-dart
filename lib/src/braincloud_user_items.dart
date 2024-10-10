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

  /// Allows item(s) to be awarded to a user without collecting
  ///the purchase amount. If includeDef is true, response
  ///includes associated itemDef with language fields limited
  ///to the current or default language.

  /// Service Name - UserInventoryManagement
  /// Service Operation - AwardUserItem

  /// @param defId

  /// @param quantity

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Allows a quantity of a specified user item to be dropped,
  ///without any recovery of the money paid for the item. If any
  ///quantity of the user item remains, it will be returned, potentially
  ///with the associated itemDef (with language fields limited to the
  ///current or default language).

  /// Service Name - UserInventoryManagement
  /// Service Operation - DropUserItem

  /// @param itemId

  /// @param quantity

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Retrieves the page of user's inventory from the server
  ///based on the context. If includeDef is true, response includes
  /// associated itemDef with each user item, with language fields
  ///limited to the current or default language.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserInventoryPage

  /// @param context

  /// @param includeDef

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getUserItemsPage(
      {required String context, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    var contextData = jsonDecode(context);
    data[OperationParam.userItemsServiceContext.value] = contextData;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Retrieves the page of user's inventory
  ///from the server based on the encoded context.
  ///If includeDef is true, response includes associated
  ///itemDef with each user item, with language fields limited
  ///to the current or default language.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserInventoryPageOffset

  /// @param context

  /// @param pageOffset

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Retrieves the identified user item from the server.
  /// If includeDef is true, response includes associated
  /// itemDef with language fields limited to the current
  ///or default language.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem

  /// @param itemId

  /// @param includeDef

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getUserItem(
      {required String itemId, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Gifts item to the specified player.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem

  /// @param profileId

  /// @param itemId

  /// @param version

  /// @param quantity

  /// @param immediate

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Purchases a quantity of an item from the specified store,
  ///if the user has enough funds. If includeDef is true,
  ///response includes associated itemDef with language fields
  /// limited to the current or default language.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem

  /// @param defId

  /// @param quatity

  /// @param shopId

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Retrieves and transfers the gift item from the specified player,
  //who must have previously called giveUserItemTo.

  /// Service Name - UserInventoryManagement
  /// Service Operation - GetUserItem

  /// @param defId

  /// @param quatity

  /// @param shopId

  /// @param includeDef

  /// @returns Future<ServerResponse>
  Future<ServerResponse> receiveUserItemFrom(
      {required String profileId, required String itemId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceProfileId.value] = profileId;
    data[OperationParam.userItemsServiceItemId.value] = itemId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Allows a quantity of a specified user item to be sold.
  ///If any quantity of the user item remains,
  ///it will be returned, potentially with the associated
  ///itemDef (with language fields limited to the current
  ///or default language), along with the currency refunded
  ///and currency balances.

  /// Service Name - UserInventoryManagement
  /// Service Operation - SellUserItem

  /// @param itemId

  /// @param version

  /// @param quantity

  /// @param shopId

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Updates the item data on the specified user item.

  /// Service Name - UserInventoryManagement
  /// Service Operation - UpdateUserItemData

  /// @param itemId

  /// @param version

  /// @param newItemData

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Uses the specified item, potentially consuming it.

  /// Service Name - UserInventoryManagement
  /// Service Operation - UseUserItem

  /// @param itemId

  /// @param version

  /// @param newItemData

  /// @param includeDef

  /// @returns Future<ServerResponse>
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
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Publishes the specified item to the item management attached blockchain. Results are reported asynchronously via an RTT event.

  /// Service Name - UserInventoryManagement
  /// Service Operation - PublishUserItemToBlockchain

  /// @param itemId

  /// @param version

  /// @returns Future<ServerResponse>
  Future<ServerResponse> publishUserItemToBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// Syncs the caller's user items with the item management attached blockchain. Results are reported asynchronously via an RTT event.

  /// Service Name - UserInventoryManagement
  /// Service Operation - RefreshBlockchainUserItems
  /// @returns Future<ServerResponse>
  Future<ServerResponse> refreshBlockchainUserItems() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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

  /// removes item from a blockchain.

  /// Service Name - UserInventoryManagement
  /// Service Operation - RemoveUserItemFromBlockchain
  ///

  /// @param itemId
  ///

  /// @param version
  ///

  /// @returns Future<ServerResponse>
  Future<ServerResponse> removeUserItemFromBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) =>
          completer.complete(ServerResponse.fromJson(response)),
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
