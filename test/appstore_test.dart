import 'dart:async';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v4.dart';

import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty
        ? "${const UuidV4().generate()}@DartUnitTester"
        : ids.email;
    password = ids.password.isEmpty ? const UuidV4().generate() : ids.password;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
      bool hadSession = bcWrapper.getStoredSessionId().isNotEmpty;

      if (hadSession) {
        bcWrapper.restoreSession();
      }

      int packetId = bcWrapper.getStoredPacketId();
      if (packetId > BrainCloudComms.noPacketExpected) {
        bcWrapper.restorePacketId();
      }

      Timer.periodic(const Duration(milliseconds: 100), (timer) {
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });

  group("Test Gamification", () {
    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: email, password: password, forceCreate: true);
      }
    });

    test("verifyPurchase()", () async {
      ServerResponse response = await bcWrapper.appStoreService
          .verifyPurchase(storeId: "_invalid_store_id_", receiptJson: " {}")
          .onError((error, stackTrace) {
        if (error is ServerResponse) {
          return error;
        } else {
          return ServerResponse(statusCode: StatusCodes.badRequest);
        }
      });

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("getEligiblePromotions()", () async {
      ServerResponse response =
          await bcWrapper.appStoreService.getEligiblePromotions();
      expect(response.statusCode, StatusCodes.ok);
    });

    test("getSalesInventory()", () async {
      ServerResponse response = await bcWrapper.appStoreService
          .getSalesInventory(
              platform: "_invalid_store_id_",
              userCurrency: "_invalid_user_currency_")
          .onError((error, stackTrace) {
        if (error is ServerResponse) {
          return error;
        } else {
          return ServerResponse(statusCode: StatusCodes.badRequest);
        }
      });

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("getSalesInventoryByCategory()", () async {
      ServerResponse response = await bcWrapper.appStoreService
          .getSalesInventoryByCategory(
              storeId: "_invalid_store_id_",
              userCurrency: "_invalid_user_currency_",
              category: "_invalid_category_")
          .onError((error, stackTrace) {
        if (error is ServerResponse) {
          return error;
        } else {
          return ServerResponse(statusCode: StatusCodes.badRequest);
        }
      });
      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("startPurchase()", () async {
      ServerResponse response = await bcWrapper.appStoreService
          .startPurchase(storeId: "_invalid_store_id_", purchaseJson: "{}")
          .onError((error, stackTrace) {
        if (error is ServerResponse) {
          return error;
        } else {
          return ServerResponse(statusCode: StatusCodes.badRequest);
        }
      });
      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("finalizePurchase()", () async {
      ServerResponse response = await bcWrapper.appStoreService
          .finalizePurchase(
              storeId: "_invalid_store_id_",
              transactionId: "_invalid_transaction_id_",
              transactionJson: " {}")
          .onError((error, stackTrace) {
        if (error is ServerResponse) {
          return error;
        } else {
          return ServerResponse(statusCode: StatusCodes.badRequest);
        }
      });

      expect(response.statusCode, StatusCodes.badRequest);
      expect(response.reasonCode, ReasonCodes.invalidStoreId);
    });

    test("refreshPromotions()", () async {
      ServerResponse response =
          await bcWrapper.appStoreService.refreshPromotions();
      expect(response.statusCode, 200);
    });
  });
}
