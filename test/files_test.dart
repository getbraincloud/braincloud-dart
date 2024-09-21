import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'utils/test_base.dart';
import 'utils/test_users.dart';

main() {
  BCTest bcTest = BCTest();
  setUpAll(bcTest.setupBC);

  Map<String, dynamic> testFile = {};
  TestUser userA = TestUser("UserA", generateRandomString(8));
  const String fileNameLarge = "largeFile.txt";
  const String cloudPath = "sub";
  const String fileNameImage = "TestFromMemory.png";

  group("File Tests", () {
    setUp(() async {
      bcTest.bcWrapper.brainCloudClient.enableLogging(false);
      if (!bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.authenticateUniversal(
            username: userA.name, password: userA.password, forceCreate: true);
      }
    });

    test("uploadFileFromMemory", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      final imageData = File('test/TestImg.png').readAsBytesSync();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      ServerResponse response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, fileNameImage, true, true, imageData);

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
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      String filename = "largeFile.txt";
      String fileData = generateRandomString(1024 * 1024 * 20);
      String uploadId = "";

      ServerResponse response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, filename, true, true, utf8.encode(fileData));

      expect(response.statusCode, 200);
      expect(bcTest.bcWrapper.isInitialized, true);
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
          bcTest.bcWrapper.fileService.getUploadBytesTransferred(uploadId) ?? 0;
      int maxTries = 10;
      while (bytesTransferred == 0 && maxTries > 0) {
        await Future.delayed(const Duration(milliseconds: 50));
        maxTries--;
        bytesTransferred =
            bcTest.bcWrapper.fileService.getUploadBytesTransferred(uploadId) ??
                0;
      }

      try {
        // now cancel it.
        bcTest.bcWrapper.fileService.cancelUpload(uploadId);
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
          debugPrint(body.toString());
        }
      }
    });

    test("getUploadProgress", () async {
      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      String fileData = generateRandomString(1024 * 1024 * 20);
      String uploadId = "";

      ServerResponse response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, fileNameLarge, true, true, utf8.encode(fileData));

      expect(response.statusCode, 200);
      expect(bcTest.bcWrapper.isInitialized, true);
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
            var progress =
                bcTest.bcWrapper.fileService.getUploadProgress(uploadId);
            var transferred = bcTest.bcWrapper.fileService
                .getUploadBytesTransferred(uploadId);
            var total = bcTest.bcWrapper.fileService
                .getUploadTotalBytesToTransfer(uploadId);
            expect(progress, isA<double>());
            expect(progress, isNot(-1),
                reason: "getUploadProgress should not be -1 yet");
            // expect(transferred, isA<double>());
            expect(transferred, isNot(-1),
                reason: "getUploadBytesTransferred should not be -1 yet");
            // expect(total, isA<double>());
            expect(total, isNot(-1),
                reason: "getUploadTotalBytesToTransfer should not be -1 yet");
            // print('progress: $progress  => $transferred of $total');
          },
        );
      }

      ServerResponse uploadResponse = await uploadCompleterFuture;
      var progress = bcTest.bcWrapper.fileService.getUploadProgress(uploadId);
      var transferred =
          bcTest.bcWrapper.fileService.getUploadBytesTransferred(uploadId);
      var total =
          bcTest.bcWrapper.fileService.getUploadTotalBytesToTransfer(uploadId);
      // print('final progress: $progress  => $transferred of $total');
      expect(progress, -1, reason: "getUploadProgress should now be -1");
      expect(transferred, -1,
          reason: "getUploadBytesTransferred should now be -1");
      expect(total, -1,
          reason: "getUploadTotalBytesToTransfer should now be -1");

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
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.fileService.listUserFiles(cloudPath, true);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['fileList'], isList);
      }
    });
    test("getCDNUrl", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.fileService
          .getCDNUrl(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['appServerUrl'], isA<String>());
        expect(body['cdnUrl'], isA<String>());
      }
    });

    test("deleteUserFile", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.fileService
          .deleteUserFile(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        debugPrint(body.toString());
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['cloudFilename'], fileNameLarge);
      }
    });
    test("deleteUserFiles", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      ServerResponse response =
          await bcTest.bcWrapper.fileService.deleteUserFiles(cloudPath, true);
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
      bcTest.bcWrapper.brainCloudClient.enableLogging(true);
      if (!bcTest.bcWrapper.brainCloudClient.isAuthenticated()) {
        await bcTest.bcWrapper.authenticateUniversal(
            username: userA.name, password: userA.password, forceCreate: true);
      }
    });

    // end test

    test("getGlobalFileList", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.globalFileService
          .getGlobalFileList('/fname', true);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (testFile['fileId'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }
      ServerResponse response = await bcTest.bcWrapper.globalFileService
          .getFileInfo(testFile['fileId']);

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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (testFile['fileName'] == null || testFile['folderPath'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }

      ServerResponse response = await bcTest.bcWrapper.globalFileService
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
      expect(bcTest.bcWrapper.isInitialized, true);

      if (testFile['fileId'] == null) {
        markTestSkipped("No global file found to test API.");
        return;
      }

      ServerResponse response = await bcTest.bcWrapper.globalFileService
          .getGlobalCDNUrl(testFile['fileId']);

      expect(response.statusCode, 200);
      expect(response.body, isMap);
      if (response.body != null) {
        expect(response.body, isMap);
        Map<String, dynamic> body = response.body!;
        expect(body['appServerUrl'], isA<String>());
        expect(body['cdnUrl'], isA<String>());
      }
    });

    /// END TEST
    test("Dispose", () {
      bcTest.dispose();
    });
  });
}
