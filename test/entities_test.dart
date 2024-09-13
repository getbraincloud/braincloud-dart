import 'dart:convert';
import 'package:braincloud_dart/braincloud_dart.dart';

import 'package:flutter_test/flutter_test.dart';
import 'test_base.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  group("User Entity Tests", () {
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
      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(entityType, jsonEntityData, jsonEntityAcl);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(bcTest.auth);

    test("createEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(bcTest.entityType, jsonEntityData, jsonEntityAcl);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response = await bcTest.bcWrapper.entityService
          .deleteEntity(entityId, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("createEntity_noACL", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(bcTest.entityType, jsonEntityData, null);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getEntitiesByType(bcTest.entityType);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['entities'], isList, reason: "entities not an List");
      }
    });

    test("getEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response =
          await bcTest.bcWrapper.entityService.getEntity(entityId);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var whereJson = {"entityType": bcTest.entityType, "data.team": "RedTeam"};
      var orderByJson = {"data.team": 1};
      var maxReturn = 50;

      ServerResponse response = await bcTest.bcWrapper.entityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var whereJson = {"entityType": bcTest.entityType, "data.team": "RedTeam"};

      ServerResponse response =
          await bcTest.bcWrapper.entityService.getListCount(whereJson);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var context = {
        "pagination": {"rowsPerPage": 3, "pageNumber": 1},
        "searchCriteria": {"entityType": bcTest.entityType},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      ServerResponse response =
          await bcTest.bcWrapper.entityService.getPage(context);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var context = {
        "pagination": {"rowsPerPage": 3, "pageNumber": 1},
        "searchCriteria": {"entityType": bcTest.entityType},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      String contextString = base64Encode(jsonEncode(context).codeUnits);

      ServerResponse response =
          await bcTest.bcWrapper.entityService.getPageOffset(contextString, 1);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getSharedEntitiesForProfileId(bcTest.ids.sharedProfileId);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      var whereJson = {"entityType": bcTest.entityType, "data.team": "RedTeam"};
      var orderByJson = {"data.team": 1};
      var maxReturn = 50;

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getSharedEntitiesListForProfileId(
              bcTest.ids.sharedProfileId, whereJson, orderByJson, maxReturn);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }
      if (sharedEntityId.isEmpty) {
        markTestSkipped(
            'No Shared Entity Id profided skipping test getSharedEntitiesForProfileId (must run getSharedEntitiesForProfileId test first)');
        return;
      }

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getSharedEntityForProfileId(
              bcTest.ids.sharedProfileId, sharedEntityId);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (singletonEntityId.isEmpty) {
        await testEntityFactory('${bcTest.entityType}Singleton');
      }

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getSingleton('${bcTest.entityType}Singleton');

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
      expect(bcTest.bcWrapper.isInitialized, true);

      // if (singletonEntityId.isEmpty) await testEntityFactory('${bcTest.entityType}Singleton');
      var jsonEntityData = {"team": "Moved"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateSingleton('${bcTest.entityType}Singleton', jsonEntityData,
              jsonEntityAcl, singletonEntityVerison);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (singletonEntityId.isEmpty) {
        await testEntityFactory('${bcTest.entityType}Singleton');
      }

      ServerResponse response = await bcTest.bcWrapper.entityService
          .deleteSingleton(
              '${bcTest.entityType}Singleton', singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.body, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("updateSharedUserEntityData", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
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

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateSharedEntity(sharedEntityId, bcTest.ids.sharedProfileId,
              bcTest.entityType, jsonEntityData, sharedEntityVersion);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
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

      ServerResponse response = await bcTest.bcWrapper.entityService
          .incrementSharedUserEntityData(
              sharedEntityId, bcTest.ids.sharedProfileId, jsonEntityData);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var jsonEntityData = {"team": "main", "quantity": 2};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateEntity(entityId, bcTest.entityType, jsonEntityData,
              jsonEntityAcl, entityVersion);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"quantity": 2.5};

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response = await bcTest.bcWrapper.entityService
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
      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .createEntity(entityType, const Duration(hours: 12), jsonEntityAcl,
              jsonEntityData);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(bcTest.auth);

    test("createEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "left",
        "role": "guard"
      };
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "right",
        "role": "guard"
      };

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"entityType": entityType};
      var orderBy = {"data.team": 1};

      ServerResponse response =
          await bcTest.bcWrapper.globalEntityService.getList(where, orderBy, 1);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"entityType": entityType};

      ServerResponse response =
          await bcTest.bcWrapper.globalEntityService.getListCount(where);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .getListCountWithHint(where, hint);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};
      var orderBy = {"data.team": 1};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var context = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1},
        "searchCriteria": {"entityType": "address"},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };

      ServerResponse response =
          await bcTest.bcWrapper.globalEntityService.getPage(context);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var context = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1},
        "searchCriteria": {"entityType": "address"},
        "sortCriteria": {"createdAt": 1, "updatedAt": -1}
      };
      String contextString = base64Encode(jsonEncode(context).codeUnits);

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .getPageOffset(contextString, 1);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"data.team": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      var where = {"entityIndexedId": entityIndexedId};
      var hint = {"gameId": 1, "entityIndexedId": 1};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonInc = {"games": 2};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response =
          await bcTest.bcWrapper.globalEntityService.readEntity(entityId);
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonData = {"team": "BlueTeam", "games": 1};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonEntityAcl = {"other": 2};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (bcTest.ids.sharedProfileId.isEmpty) {
        markTestSkipped(
            'No Shared Entities ProfileId profided skipping test getSharedEntitiesForProfileId');
        return;
      }

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .updateEntityOwnerAndAcl(entityId, entityVersion,
              bcTest.ids.sharedProfileId, jsonEntityAcl);
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var timeToLive = const Duration(hours: 6);

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .deleteEntity(entityId, entityVersion);
      expect(response.statusCode, 200);
      expect(response.body, isNull);
      entityId = "";
      entityVersion = 0;
    });

    /// IndextedId...
    ///
    test("createEntityWithIndexedId", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await createGlobalTestEntity(entityType);
      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
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
      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .createEntity(entityType, jsonEntityData, jsonEntityAcl,
              const Duration(hours: 12), owned);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(bcTest.auth);

    test("CreateEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
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

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .createEntity(bcTest.ids.customEntityType, jsonEntityData,
              jsonEntityAcl, const Duration(hours: 1), false);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var where = {"data.teamId": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .getCount(bcTest.ids.customEntityType, where);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var jsonContext = {
        "pagination": {"rowsPerPage": 50, "pageNumber": 1, "doCount": true},
        "searchCriteria": {"data.teamId": "RedTeam"},
        "sortCriteria": {}
      };

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .getEntityPage(bcTest.ids.customEntityType, jsonContext);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
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

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .getEntityPageOffset(bcTest.ids.customEntityType, contextString, 1);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      var where = {"data.teamId": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .getRandomEntitiesMatching(bcTest.ids.customEntityType, where, 2);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty)
        await createCustomTestEntity(bcTest.ids.customEntityType);

      var jsonInc = {"games": 2};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .incrementData(bcTest.ids.customEntityType, entityId, jsonInc);
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty)
        await createCustomTestEntity(bcTest.ids.customEntityType);

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .readEntity(bcTest.ids.customEntityType, entityId);
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty)
        await createCustomTestEntity(bcTest.ids.customEntityType);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "left",
        "role": "guard",
        "games": 1
      };
      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateEntity(bcTest.ids.customEntityType, entityId, entityVersion,
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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      if (entityId.isEmpty)
        await createCustomTestEntity(bcTest.ids.customEntityType);
      var jsonEntityData = {"position": "right"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateEntityFields(bcTest.ids.customEntityType, entityId,
              entityVersion, jsonEntityData);

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
      if (bcTest.ids.customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      expect(bcTest.bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      await createCustomTestEntity(bcTest.ids.customShardedEntityType);

      var jsonInc = {"games": 2};
      // This shard hkey may not be valie
      var shardKeyJson = {"ownerId": "profileIdOfEntityOwner"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .incrementDataSharded(
              bcTest.ids.customEntityType, entityId, jsonInc, shardKeyJson);
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
      if (bcTest.ids.customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test UpdateEntityFieldsSharded");
        return;
      }
      expect(bcTest.bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      await createCustomTestEntity(bcTest.ids.customShardedEntityType);
      var jsonEntityData = {"position": "right"};
      var shardKeyJson = {"ownerId": "profileIdOfEntityOwner"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateEntityFieldsSharded(bcTest.ids.customShardedEntityType,
              entityId, entityVersion, jsonEntityData, shardKeyJson);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }
      await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
          owned: true);

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .deleteEntity(
              bcTest.ids.customOwnedEntityType, entityId, entityVersion);

      expect(response.statusCode, 200);
      expect(response.body, isNull);
    });

    test("DeleteEntities", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      // Ensure at least one entity will be deleted
      await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
          owned: true);
      var deleteCriteria = {"data.testId": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .deleteEntities(bcTest.ids.customOwnedEntityType, deleteCriteria);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
          owned: true);
      var jsonEntityData = {"testId": "RedTeam", "team": "RedTeam", "games": 0};
      var jsonEntityAcl = {"other": 0};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateSingleton(bcTest.ids.customOwnedEntityType, entityVersion,
              jsonEntityData, jsonEntityAcl, const Duration(hours: 4));

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
            owned: true);
      }

      var jsonFieldsData = {"games": 2};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .incrementSingletonData(
              bcTest.ids.customOwnedEntityType, jsonFieldsData);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
            owned: true);
      }

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .readSingleton(bcTest.ids.customOwnedEntityType);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
            owned: true);
      }
      var jsonFieldsData = {"team": "BlueTeam"};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateSingletonFields(
              bcTest.ids.customOwnedEntityType, -1, jsonFieldsData);

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
      expect(bcTest.bcWrapper.isInitialized, true);
      if (bcTest.ids.customOwnedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      if (entityId.isEmpty) {
        await createCustomTestEntity(bcTest.ids.customOwnedEntityType,
            owned: true);
      }

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .deleteSingleton(bcTest.ids.customOwnedEntityType, -1);

      expect(response.statusCode, 200);
      expect(response.body, isNull);
    });
  });
}
