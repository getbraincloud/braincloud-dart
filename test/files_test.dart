import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  Map<String, dynamic> testFile = {};
  TestUser userA = TestUser("UserA", generateRandomString(8));
  final String fileNameLarge = "largeFile.txt";
  final String cloudPath = "sub";
  final String fileNameImage = "TestFromMemory.png";

  setUpAll(() async {
    // });
    // test("Init", () async {
    StoredIds ids = StoredIds('test/ids.txt');
    await ids.load();

    customEntityType = ids.customEntityType;

    userA.email = ids.email;
    userA.password = ids.password;
    userA.name = ids.email;

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
        // print('BC: RUN-LOOP tick ${DateTime.now().millisecondsSinceEpoch}');
        bcWrapper.update();
      });
    }).onError((error, stackTrace) {
      debugPrint(error.toString());
    });
  });

  group("File Tests", () {
    setUp(() async {
      bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcWrapper.authenticateUniversal(
            username: userA.name, password: userA.password, forceCreate: true);
      }
    });

    test("uploadFileFromMemory", () async {
      expect(bcWrapper.isInitialized, true);

      final imageData = File('test/TestImg.png').readAsBytesSync();

      var uploadCompleterFuture =
          bcWrapper.brainCloudClient.registerFileUploadCallback();

      ServerResponse response = await bcWrapper.fileService
          .uploadFileFromMemory(cloudPath, fileNameImage, true, true, imageData);

      ServerResponse uploadResponse = await uploadCompleterFuture;

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileDetails'], isMap, reason: "Should return fileDetails");
        expect(body['fileDetails']['cloudFilename'], fileNameImage,
            reason: "Should return cloudFilename");
        expect(body['fileDetails']['shareable'], true,
            reason: "Should be sharable");
        expect(body['fileDetails']['replaceIfExists'], true,
            reason: "Should be replaceIfExists");
        expect(body['fileDetails']['fileType'], 'User',
            reason: "Should be User type file");
        expect(body['fileDetails']['fileSize'], imageData.length,
            reason: "File size should match");
      }

      expect(uploadResponse.statusCode, 200);
      if (uploadResponse.body != null) {
        expect(uploadResponse.body, isMap);
        Map<String, dynamic> body = uploadResponse.body!;
        expect(body['fileDetails']['cloudLocation'], isA<String>());
        expect(body['fileDetails']['downloadUrl'], isA<String>(),
            reason: "Should get a downloadUrl");
        expect(body['fileDetails']['fileSize'], imageData.length,
            reason: "File size should match");
        expect(body['fileDetails']['cloudFilename'], fileNameImage,
            reason: "Should return cloudFilename");
      }
    });
    test("cancelUpload", () async {
      var uploadCompleterFuture =
          bcWrapper.brainCloudClient.registerFileUploadCallback();

      String filename = "largeFile.txt";
      String fileData = generateRandomString(1024 * 1024 * 20);
      String uploadId = "";

      ServerResponse response = await bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, filename, true, true, utf8.encode(fileData));

      expect(response.statusCode, 200);
      expect(bcWrapper.isInitialized, true);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileDetails'], isMap, reason: "Should return fileDetails");
        expect(body['fileDetails']['cloudFilename'], filename,
            reason: "Should return cloudFilename");
        expect(body['fileDetails']['shareable'], true,
            reason: "Should be sharable");
        expect(body['fileDetails']['replaceIfExists'], true,
            reason: "Should be replaceIfExists");
        expect(body['fileDetails']['fileType'], 'User',
            reason: "Should be User type file");
        expect(body['fileDetails']['fileSize'], fileData.length,
            reason: "File size should match");
        expect(body['fileDetails']['uploadId'], isA<String>(),
            reason: "Should have an uploadId");
        uploadId = body['fileDetails']['uploadId'];
      }

      // Wait until the transfer actually starts
      int bytesTransferred =
          bcWrapper.fileService.getUploadBytesTransferred(uploadId) ?? 0;
      int maxTries = 10;
      while (bytesTransferred == 0 && maxTries > 0) {
        await Future.delayed(Duration(milliseconds: 50));
        maxTries--;
        bytesTransferred =
            bcWrapper.fileService.getUploadBytesTransferred(uploadId) ?? 0;
      }

      try {
        // now cancel it.
        bcWrapper.fileService.cancelUpload(uploadId);
        await uploadCompleterFuture;
        fail("Should have cancel the upload");
      } on ServerResponse catch (error) {
        expect(error.statusCode, 900);
        expect(error.reasonCode, 90100);
        expect(error.statusMessage, isNotNull);
        expect(error.statusMessage?.trim(),
            "Upload of largeFile.txt cancelled by user");
        if (error.body != null) {
          expect(error.body, isMap);
          Map<String, dynamic> body = error.body!;
          print(body);
        }
      }
      ;
    });

    test("getUploadProgress", () async {
      var uploadCompleterFuture =
          bcWrapper.brainCloudClient.registerFileUploadCallback();

      String fileData = generateRandomString(1024 * 1024 * 20);
      String uploadId = "";

      ServerResponse response = await bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, fileNameLarge, true, true, utf8.encode(fileData));

      expect(response.statusCode, 200);
      expect(bcWrapper.isInitialized, true);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileDetails'], isMap, reason: "Should return fileDetails");
        expect(body['fileDetails']['cloudFilename'], fileNameLarge,
            reason: "Should return cloudFilename");
        expect(body['fileDetails']['shareable'], true,
            reason: "Should be sharable");
        expect(body['fileDetails']['replaceIfExists'], true,
            reason: "Should be replaceIfExists");
        expect(body['fileDetails']['fileType'], 'User',
            reason: "Should be User type file");
        expect(body['fileDetails']['fileSize'], fileData.length,
            reason: "File size should match");
        expect(body['fileDetails']['uploadId'], isA<String>(),
            reason: "Should have an uploadId");
        uploadId = body['fileDetails']['uploadId'];
      }

      for (var i = 0; i < 5; i++) {
        Timer(
          Duration(milliseconds: 500 * i),
          () {
            var progress = bcWrapper.fileService.getUploadProgress(uploadId);
            var transferred =
                bcWrapper.fileService.getUploadBytesTransferred(uploadId);
            var total =
                bcWrapper.fileService.getUploadTotalBytesToTransfer(uploadId);
            expect(progress, isA<double>());
            expect(progress, isNot(-1),reason: "getUploadProgress should not be -1 yet");
            // expect(transferred, isA<double>());
            expect(transferred, isNot(-1),reason: "getUploadBytesTransferred should not be -1 yet");
            // expect(total, isA<double>());
            expect(total, isNot(-1),reason: "getUploadTotalBytesToTransfer should not be -1 yet");
            // print('progress: $progress  => $transferred of $total');
          },
        );
      }

      ServerResponse uploadResponse = await uploadCompleterFuture;
      var progress = bcWrapper.fileService.getUploadProgress(uploadId);
      var transferred =
          bcWrapper.fileService.getUploadBytesTransferred(uploadId);
      var total = bcWrapper.fileService.getUploadTotalBytesToTransfer(uploadId);
      // print('final progress: $progress  => $transferred of $total');
      expect(progress, -1,reason: "getUploadProgress should now be -1");
      expect(transferred, -1,reason: "getUploadBytesTransferred should now be -1");
      expect(total, -1,reason: "getUploadTotalBytesToTransfer should now be -1");

      expect(uploadResponse.statusCode, 200);
      if (uploadResponse.body != null) {
        expect(uploadResponse.body, isMap);
        Map<String, dynamic> body = uploadResponse.body!;
        expect(body['fileDetails']['cloudLocation'], isA<String>());
        expect(body['fileDetails']['downloadUrl'], isA<String>(),
            reason: "Should get a downloadUrl");
        expect(body['fileDetails']['fileSize'], fileData.length,
            reason: "File size should match");
        expect(body['fileDetails']['cloudFilename'], fileNameLarge,
            reason: "Should return cloudFilename");
      }
    });
    test("listUserFiles", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcWrapper.fileService.listUserFiles(cloudPath, true);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileList'], isList);         
      }

    });
    test("getCDNUrl", () async {
      expect(bcWrapper.isInitialized, true);
      
      ServerResponse response =
          await bcWrapper.fileService.getCDNUrl(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['appServerUrl'], isA<String>());
        expect(body['cdnUrl'], isA<String>());
      }

    });

    test("deleteUserFile", () async {
      expect(bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcWrapper.fileService.deleteUserFile(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        print(body);
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['cloudFilename'], fileNameLarge);
      }


    });
    test("deleteUserFiles", () async {
      expect(bcWrapper.isInitialized, true);
            ServerResponse response =
          await bcWrapper.fileService.deleteUserFiles(cloudPath, true);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileList'], isList);
      }

    });
  });
  group("GlobalFile Tests", () {
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
          await bcWrapper.globalFileService.getGlobalFileList('/', true);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['treeVersion'], isA<int>());
        expect(body['fileList'], isMap);
        if (body['fileList'] is Map) {
          if (body['fileList']['files'] is Map) {
            Map<String, dynamic> files = body['fileList']['files'];
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

      ServerResponse response = await bcWrapper.globalFileService
          .getFileInfoSimple(testFile['folderPath'], testFile['fileName']);

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

      ServerResponse response =
          await bcWrapper.globalFileService.getGlobalCDNUrl(testFile['fileId']);

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
