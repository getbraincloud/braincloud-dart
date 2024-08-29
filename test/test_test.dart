import 'dart:async';
import 'dart:convert';
import 'package:braincloud_dart/src/Common/acl.dart';
import 'package:braincloud_dart/src/braincloud_wrapper.dart';
import 'package:braincloud_dart/src/internal/braincloud_comms.dart';
import 'package:braincloud_dart/src/internal/rtt_comms.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/v1.dart';
import 'package:uuid/v4.dart';

import 'stored_ids.dart';

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String email = "";
  String password = "";
  String sharedProfileId = "";
  String customEntityType = "";
  String customShardedEntityType = "";
  String customOwnedEntityType = "";
  final String entityType = "DartUnitTests";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    email = ids.email.isEmpty ? "${UuidV4().generate()}@DartUnitTester" : ids.email;
    password = ids.password.isEmpty ? UuidV4().generate() : ids.password;
    sharedProfileId = ids.sharedProfileId;
    customEntityType = ids.customEntityType;
    customShardedEntityType = ids.customShardedEntityType;
    customOwnedEntityType = ids.customOwnedEntityType;

    debugPrint(
        'email: ${ids.email} in appId: ${ids.appId} at ${ids.url}  with customEntityType $customEntityType');
    //start test

    bcWrapper
        .init(
            secretKey: ids.secretKey,
            appId: ids.appId,
            version: ids.version,
            url: ids.url)
        .then((_) {
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
  group("Authentication Tests", () {
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
      if (sharedProfileId.isEmpty) {
        // if no shared Profile Id define in ids then use the anonymous user
        sharedProfileId = response.body?['profileId'];
        // and create a shared entity too as this will be needed.
        var jsonEntityData = {"team": "RedTeam", "quantity": 0};
        await bcWrapper.entityService.createEntity(entityType, jsonEntityData, ACLs.readWrite);        
      }
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
      ServerResponse response = await bcWrapper.authenticateEmailPassword(
          email: email, password: password, forceCreate: false);
      // debugPrint(jsonEncode(response.body));
      expect(response.statusCode, 200);
      expect(response.body?['profileId'], isA<String>());
      expect(response.body?['server_time'], isA<int>());
      expect(response.body?['createdAt'], isA<int>());
      expect(response.body?['isTester'], isA<bool>());
      expect(response.body?['currency'], isA<Object>());
    });

    test("logout", () async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
      }

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

  group("User Entity Tests", () {

    const String entityType = "UnitTests";
    String entityId = "";
    int entityVersion = 0;
    String singletonEntityId = "";
    int singletonEntityVerison = 0;
    String sharedEntityId = "";
    int sharedEntityVersion = 0;

    /// <summary>
    /// Utility to create entity for tests requiring one.
    /// </summary>
    Future testEntityFactory(String entityType) async {
      var jsonEntityData = {"team": "RedTeam", "quantity": 0};
      var jsonEntityAcl = {"other": 0};
      ServerResponse response = await bcWrapper.entityService
          .createEntity(entityType, jsonEntityData, jsonEntityAcl);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
        // bcWrapper.resetStoredProfileId();
        // bcWrapper.resetStoredAnonymousId();
        // await bcWrapper.authenticateAnonymous();
      }
    });

    // end test

    test("createEntity", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService
          .createEntity(entityType, jsonEntityData, jsonEntityAcl);

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

      ServerResponse response =
          await bcWrapper.entityService.deleteEntity(entityId, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("createEntity_noACL", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};

      ServerResponse response = await bcWrapper.entityService
          .createEntity(entityType, jsonEntityData, null);

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

      ServerResponse response =
          await bcWrapper.entityService.getEntitiesByType(entityType);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entities'], isList, reason: "entities not an List");
      }
    });

    test("getEntity", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(entityType);

      ServerResponse response =
          await bcWrapper.entityService.getEntity(entityId);

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

      var whereJson = {"entityType": entityType, "data.team": "RedTeam"};
      var orderByJson = {"data.team": 1};
      var maxReturn = 50;

      ServerResponse response = await bcWrapper.entityService
          .getList(whereJson, orderByJson, maxReturn);

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

      var whereJson = {"entityType": entityType, "data.team": "RedTeam"};

      ServerResponse response =
          await bcWrapper.entityService.getListCount(whereJson);

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

      ServerResponse response =
          await bcWrapper.entityService.getPageOffset(contextString, 1);

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
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      ServerResponse response = await bcWrapper.entityService
          .getSharedEntitiesForProfileId(sharedProfileId);

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
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      var whereJson = {"entityType": entityType, "data.team": "RedTeam"};
      var orderByJson = {"data.team": 1};
      var maxReturn = 50;

      ServerResponse response = await bcWrapper.entityService
          .getSharedEntitiesListForProfileId(
              sharedProfileId, whereJson, orderByJson, maxReturn);

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
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped(
            'No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      ServerResponse response = await bcWrapper.entityService
          .getSharedEntityForProfileId(sharedProfileId, sharedEntityId);

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

      if (singletonEntityId.isEmpty) {
        await testEntityFactory('${entityType}Singleton');
      }

      ServerResponse response =
          await bcWrapper.entityService.getSingleton('${entityType}Singleton');

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
      var jsonEntityData = {"team": "Moved"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService.updateSingleton(
          '${entityType}Singleton',
          jsonEntityData,
          jsonEntityAcl,
          singletonEntityVerison);

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

      if (singletonEntityId.isEmpty) {
        await testEntityFactory('${entityType}Singleton');
      }

      ServerResponse response = await bcWrapper.entityService
          .deleteSingleton('${entityType}Singleton', singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("updateSharedUserEntityData", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped(
            'No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      var jsonEntityData = {"team": "main", "quantity": 1};

      ServerResponse response = await bcWrapper.entityService
          .updateSharedEntity(sharedEntityId, sharedProfileId, entityType,
              jsonEntityData, sharedEntityVersion);

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
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped(
            'No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      var jsonEntityData = {"quantity": 2.5};

      ServerResponse response = await bcWrapper.entityService
          .incrementSharedUserEntityData(
              sharedEntityId, sharedProfileId, jsonEntityData);

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

      var jsonEntityData = {"team": "main", "quantity": 2};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.entityService.updateEntity(
          entityId, entityType, jsonEntityData, jsonEntityAcl, entityVersion);

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

      ServerResponse response = await bcWrapper.entityService
          .incrementUserEntityData(entityId, jsonEntityData);

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

  group("Global Entity Tests", () {
    String entityId = "";
    int entityVersion = 0;
    String entityType = "UnitTest_Glb";
    String entityIndexedId = "UnitTest-GlobalService";

    /// <summary>
    /// Utility to create entity for tests requiring one.
    /// </summary>
    Future createGlobalTestEntity(String entityType) async {
      var jsonEntityData = {"team": "RedTeam", "games": 0};
      var jsonEntityAcl = {"other": 0};
      ServerResponse response = await bcWrapper.globalEntityService
          .createEntity(entityType, const Duration(hours: 12), jsonEntityAcl,
              jsonEntityData);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
      }
    });

    test("createEntity", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "left",
        "role": "guard"
      };
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.globalEntityService
          .createEntity(entityType, const Duration(hours: 1), jsonEntityAcl,
              jsonEntityData);

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

    test("createEntity_min_params", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "right",
        "role": "guard"
      };

      ServerResponse response = await bcWrapper.globalEntityService
          .createEntity(entityType, null, null, jsonEntityData);

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

    test("GetList", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"entityType": entityType};
      var orderBy = {"data.team": 1};

      ServerResponse response =
          await bcWrapper.globalEntityService.getList(where, orderBy, 1);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("GetListCount", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"entityType": entityType};

      ServerResponse response =
          await bcWrapper.globalEntityService.getListCount(where);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isNull);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("GetListCountWithHint", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};

      ServerResponse response =
          await bcWrapper.globalEntityService.getListCountWithHint(where, hint);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isNull);
        expect(body['entityListCount'], isA<int>());
      }
    });
    test("GetListWithHint", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};
      var orderBy = {"data.team": 1};

      ServerResponse response = await bcWrapper.globalEntityService
          .getListWithHint(where, orderBy, 2, hint);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });
    test("GetPage", () async {
      expect(bcWrapper.isInitialized, true);

      var context = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1},
        "searchCriteria": {"entityType": "address"},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      ServerResponse response =
          await bcWrapper.globalEntityService.getPage(context);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['page'], isA<int>());
        expect(body['results']['count'], isA<int>());
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
      }
    });
    test("GetPageOffset", () async {
      expect(bcWrapper.isInitialized, true);

      var context = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1},
        "searchCriteria": {"entityType": "address"},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };
      String contextString = base64Encode(jsonEncode(context).codeUnits);

      ServerResponse response =
          await bcWrapper.globalEntityService.getPageOffset(contextString, 1);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['page'], isA<int>());
        expect(body['results']['count'], isA<int>());
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
      }
    });
    test("GetRandomEntitiesMatching", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"data.team": "RedTeam"};

      ServerResponse response = await bcWrapper.globalEntityService
          .getRandomEntitiesMatching(where, 2);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });
    test("GetRandomEntitiesMatchingWithHint", () async {
      expect(bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};

      ServerResponse response = await bcWrapper.globalEntityService
          .getRandomEntitiesMatchingWithHint(where, hint, 2);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });
    test("IncrementGlobalEntityData", () async {
      expect(bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonInc = {"games": 2};

      ServerResponse response = await bcWrapper.globalEntityService
          .incrementGlobalEntityData(entityId, jsonInc);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['games'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("ReadEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response =
          await bcWrapper.globalEntityService.readEntity(entityId);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['games'], isA<int>());
        expect(body['data']['team'], isA<String>());
      }
    });
    test("UpdateEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonData = {"team": "BlueTeam", "games": 1};

      ServerResponse response = await bcWrapper.globalEntityService
          .updateEntity(entityId, entityVersion, jsonData);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("UpdateEntityAcl", () async {
      expect(bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonEntityAcl = {"other": 2};

      ServerResponse response = await bcWrapper.globalEntityService
          .updateEntityAcl(entityId, entityVersion, jsonEntityAcl);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['acl'], isMap);
        expect(body['acl']['other'], 2);
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("UpdateEntityOwnerAndAcl", () async {
      expect(bcWrapper.isInitialized, true);

      if (sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcWrapper.globalEntityService
          .updateEntityOwnerAndAcl(
              entityId, entityVersion, sharedProfileId, jsonEntityAcl);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['acl'], ACLs.readWrite);
        entityVersion = body['version'];
      }
    });
    test("UpdateEntityTimeToLive", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var timeToLive = const Duration(hours: 6);

      ServerResponse response = await bcWrapper.globalEntityService
          .updateEntityTimeToLive(entityId, entityVersion, timeToLive);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['timeToLive'], timeToLive.inMilliseconds);
        entityVersion = body['version'];
      }
    });
    test("DeleteEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response = await bcWrapper.globalEntityService
          .deleteEntity(entityId, entityVersion);
      expect(response.statusCode, 200);
      expect(response.body, isNull);
      entityId = "";
      entityVersion = 0;
    });

    /// IndextedId...
    ///
    test("createEntityWithIndexedId", () async {
      expect(bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.globalEntityService
          .createEntityWithIndexedId(entityType, entityIndexedId,
              const Duration(hours: 1), jsonEntityAcl, jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], isA<String>());
        expect(body['entityIndexedId'], isA<String>());
        expect(body['entityIndexedId'], entityIndexedId);
        expect(body['version'], isA<int>());
      }
    });

    test("GetListByIndexedld", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response = await bcWrapper.globalEntityService
          .getListByIndexedId(entityIndexedId, 4);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
        if (body['entityListCount'] > 0) {
          // List<Map<String,dynamic>> entityList = body['entityList'];
          entityId = body['entityList'][0]['entityId'];
          expect(body['entityList'][0]['version'], isA<int>());
          entityVersion = body['entityList'][0]['version'];
        }
      }
    });
    test("UpdateEntityIndexedld", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response = await bcWrapper.globalEntityService
          .updateEntityIndexedId(
              entityId, entityVersion, '${entityIndexedId}New');

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['entityIndexedId'], '${entityIndexedId}New');
      }
    });

    /// SystemEntities...
    ///
    test("MakeSystemEntity", () async {
      expect(bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);
      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcWrapper.globalEntityService
          .makeSystemEntity(entityId, entityVersion, jsonEntityAcl);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['owner'], isNull,
            reason: 'owner should be null for system entity');
      }
    });
  });

  group("Custom Entity Tests", () {
    String entityId = "";
    int entityVersion = 0;

    /// <summary>
    /// Utility to create entity for tests requiring one.
    /// </summary>
    Future createCustomTestEntity(String entityType,
        {bool owned = false}) async {
      var jsonEntityData = {"testId": "RedTeam", "team": "RedTeam", "games": 0};
      var jsonEntityAcl = {"other": 2};
      ServerResponse response = await bcWrapper.customEntityService
          .createEntity(entityType, jsonEntityData, jsonEntityAcl,
              const Duration(hours: 12), owned);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
      }
    });

    test("CreateEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      var jsonEntityData = {
        "testId": "RedTeam",
        "team": "RedTeam",
        "position": "left",
        "role": "guard"
      };
      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcWrapper.customEntityService
          .createEntity(customEntityType, jsonEntityData, jsonEntityAcl,
              const Duration(hours: 1), false);

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
    test("GetCount", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var where = {"data.teamId": "RedTeam"};

      ServerResponse response =
          await bcWrapper.customEntityService.getCount(customEntityType, where);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityListCount'], isA<int>());
        expect(body['entityList'], isNull,
            reason: 'There should not be entity list on a Count opereation');
      }
    });
    test("GetEntityPage", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var jsonContext = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1, "doCount": true},
        "searchCriteria": {"data.teamId": "RedTeam"},
        "sortCriteria": {}
      };

      ServerResponse response = await bcWrapper.customEntityService
          .getEntityPage(customEntityType, jsonContext);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['page'], isA<int>());
        expect(body['results']['count'], isA<int>());
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
      }
    });
    test("GetEntityPageOffset", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var jsonContext = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1, "doCount": false},
        "searchCriteria": {"data.teamId": "RedTeam"},
        "sortCriteria": {}
      };
      String contextString = base64Encode(jsonEncode(jsonContext).codeUnits);

      ServerResponse response = await bcWrapper.customEntityService
          .getEntityPageOffset(customEntityType, contextString, 1);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['results'], isMap);
        expect(body['results']['items'], isList);
        expect(body['results']['page'], 2);
        expect(body['results']['count'], isNull);
        expect(body['results']['moreBefore'], isA<bool>());
        expect(body['results']['moreAfter'], isA<bool>());
      }
    });
    test("GetRandomEntitiesMatching", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var where = {"data.teamId": "RedTeam"};

      ServerResponse response = await bcWrapper.customEntityService
          .getRandomEntitiesMatching(customEntityType, where, 2);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityListCount'], isA<int>());
        expect(body['entityList'], isList,
            reason: 'There should not be entity list on a Count opereation');
      }
    });
    test("IncrementData", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty) await createCustomTestEntity(customEntityType);

      var jsonInc = {"games": 2};

      ServerResponse response = await bcWrapper.customEntityService
          .incrementData(customEntityType, entityId, jsonInc);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['games'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("ReadEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty) await createCustomTestEntity(customEntityType);

      ServerResponse response = await bcWrapper.customEntityService
          .readEntity(customEntityType, entityId);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['games'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("UpdateEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) await createCustomTestEntity(customEntityType);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "left",
        "role": "guard",
        "games": 1
      };
      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcWrapper.customEntityService
          .updateEntity(customEntityType, entityId, entityVersion,
              jsonEntityData, jsonEntityAcl, const Duration(hours: 1));

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
    test("UpdateEntityFields", () async {
      expect(bcWrapper.isInitialized, true);
      if (customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty) await createCustomTestEntity(customEntityType);
      var jsonEntityData = {"position": "right"};

      ServerResponse response = await bcWrapper.customEntityService
          .updateEntityFields(
              customEntityType, entityId, entityVersion, jsonEntityData);

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

    test("IncrementDataSharded", () async {
      if (customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      expect(bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      await createCustomTestEntity(customShardedEntityType);

      var jsonInc = {"games": 2};
      // This shard hkey may not be valie
      var shardKeyJson = {"ownerId": "profileIdOfEntityOwner"};

      ServerResponse response = await bcWrapper.customEntityService
          .incrementDataSharded(
              customEntityType, entityId, jsonInc, shardKeyJson);
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['games'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("UpdateEntityFieldsSharded", () async {
      if (customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test UpdateEntityFieldsSharded");
        return;
      }
      expect(bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      await createCustomTestEntity(customShardedEntityType);
      var jsonEntityData = {"position": "right"};
      var shardKeyJson = {"ownerId": "profileIdOfEntityOwner"};

      ServerResponse response = await bcWrapper.customEntityService
          .updateEntityFieldsSharded(customShardedEntityType, entityId,
              entityVersion, jsonEntityData, shardKeyJson);

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

    test("DeleteEntity", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      await createCustomTestEntity(customOwnedEntityType, owned: true);

      ServerResponse response = await bcWrapper.customEntityService
          .deleteEntity(customOwnedEntityType, entityId, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isNull);
    });

    test("DeleteEntities", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      // Ensure at least one entity will be deleted
      await createCustomTestEntity(customOwnedEntityType, owned: true);
      var deleteCriteria = {"data.testId": "RedTeam"};

      ServerResponse response = await bcWrapper.customEntityService
          .deleteEntities(customOwnedEntityType, deleteCriteria);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['deletedCount'], isA<int>());
        entityId = "";
        entityVersion = 0;
      }
    });

    /// Singleton
    test("UpdateSingleton", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      await createCustomTestEntity(customOwnedEntityType, owned: true);
      var jsonEntityData = {"testId": "RedTeam", "team": "RedTeam", "games": 0};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcWrapper.customEntityService
          .updateSingleton(customOwnedEntityType, entityVersion, jsonEntityData,
              jsonEntityAcl, const Duration(hours: 4));

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("IncrementSingletonData", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(customOwnedEntityType, owned: true);
      }

      var jsonFieldsData = {"games": 2};

      ServerResponse response = await bcWrapper.customEntityService
          .incrementSingletonData(customOwnedEntityType, jsonFieldsData);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['data']['games'], isA<int>());
      }
    });
    test("ReadSingleton", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(customOwnedEntityType, owned: true);
      }

      ServerResponse response = await bcWrapper.customEntityService
          .readSingleton(customOwnedEntityType);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['data']['games'], isA<int>());
        expect(body['data']['team'], isA<String>());
      }
    });
    test("UpdateSingletonFields", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(customOwnedEntityType, owned: true);
      }
      var jsonFieldsData = {"team": "BlueTeam"};

      ServerResponse response = await bcWrapper.customEntityService
          .updateSingletonFields(customOwnedEntityType, -1, jsonFieldsData);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['updatedAt'], isA<int>());
        // entityVersion = body['version'];
      }
    });
    test("DeleteSingleton", () async {
      expect(bcWrapper.isInitialized, true);
      if (customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(customOwnedEntityType, owned: true);
      }

      ServerResponse response = await bcWrapper.customEntityService
          .deleteSingleton(customOwnedEntityType, -1);

      expect(response.statusCode, 200);
      expect(response.body, isNull);
    });
  });

  group("Test RTT", () {
    setUp(() async {
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateEmailPassword(
            email: email, password: password, forceCreate: false);
      }
    });

    test("enableRTT", () async {
      bcWrapper.rTTService?.disableRTT();

      ServerResponse? response =
          await bcWrapper.rTTService?.enableRTT(RTTConnectionType.websocket);

      if (response != null) {
        expect(response.body?['operation'], 'CONNECT');
      } else {
        throw "rtt response was null";
      }
    });
  });
}
