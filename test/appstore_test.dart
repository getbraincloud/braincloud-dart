import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utils/test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("Test AppStore", () {
    test("verifyPurchase()", () async {
      ServerResponse response = await bcTest.bcWrapper.appStoreService
          .verifyPurchase(storeId: "_invalid_store_id_", receiptJson: " {}");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("getEligiblePromotions()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.appStoreService.getEligiblePromotions();

      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSalesInventory()", () async {
      ServerResponse response = await bcTest.bcWrapper.appStoreService
          .getSalesInventory(
              platform: "_invalid_store_id_",
              userCurrency: "_invalid_user_currency_");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("getSalesInventoryByCategory()", () async {
      ServerResponse response = await bcTest.bcWrapper.appStoreService
          .getSalesInventoryByCategory(
              storeId: "_invalid_store_id_",
              userCurrency: "_invalid_user_currency_",
              category: "_invalid_category_");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("startPurchase()", () async {
      ServerResponse response = await bcTest.bcWrapper.appStoreService
          .startPurchase(storeId: "_invalid_store_id_", purchaseJson: "{}");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("finalizePurchase()", () async {
      ServerResponse response = await bcTest.bcWrapper.appStoreService
          .finalizePurchase(
              storeId: "_invalid_store_id_",
              transactionId: "_invalid_transaction_id_",
              transactionJson: " {}");

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("refreshPromotions()", () async {
      ServerResponse response =
          await bcTest.bcWrapper.appStoreService.refreshPromotions();

      expect(response.statusCode, 200);
    });

    /// END TEST
    tearDown(() {
      bcTest.dispose();
    });
  });
}
