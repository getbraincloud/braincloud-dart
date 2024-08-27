import 'dart:async';
import 'dart:convert';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});

  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";
  String sharedProfileId = "";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email;
    password = ids.password;
    sharedProfileId = ids.sharedProfileId;

    debugPrint('email: ${ids.email} in appId: ${ids.appId} at ${ids.url}');
    //start test

    bcWrapper.init(secretKey: ids.secretKey, appId: ids.appId, version: ids.version, url: ids.url).then((_) {
      // expect(bcWrapper.isInitialized, false);

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
  group("Dart - Authentication Tests", () {
    // end test

    test("authenticateAnonymous", () async {
      expect(bcWrapper.isInitialized, true);

      // bcWrapper.brainCloudClient.enableLogging(true);
      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();

      ServerResponse response = await bcWrapper.authenticateAnonymous();
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });

    test("reconnect", () async {

      ServerResponse response;
      if (bcWrapper.brainCloudClient.authenticated) {
        response = await bcWrapper.logout(false);
        expect(response.statusCode, 200);
        expect(bcWrapper.brainCloudClient.isAuthenticated(), false);
      }

      response = await bcWrapper.reconnect();
      expect(response.statusCode, 200);
    });

    test("authenticateEmailPassword", () async {
      expect(bcWrapper.isInitialized, true);

      bcWrapper.resetStoredProfileId();
      bcWrapper.resetStoredAnonymousId();
      ServerResponse response = await bcWrapper.authenticateEmailPassword(email: email, password: password, forceCreate: false);
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });

    test("logout", () async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) await bcWrapper.authenticateEmailPassword(email: email, password: password, forceCreate: false);

      ServerResponse response = await bcWrapper.logout(true);
      expect(response.statusCode, 200);

      try {
        response = await bcWrapper.reconnect();
        fail('Should fail reconnect as no session existed.');
      } on ServerResponse {
        (response) {
          expect(response.statusCode, 403);
        };
      }
    });
  });

  group("Dart - User Entity Tests", () {
    // String email = "";
    // String password = "";

    final String entityType = "UnitTests";
    String entityId = "";
    int entityVersion = 0;
    String singletonEntityId = "";
    int singletonEntityVerison = 0;

    // String sharedProfileId = "";
    String sharedEntityId = "";
    int sharedEntityVersion = 0;

    /// <summary>
    /// Utility to create entity for tests requiring one.
    /// </summary>
    Future testEntityFactory(String entityType) async {
      var jsonEntityData = {"street": "1309 Carling", "quantity": 0};
      var jsonEntityAcl = {"other": 0};
      ServerResponse response = await bcWrapper.entityService.createEntity(entityType, jsonEntityData, jsonEntityAcl);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        // await bcWrapper.authenticateEmailPassword(email: email, password: password, forceCreate: false);

        bcWrapper.resetStoredProfileId();
        bcWrapper.resetStoredAnonymousId();

        await bcWrapper.authenticateAnonymous();
      }
    });

    // end test

    test("createEntity", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"street": "1309 Carling"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService.createEntity(entityType, jsonEntityData, jsonEntityAcl);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("deleteEntity", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      ServerResponse response = await bcWrapper.entityService.deleteEntity(entityId, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("createEntity_noACL", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"street": "1309 Carling"};

      ServerResponse response = await bcWrapper.entityService.createEntity(entityType, jsonEntityData, null);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['acl'], isMap);
        expect(body['acl']['other'], 0);
      }
    });

    test("getEntitiesByType", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      ServerResponse response = await bcWrapper.entityService.getEntitiesByType(entityType);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entities'], isList,reason: "entities not an List");
      }
    });

    test("getEntity", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      ServerResponse response = await bcWrapper.entityService.getEntity(entityId);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['version'], entityVersion);
      }
    });

    test("getList", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      var whereJson = {"entityType": entityType, "data.street": "1309 Carling"};
      var orderByJson = {"data.street": 1};
      var maxReturn = 50;

      ServerResponse response = await bcWrapper.entityService.getList(whereJson, orderByJson, maxReturn);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("getListCount", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      var whereJson = {"entityType": entityType, "data.street": "1309 Carling"};

      ServerResponse response = await bcWrapper.entityService.getListCount(whereJson);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isNull);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("getPage", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      var context = {
        "pagination": {"rowsPerPage": 3, "pageNumber": 1},
        "searchCriteria": {"entityType": entityType},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      ServerResponse response = await bcWrapper.entityService.getPage(context);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['count'], isA<int>());
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
        expect(body['results']['page'], isA<int>());
      }
    });

    test("getPageOffset", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      var context = {
        "pagination": {"rowsPerPage": 3, "pageNumber": 1},
        "searchCriteria": {"entityType": entityType},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      String contextString = base64Encode(jsonEncode(context).codeUnits);

      ServerResponse response = await bcWrapper.entityService.getPageOffset(contextString, 1);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['count'], isA<int>());
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
        expect(body['results']['page'], isA<int>());
      }
    });

    test("getSharedEntitiesForProfileId", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped('No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      ServerResponse response = await bcWrapper.entityService.getSharedEntitiesForProfileId(sharedProfileId);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entities'], isList);
        expect(body['entityListCount'], isA<int>());
        if (body['entityListCount'] > 0) {
          sharedEntityId = body['entities'][0]['entityId'];
          sharedEntityVersion = body['entities'][0]['version'];
        }
      }
    });

    test("getSharedEntitiesListForProfileId", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped('No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      var whereJson = {"entityType": entityType, "data.street": "1309 Carling"};
      var orderByJson = {"data.street": 1};
      var maxReturn = 50;

      ServerResponse response = await bcWrapper.entityService.getSharedEntitiesListForProfileId(sharedProfileId, whereJson, orderByJson, maxReturn);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isNull);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("getSharedEntityForProfileId", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped('No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped('No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      ServerResponse response = await bcWrapper.entityService.getSharedEntityForProfileId(sharedProfileId, sharedEntityId);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], sharedEntityId);
        expect(body['version'], isA<int>());
        sharedEntityVersion = body['version'];
      }
    });

    test("getSingleton", () async {
      expect(bcWrapper.isInitialized, true);

      if (singletonEntityId.isEmpty) await testEntityFactory('${entityType}Singleton');

      ServerResponse response = await bcWrapper.entityService.getSingleton('${entityType}Singleton');

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        expect(body['entityId'], isA<String>());
        singletonEntityId = body['entityId'];
        singletonEntityVerison = body['version'];
      }
    });

    test("updateSingleton", () async {
      expect(bcWrapper.isInitialized, true);

      // if (singletonEntityId.isEmpty) await testEntityFactory('${entityType}Singleton');
      var jsonEntityData = {"street": "Moved"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService.updateSingleton('${entityType}Singleton', jsonEntityData, jsonEntityAcl, singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        singletonEntityVerison = body['version'];
      }
    });

    test("deleteSingleton", () async {
      expect(bcWrapper.isInitialized, true);

      if (singletonEntityId.isEmpty) await testEntityFactory('${entityType}Singleton');

      ServerResponse response = await bcWrapper.entityService.deleteSingleton('${entityType}Singleton', singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("updateSharedUserEntityData", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped('No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped('No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      var jsonEntityData = {"street": "main", "quantity": 1};

      ServerResponse response =
          await bcWrapper.entityService.updateSharedEntity(sharedEntityId, sharedProfileId, entityType, jsonEntityData, sharedEntityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        singletonEntityVerison = body['version'];
      }
    });
    test("incrementSharedUserEntityData", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped('No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped('No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      var jsonEntityData = {"quantity": 2.5};

      ServerResponse response = await bcWrapper.entityService.incrementSharedUserEntityData(sharedEntityId, sharedProfileId, jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        expect(body['data']['quantity'], isA<double>());
        expect(body['data']['quantity'], 3.5);
        singletonEntityVerison = body['version'];
      }
    });

    test("updateEntity", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      var jsonEntityData = {"street": "main", "quantity": 2};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService.updateEntity(entityId, entityType, jsonEntityData, jsonEntityAcl, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("incrementUserEntityData", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"quantity": 2.5};

      if (entityId.isEmpty) await testEntityFactory(entityType);

      ServerResponse response = await bcWrapper.entityService.incrementUserEntityData(entityId, jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        expect(body['data']['quantity'], isA<double>());
        expect(body['data']['quantity'], 4.5);
        singletonEntityVerison = body['version'];
      }
    });
  });
}
