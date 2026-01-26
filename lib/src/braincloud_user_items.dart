// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudUserItems {
  final BrainCloudClient _clientRef;

  BrainCloudUserItems(this._clientRef);

  /// Awards item(s) to a user without collecting the purchase amount.
  /// If includeDef is true, response includes associated itemDef
  /// with language fields limited to the current or default language.
  /// Service Name - userItems
  /// Service Operation - AWARD_USER_ITEM
  ///
  /// @param in_defId The unique id of the item definition to award.
  /// @param in_quantity The quantity of the item to award.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.awardUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Drops a quantity of a specified user item without recovering the purchase cost.
  /// If any quantity remains, it may include the associated itemDef.
  /// Service Name - userItems
  /// Service Operation - DROP_USER_ITEM
  ///
  /// @param in_defId The unique id of the item definition to drop.
  /// @param in_quantity The quantity of the item to drop.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.dropUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a page of the user's inventory.
  /// Service Name - userItems
  /// Service Operation - GET_USER_INVENTORY_PAGE
  ///
  /// @param in_context Context string used to filter inventory.
  /// @param in_includeDef If true, include associated item definitions in the response.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getUserItemsPage(
      {required Map<String, dynamic> context, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    data[OperationParam.userItemsServiceContext.value] = context;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getUserItemsPage, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a page of the user's inventory with an offset.
  /// Service Name - userItems
  /// Service Operation - GET_USER_INVENTORY_PAGE_OFFSET
  ///
  /// @param in_context Context string used to filter inventory.
  /// @param in_pageOffset Page offset to retrieve.
  /// @param in_includeDef If true, include associated item definitions in the response.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getUserItemsPageOffset, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves a specific user item.
  /// Service Name - userItems
  /// Service Operation - GET_USER_ITEM
  ///
  /// @param in_itemId ID of the user item to retrieve.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getUserItem(
      {required String itemId, required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.getUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Gifts an item to another user.
  /// Service Name - userItems
  /// Service Operation - GIVE_USER_ITEM_TO
  ///
  /// @param in_profileId Profile ID of the recipient.
  /// @param in_itemId ID of the item to gift.
  /// @param in_version Version of the item being gifted.
  /// @param in_quantity Quantity of the item to gift.
  /// @param in_immediate If true, the gift is delivered immediately.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.giveUserItemTo, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Purchases a user item from a store.
  /// Service Name - userItems
  /// Service Operation - PURCHASE_USER_ITEM
  ///
  /// @param in_defId The unique id of the item definition to purchase.
  /// @param in_quantity Quantity of the item to purchase.
  /// @param in_shopId Store ID for the purchase.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.purchaseUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Retrieves and transfers a gift item from another user.
  /// Service Name - userItems
  /// Service Operation - RECEIVE_USER_ITEM_FROM
  ///
  /// @param in_profileId Profile ID of the sender.
  /// @param in_itemId ID of the item being received.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> receiveUserItemFrom(
      {required String profileId, required String itemId}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceProfileId.value] = profileId;
    data[OperationParam.userItemsServiceItemId.value] = itemId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.receiveUserItemFrom, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Sells a user item back to the store.
  /// Service Name - userItems
  /// Service Operation - SELL_USER_ITEM
  ///
  /// @param in_itemId ID of the user item to sell.
  /// @param in_version Version of the item being sold.
  /// @param in_quantity Quantity of the item to sell.
  /// @param in_shopId Store ID for the sale.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
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
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.sellUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Updates the data of a specific user item.
  /// Service Name - userItems
  /// Service Operation - UPDATE_USER_ITEM_DATA
  ///
  /// @param in_itemId ID of the user item to update.
  /// @param in_version Version of the item being updated.
  /// @param in_newItemData JSON string with updated item data.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateUserItemData(
      {required String itemId,
      required int version,
      required Map<String, dynamic> newItemData}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    data[OperationParam.userItemsServiceNewItemData.value] = newItemData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.updateUserItemData, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Uses a user item, potentially consuming it.
  /// Service Name - userItems
  /// Service Operation - USE_USER_ITEM
  ///
  /// @param in_itemId ID of the user item to use.
  /// @param in_version Version of the user item (pass -1 for any version).
  /// @param in_newItemData Optional JSON string to update item fields.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> useUserItem(
      {required String itemId,
      required int version,
      required Map<String, dynamic> newItemData,
      required bool includeDef}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    data[OperationParam.userItemsServiceNewItemData.value] = newItemData;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.useUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Publishes a user item to the blockchain.
  /// Service Name - userItems
  /// Service Operation - PUBLISH_USER_ITEM_TO_BLOCKCHAIN
  ///
  /// @param in_itemId ID of the user item to publish.
  /// @param in_version Version of the item to publish.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> publishUserItemToBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.publishUserItemToBlockchain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Refreshes blockchain user items.
  /// Service Name - userItems
  /// Service Operation - REFRESH_BLOCKCHAIN_USER_ITEMS
  ///
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> refreshBlockchainUserItems() {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.refreshBlockchainUserItems, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Removes a user item from the blockchain.
  /// Service Name - userItems
  /// Service Operation - REMOVE_USER_ITEM_FROM_BLOCKCHAIN
  ///
  /// @param in_itemId ID of the user item to remove.
  /// @param in_version Version of the user item to remove.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> removeUserItemFromBlockchain(
      {required String itemId, required int version}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.removeUserItemFromBlockchain, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Awards item(s) to a user with additional options.
  /// Service Name - userItems
  /// Service Operation - AWARD_USER_ITEM
  ///
  /// @param in_defId The unique id of the item definition to award.
  /// @param in_quantity The quantity of the item to award.
  /// @param in_includeDef If true, include associated item definition in the response.
  /// @param in_optionsJson JSON string specifying additional options (e.g., blockIfExceedItemMaxStackable).
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> awardUserItemWithOptions(
      {required String defId,
      required int quantity,
      required bool includeDef,
      required Map<String, Object> optionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceDefId.value] = defId;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;
    data[OperationParam.userItemsServiceOptionsJson.value] = optionsJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.awardUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Opens a quantity of a bundle user item.
  /// Creates applicable items and awards any currencies.
  /// Service Name - userItems
  /// Service Operation - OPEN_BUNDLE
  ///
  /// @param in_itemId ID of the bundle item to open.
  /// @param in_version Version of the bundle item (pass -1 for any version).
  /// @param in_quantity Quantity of the item to open.
  /// @param in_includeDef Include associated item definitions if true.
  /// @param in_optionsJson JSON string specifying additional options.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> openBundle(
      {required String itemId,
      required int version,
      required int quantity,
      required bool includeDef,
      Map<String, Object>? optionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceItemId.value] = itemId;
    data[OperationParam.userItemsServiceVersion.value] = version;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;
    if (optionsJson != null) {
      data[OperationParam.userItemsServiceOptionsJson.value] = optionsJson;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(
        ServiceName.userItems, ServiceOperation.openBundle, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Purchases a quantity of an item from the specified store,
  ///if the user has enough funds. If includeDef is true,
  ///response includes associated itemDef with language fields
  /// limited to the current or default language.
  ///
  /// Service Name - userItems
  /// Service Operation - PurchaseUserItem
  ///
  /// @param defId The unique id of the item definition to purchase.
  ///
  /// @param quantity The quantity of the item to purchase.
  ///
  /// @param shopId The id identifying the store the item is being purchased from, if applicable.
  ///
  /// @param includeDef If true, the associated item definition will be included in the response.
  ///
  /// @param optionsJson Optional support for specifying 'blockIfExceedItemMaxStackable' indicating
  ///  how to process the award if the defId is for a stackable item with a max
  ///  stackable quantity and the specified quantity to award is too high. If
  ///  true and the quantity is too high, the call is blocked and an error is returned.
  ///  If false (default) and quantity is too high, the quantity is adjusted
  ///  to the allowed maximum and the quantity not awarded is reported in
  ///  response key 'itemsNotAwarded' - unless the adjusted quantity would be
  ///  0, in which case the call is blocked and an error is returned.
  ///
  ///  returns `Future<ServerResponse>`
  Future<ServerResponse> purchaseUserItemWithOptions(
      {required String defId,
      required int quantity,
      String? shopId,
      required bool includeDef,
      required Map<String, Object> optionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceDefId.value] = defId;
    data[OperationParam.userItemsServiceQuantity.value] = quantity;
    data[OperationParam.userItemsServiceShopId.value] = shopId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.purchaseUserItem, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns a list of items on promotion available to the current user.
  /// Service Name - userItems
  /// Service Operation - GET_ITEMS_ON_PROMOTION
  ///
  /// @param in_shopId Store ID.
  /// @param in_includeDef Include associated item definition if true.
  /// @param in_includePromotionDetails Include promotion details if true.
  /// @param in_optionsJson JSON string specifying additional options (e.g., category).
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getItemsOnPromotion(
      {required String shopId,
      required bool includeDef,
      required bool includePromotionDetails,
      required Map<String, Object> optionsJson}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceShopId.value] = shopId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;
    data[OperationParam.userItemsServiceIncludePromotionDetails.value] =
        includePromotionDetails;
    data[OperationParam.userItemsServiceOptionsJson.value] = optionsJson;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getPromotionDetails, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// Returns a list of promotional details for a specified item.
  /// Service Name - userItems
  /// Service Operation - GET_ITEM_PROMOTION_DETAILS
  ///
  /// @param in_defId Item definition ID.
  /// @param in_shopId Store ID.
  /// @param in_includeDef Include associated item definition if true.
  /// @param in_includePromotionDetails Include promotion details if true.
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getItemPromotionDetails(
      {required String defId,
      required String shopId,
      required bool includeDef,
      required bool includePromotionDetails}) {
    Completer<ServerResponse> completer = Completer();
    Map<String, dynamic> data = {};
    data[OperationParam.userItemsServiceDefId.value] = defId;
    data[OperationParam.userItemsServiceShopId.value] = shopId;
    data[OperationParam.userItemsServiceIncludeDef.value] = includeDef;
    data[OperationParam.userItemsServiceIncludePromotionDetails.value] =
        includePromotionDetails;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
      (response) => completer.complete(ServerResponse.fromJson(response)),
      (statusCode, reasonCode, statusMessage) => completer.complete(
          ServerResponse(
              statusCode: statusCode,
              reasonCode: reasonCode,
              error: statusMessage)),
    );
    ServerCall sc = ServerCall(ServiceName.userItems,
        ServiceOperation.getItemPromotionDetails, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
