import 'dart:async';
import 'dart:math';
import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'stored_ids.dart';

class TestUser {
  late String name;
  late String password;
  late String email;
  String? profileId;

  TestUser(String name, String randomId) {
    this.name = "${name}_$randomId";
    this.password = "${name}_$randomId";
    this.email = "${name}_$randomId@test.getbraincloud.com";
  }
}

String generateRandomString(int length) {
  const characters =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
  final random = Random(DateTime.now().microsecond);
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => characters.codeUnitAt(random.nextInt(characters.length)),
  ));
}

main() {
  SharedPreferences.setMockInitialValues({});
  debugPrint('Braindcloud Dart Client unit tests');
  final bcWrapper = BrainCloudWrapper(wrapperName: "FlutterTest");
  String customEntityType = "";
  Map<String,dynamic> testFile = {};

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    customEntityType = ids.customEntityType;

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

  group("File Tests", () {
    TestUser userA = TestUser("UserA", generateRandomString(8));

    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(true);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: userA.name, password: userA.password, forceCreate: true);
      }
    });

    // end test


    test("getGlobalFileList", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcWrapper.globalFileService.getGlobalFileList('/',true);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['treeVersion'], isA<int>());
        expect(body['fileList'], isMap);
        if (body['fileList'] is Map) {
          if (body['fileList']['files'] is Map) {
            Map<String,dynamic> files =  body['fileList']['files'];
            if (files.isNotEmpty) {
              testFile = files.entries.first.value;
              testFile['folderPath'] = body['fileList']['folderPath'];
            }
          }
        }
      }
    });

    test("getFileInfo", () async {
      expect(bcWrapper.isInitialized, true);

      if (testFile['fileId'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }
      ServerResponse response =
          await bcWrapper.globalFileService.getFileInfo(testFile['fileId']);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['fileName'], testFile['fileName']);
        expect(body['fileDetails']['fileId'], testFile['fileId']);
        
      }
    });

    test("getFileInfoSimple", () async {
      expect(bcWrapper.isInitialized, true);

      if (testFile['fileName'] == null || testFile['folderPath'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }

      ServerResponse response = await bcWrapper.globalFileService.getFileInfoSimple(testFile['folderPath'],testFile['fileName']);
      
      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['fileName'], testFile['fileName']);
        expect(body['fileDetails']['fileId'], testFile['fileId']);        
      }

    });

    test("getGlobalCDNUrl", () async {
      expect(bcWrapper.isInitialized, true);
      
      if (testFile['fileId'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }

      ServerResponse response = await bcWrapper.globalFileService.getGlobalCDNUrl(testFile['fileId']);
      
      expect(response.statusCode, 200);
       expect(response.body, isMap);
       if (response.body != null) {
         expect(response.body, isMap);
         Map<String, dynamic> body = response.body!;
         expect(body['appServerUrl'], isA<String>());
         expect(body['cdnUrl'], isA<String>());
       }
      


    });
    
  });

}
