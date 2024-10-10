import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("testUserItems", () {
    var itemId;
    var itemIdToGet;
    var item3;
    var item4;
    var item5;

    test("AwardUserItem() and Drop", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .awardUserItem(defId: "sword001", quantity: 5, includeDef: true);

      itemId = response.data?["items"][0];
      itemIdToGet = response.data?["items"][1];
      item3 = response.data?["items"][2];
      item4 = response.data?["items"][3];
      item5 = response.data?["items"][4];

      var items = response.data?["items"].values;

      itemId = items.elementAt(0).values.elementAt(0);
      itemIdToGet = items.elementAt(1).values.elementAt(0);
      item3 = items.elementAt(2).values.elementAt(0);
      item4 = items.elementAt(3).values.elementAt(0);
      item5 = items.elementAt(4).values.elementAt(0);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("DropUserItem()", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .dropUserItem(itemId: itemId, quantity: 1, includeDef: true);
      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetUserItemsPage()", () async {
      var context = {};

      context["pagination"] = {};
      context["pagination"]["rowsPerPage"] = 50;
      context["pagination"]["pageNumber"] = 1;
      context["searchCriteria"] = {};
      context["searchCriteria"]["defId"] = "sword001";
      context["sortCriteria"] = {};
      context["sortCriteria"]["createdAt"] = 1;
      context["sortCriteria"]["updatedAt"] = -1;

      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .getUserItemsPage(context: jsonEncode(context), includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetUserItemsPageOffset()", () async {
      var context =
          "eyJzZWFyY2hDcml0ZXJpYSI6eyJnYW1lSWQiOiIyMDAwMSIsInBsYXllcklkIjoiZTZiN2Q2NTEtYWIxZC00MDllLTgwMjktOTNhZDcxYWI4OTRkIiwiZ2lmdGVkVG8iOm51bGx9LCJzb3J0Q3JpdGVyaWEiOnt9LCJwYWdpbmF0aW9uIjp7InJvd3NQZXJQYWdlIjoxMDAsInBhZ2VOdW1iZXIiOm51bGx9LCJvcHRpb25zIjpudWxsfQ";
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .getUserItemsPageOffset(
              context: context, pageOffset: 1, includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetUserItem())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .getUserItem(itemId: itemIdToGet, includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GiveUserItemTo())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .giveUserItemTo(
              profileId: userB.profileId!,
              itemId: itemIdToGet,
              quantity: 1,
              version: 1,
              immediate: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("PurchaseUserItem())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .purchaseUserItem(defId: "sword001", quantity: 1, includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("ReceiveUserItemFrom())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .receiveUserItemFrom(
              profileId: userB.profileId!, itemId: itemIdToGet);

      expect(response.statusCode, StatusCodes.badRequest,
          reason: "Cannot receive item gift from self");
    });

    test("SellUserItem())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .sellUserItem(
              itemId: item3, quantity: 1, version: 1, includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("UpdateUserItemData())", () async {
      var newItemData = {};
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .updateUserItemData(
              itemId: item4, version: 1, newItemData: jsonEncode(newItemData));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("UseUserItem())", () async {
      var newItemData = {};
      newItemData["test"] = "testing";
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .useUserItem(
              itemId: item4,
              version: 2,
              newItemData: jsonEncode(newItemData),
              includeDef: true);

      expect(response.statusCode, StatusCodes.ok);
    });

    test("PublishUserItemToBlockchain())", () async {
      debugPrint("$item5");
      // bc.userInventoryManagement.publishUserItemToBlockchain(item5, 1, result
      // {
      //     equal(result.status, 200, "Expecting 200");
      //     resolve_test();
      // });

      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .publishUserItemToBlockchain(itemId: "InvalidForNow", version: 1);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    test("refreshBlockhainUserItems())", () async {
      ServerResponse response =
          await bcTest.bcWrapper.userItemsService.refreshBlockchainUserItems();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("RemoveUserItemFromBlockchain())", () async {
      ServerResponse response = await bcTest.bcWrapper.userItemsService
          .removeUserItemFromBlockchain(itemId: "InvalidForNow", version: 1);

      expect(response.statusCode, StatusCodes.badRequest);
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
