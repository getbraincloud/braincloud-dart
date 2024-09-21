import 'dart:convert';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

void main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test Item Catalog", () {
    setUp(bcTest.auth);

    test("GetCatalogItemDefinition()", () async {
      ServerResponse response = await bcTest.bcWrapper.itemCatalogService
          .getCatalogItemDefinition(defId: "sword001");

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetCatalogItemsPage()", () async {
      var context = {};

      context["pagination"] = {};
      context["pagination"]["rowsPerPage"] = 50;
      context["pagination"]["pageNumber"] = 1;
      context["searchCriteria"] = {"category": "sword"};
      context["sortCriteria"] = {"createdAt": 1};
      context["sortCriteria"] = {"updatedAt": -1};

      ServerResponse response = await bcTest.bcWrapper.itemCatalogService
          .getCatalogItemsPage(context: jsonEncode(context));

      expect(response.statusCode, StatusCodes.ok);
    });

    test("GetCatalogItemsPageOffset()", () async {
      var context =
          "eyJzZWFyY2hDcml0ZXJpYSI6eyJnYW1lSWQiOiIyMDAwMSJ9LCJzb3J0Q3JpdGVyaWEiOnt9LCJwYWdpbmF0aW9uIjp7InJvd3NQZXJQYWdlIjoxMDAsInBhZ2VOdW1iZXIiOm51bGx9LCJvcHRpb25zIjpudWxsfQ";
      ServerResponse response = await bcTest.bcWrapper.itemCatalogService
          .getCatalogItemsPageOffset(context: context, pageOffset: 1);

      expect(response.statusCode, StatusCodes.ok);
    });

    /// END TEST
    test("Dispose", () {
      bcTest.dispose();
    });
  });
}
