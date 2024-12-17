import 'dart:convert';
import 'package:braincloud_dart/braincloud_dart.dart';

import 'package:test/test.dart';
import 'utils/test_base.dart';

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

    /// Utility to create entity for tests requiring one.

    Future testEntityFactory(String entityType) async {
      var jsonEntityData = {"team": "RedTeam", "quantity": 0};
      var jsonEntityAcl = ACLs.none;
      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(
              entityType: entityType,
              jsonEntityData: jsonEntityData,
              jsonEntityAcl: jsonEntityAcl);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    setUp(() async {
      // This will create some shared entities that will be used in tests below
      if (bcTest.ids.sharedProfileId.isEmpty) {
        ServerResponse response =
            await bcTest.bcWrapper.authenticateAnonymous();
        // if no shared Profile Id define in ids then use the anonymous user
        bcTest.ids.sharedProfileId = response.data?['profileId'];
        // and create a shared entity too as this will be needed.
        var jsonEntityData = {"team": "RedTeam", "quantity": 0};
        ServerResponse createResponse = await bcTest.bcWrapper.entityService
            .createEntity(
                entityType: bcTest.entityType,
                jsonEntityData: jsonEntityData,
                jsonEntityAcl: ACLs.readWrite);

        if (createResponse.data != null) {
          Map<String, dynamic> body = createResponse.data!;
          expect(body['entityId'], isA<String>());
          sharedEntityId = body['entityId'];
          expect(body['version'], isA<int>());
          sharedEntityVersion = body['version'];
        }
      }
    });

    test("createEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = ACLs.none;

      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(
              entityType: bcTest.entityType,
              jsonEntityData: jsonEntityData,
              jsonEntityAcl: jsonEntityAcl);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .deleteEntity(entityId: entityId, version: entityVersion);

      expect(response.statusCode, 200);
      expect(response.data, isNull);

      entityId = "";
      entityVersion = 0;
    });

    test("createEntity_noACL", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .createEntity(
              entityType: bcTest.entityType, jsonEntityData: jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
        expect(body['acl'], isMap);
        expect(body['acl'], ACLs.none);
      }
    });

    test("getEntitiesByType", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getEntitiesByType(entityType: bcTest.entityType);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entities'], isList, reason: "entities not an List");
      }
    });

    test("getEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response =
          await bcTest.bcWrapper.entityService.getEntity(entityId: entityId);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityId'], entityId);
        expect(body['version'], entityVersion);
      }
    });

    test("getList", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) {
        await testEntityFactory(bcTest.entityType);
      }

      var whereJson = {"entityType": bcTest.entityType, "data.team": "RedTeam"};
      var orderByJson = {"data.team": 1};
      var maxReturn = 50;

      ServerResponse response = await bcTest.bcWrapper.entityService.getList(
          whereJson: whereJson, orderByJson: orderByJson, maxReturn: maxReturn);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityList'], isList);
        expect(body['entityListCount'], isA<int>());
      }
    });

    test("getListCount", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      var whereJson = {"entityType": bcTest.entityType, "data.team": "RedTeam"};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getListCount(whereJson: whereJson);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          await bcTest.bcWrapper.entityService.getPage(jsonContext: context);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getPageOffset(context: contextString, pageOffset: 1);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getSharedEntitiesForProfileId(profileId: bcTest.ids.sharedProfileId);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
              profileId: bcTest.ids.sharedProfileId,
              whereJson: whereJson,
              orderByJson: orderByJson,
              maxReturn: maxReturn);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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

      ServerResponse response = await bcTest.bcWrapper.entityService
          .getSharedEntityForProfileId(
              profileId: bcTest.ids.sharedProfileId, entityId: sharedEntityId);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getSingleton(entityType: '${bcTest.entityType}Singleton');

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      var jsonEntityAcl = ACLs.none;

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateSingleton(
              entityType: '${bcTest.entityType}Singleton',
              jsonEntityData: jsonEntityData,
              jsonEntityAcl: jsonEntityAcl,
              version: singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
              entityType: '${bcTest.entityType}Singleton',
              version: singletonEntityVerison);

      expect(response.statusCode, 200);
      expect(response.data, isNull);

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

      var jsonEntityData = {"team": "main", "quantity": 1};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateSharedEntity(
              entityId: sharedEntityId,
              targetProfileId: bcTest.ids.sharedProfileId,
              entityType: bcTest.entityType,
              jsonEntityData: jsonEntityData,
              version: sharedEntityVersion);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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

      var jsonEntityData = {"quantity": 2.5};

      ServerResponse response = await bcTest.bcWrapper.entityService
          .incrementSharedUserEntityData(
              entityId: sharedEntityId,
              targetProfileId: bcTest.ids.sharedProfileId,
              jsonData: jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      var jsonEntityAcl = ACLs.none;

      ServerResponse response = await bcTest.bcWrapper.entityService
          .updateEntity(
              entityId: entityId,
              entityType: bcTest.entityType,
              jsonEntityData: jsonEntityData,
              jsonEntityAcl: jsonEntityAcl,
              version: entityVersion);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("incrementUserEntityData", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"quantity": 2.5};

      if (entityId.isEmpty) await testEntityFactory(bcTest.entityType);

      ServerResponse response = await bcTest.bcWrapper.entityService
          .incrementUserEntityData(
              entityId: entityId, jsonData: jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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

    /// Utility to create entity for tests requiring one.

    Future createGlobalTestEntity(String entityType) async {
      var jsonEntityData = {"team": "RedTeam", "games": 0};
      var jsonEntityAcl = ACLs.none;
      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .createEntity(entityType, const Duration(hours: 12), jsonEntityAcl,
              jsonEntityData);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        entityId = body['entityId'];
        entityVersion = body['version'];
      }
    }

    test("createEntity", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {
        "team": "RedTeam",
        "position": "left",
        "role": "guard"
      };
      var jsonEntityAcl = ACLs.none;

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .createEntity(entityType, const Duration(hours: 1), jsonEntityAcl,
              jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityId'], entityId);
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("UpdateEntityAcl", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      if (entityId.isEmpty) await createGlobalTestEntity(entityType);

      var jsonEntityAcl = ACLs.readWrite;

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .updateEntityAcl(entityId, entityVersion, jsonEntityAcl);
      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isNull);
      entityId = "";
      entityVersion = 0;
    });

    /// IndextedId...
    ///
    test("createEntityWithIndexedId", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      var jsonEntityData = {"team": "RedTeam"};
      var jsonEntityAcl = ACLs.read;

      ServerResponse response = await bcTest.bcWrapper.globalEntityService
          .createEntityWithIndexedId(entityType, entityIndexedId,
              const Duration(hours: 1), jsonEntityAcl, jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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

    /// Utility to create entity for tests requiring one.

    Future<Map<String, dynamic>> createCustomTestEntity(String entityType,
        {dynamic entityData, bool owned = false}) async {
      var jsonEntityData =
          entityData ?? {"testId": "RedTeam", "team": "RedTeam", "games": 0};
      var jsonEntityAcl = ACLs.readWrite;
      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .createEntity(
              entityType: entityType,
              dataJson: jsonEntityData,
              acl: jsonEntityAcl,
              timeToLive: Duration(hours: 12),
              isOwned: owned);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        entityId = body['entityId'];
        entityVersion = body['version'];
        return body;
      }
      return {};
    }

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
          .createEntity(
              entityType: bcTest.ids.customEntityType,
              dataJson: jsonEntityData,
              acl: jsonEntityAcl,
              timeToLive: Duration(hours: 1),
              isOwned: false);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getCount(entityType: bcTest.ids.customEntityType, whereJson: where);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getEntityPage(
              entityType: bcTest.ids.customEntityType,
              jsonContext: jsonContext);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getEntityPageOffset(
              entityType: bcTest.ids.customEntityType,
              context: contextString,
              pageOffset: 1);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .getRandomEntitiesMatching(
              entityType: bcTest.ids.customEntityType,
              whereJson: where,
              maxReturn: 2);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .incrementData(
              entityType: bcTest.ids.customEntityType,
              entityId: entityId,
              fieldsJson: jsonInc);
      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .readEntity(
              entityType: bcTest.ids.customEntityType, entityId: entityId);
      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .updateEntity(
              entityType: bcTest.ids.customEntityType,
              entityId: entityId,
              version: entityVersion,
              dataJson: jsonEntityData,
              acl: jsonEntityAcl,
              timeToLive: Duration(hours: 1));

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .updateEntityFields(
              entityType: bcTest.ids.customEntityType,
              entityId: entityId,
              version: entityVersion,
              fieldsJson: jsonEntityData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityId'], isA<String>());
        entityId = body['entityId'];
        expect(body['version'], isA<int>());
        entityVersion = body['version'];
      }
    });

    test("incrementDataSharded", () async {
      if (bcTest.ids.customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test IncrementDataSharded");
        return;
      }

      expect(bcTest.bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      Map<String, dynamic> shardedEnt = await createCustomTestEntity(
          bcTest.ids.customShardedEntityType,
          entityData: {"GamesPlayed": 2, "Name": "Zoro", "Goals": 7},
          owned: true);

      if (shardedEnt.isEmpty) {
        markTestSkipped("No entity to increment.");
      }
      var jsonInc = {"Goals": 2};
      var shardKeyJson = {"ownerId": shardedEnt['ownerId']};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .incrementDataSharded(
              entityType: bcTest.ids.customShardedEntityType,
              entityId: shardedEnt['entityId'],
              fieldsJson: jsonInc,
              shardKeyJson: shardKeyJson);
      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['entityId'], entityId);
        expect(body['data'], isMap);
        expect(body['data']['Goals'], isA<int>());
        entityVersion = body['version'];
      }
    });
    test("updateEntityFieldsSharded", () async {
      if (bcTest.ids.customShardedEntityType.isEmpty) {
        markTestSkipped(
            "No sharded collection in test app, skipping test UpdateEntityFieldsSharded");
        return;
      }
      expect(bcTest.bcWrapper.isInitialized, true);
      //Force the creation to ensure the current entityId is of a sharded entity
      // await createCustomTestEntity(bcTest.ids.customShardedEntityType);
      Map<String, dynamic> shardedEnt = await createCustomTestEntity(
          bcTest.ids.customShardedEntityType,
          entityData: {"GamesPlayed": 2, "Name": "Zoro", "Goals": 7},
          owned: true);

      var jsonEntityData = {"Name": "Rambo"};
      var shardKeyJson = {"ownerId": shardedEnt['ownerId']};

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateEntityFieldsSharded(
              entityType: bcTest.ids.customShardedEntityType,
              entityId: shardedEnt['entityId'],
              version: shardedEnt['version'],
              fieldsJson: jsonEntityData,
              shardKeyJson: shardKeyJson);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
              entityType: bcTest.ids.customOwnedEntityType,
              entityId: entityId,
              version: entityVersion);

      expect(response.statusCode, 200);
      expect(response.data, isNull);
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
          .deleteEntities(
              entityType: bcTest.ids.customOwnedEntityType,
              deleteCriteria: deleteCriteria);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      var jsonEntityAcl = ACLs.none;

      ServerResponse response = await bcTest.bcWrapper.customEntityService
          .updateSingleton(
              entityType: bcTest.ids.customOwnedEntityType,
              version: entityVersion,
              dataJson: jsonEntityData,
              acl: jsonEntityAcl,
              timeToLive: Duration(hours: 4));

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
              entityType: bcTest.ids.customOwnedEntityType,
              fieldsJson: jsonFieldsData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .readSingleton(entityType: bcTest.ids.customOwnedEntityType);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
              entityType: bcTest.ids.customOwnedEntityType,
              version: -1,
              fieldsJson: jsonFieldsData);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
          .deleteSingleton(
              entityType: bcTest.ids.customOwnedEntityType, version: -1);

      expect(response.statusCode, 200);
      expect(response.data, isNull);
    });
  });

  /// END TEST
  tearDownAll(() {
    bcTest.dispose();
  });
}
