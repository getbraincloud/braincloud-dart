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

  const String fileNameLarge = "largeFile.txt";
  const String cloudPath = "sub";
  const String fileNameImage = "TestFromMemory.png";

  group("File Tests", () {
    test("uploadFileFromMemory", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      final imageData = File('test/TestImg.png').readAsBytesSync();

      // ensure no other callback registered.
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      ServerResponse response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, fileNameImage, true, true, imageData);

      ServerResponse uploadResponse = await uploadCompleterFuture;

      // cleanup 
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> data = response.data!;
        expect(data['fileDetails'], isMap, reason: "Should return fileDetails");
        expect(data['fileDetails']['cloudFilename'], fileNameImage,
            reason: "Should return cloudFilename");
        expect(data['fileDetails']['shareable'], true,
            reason: "Should be sharable");
        expect(data['fileDetails']['replaceIfExists'], true,
            reason: "Should be replaceIfExists");
        expect(data['fileDetails']['fileType'], 'User',
            reason: "Should be User type file");
        expect(data['fileDetails']['fileSize'], imageData.length,
            reason: "File size should match");
      }

      expect(uploadResponse.statusCode, 200);
      if (uploadResponse.data != null) {
        expect(uploadResponse.data, isMap);
        Map<String, dynamic> body = uploadResponse.data!;
        expect(body['fileDetails']['cloudLocation'], isA<String>());
        expect(body['fileDetails']['downloadUrl'], isA<String>(),
            reason: "Should get a downloadUrl");
        expect(body['fileDetails']['fileSize'], imageData.length,
            reason: "File size should match");
        expect(body['fileDetails']['cloudFilename'], fileNameImage,
            reason: "Should return cloudFilename");
      }
    },tags: 'fileService');
    test("cancelUpload", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // ensure no other callback registered.
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      String filename = "largeFile.txt";
      String fileData = generateRandomString(1024 * 1024 * 20); // 20mb is the default max allowed in bC 
      String uploadId = "";
      
      var  response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, filename, true, true, utf8.encode(fileData));

      debugPrint("uploadFileFromMemory results ${response.toString()}");
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
        debugPrint("bytesTransferred: $bytesTransferred ");    
      while (bytesTransferred <= 0 && maxTries > 0) {
        await Future.delayed(const Duration(milliseconds: 75));
        //  await pumpEventQueue(times: 50);
        maxTries--;
        bytesTransferred =
            bcTest.bcWrapper.fileService.getUploadBytesTransferred(uploadId) ??
                0;
        debugPrint("bytesTransferred: $bytesTransferred");    
      }
      debugPrint("Cancelling Upload $uploadId now...");

      // now cancel it.
      bcTest.bcWrapper.fileService.cancelUpload(uploadId);        
      ServerResponse error = await uploadCompleterFuture;
      // cleanup 
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      debugPrint("After cancel results ${error.toString()}");

      expect(error.statusCode, 900);
      expect(error.reasonCode, 90100);
      expect(error.statusMessage, isNotNull);
      expect(error.statusMessage?.trim(),
          "Upload of largeFile.txt cancelled by user");
      if (error.data != null) {
        expect(error.data, isMap);
        Map<String, dynamic> body = error.data!;
        debugPrint(body.toString());
      }
    },tags: 'fileService');

    test("getUploadProgress", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      // ensure no other callback registered.
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      String fileData = generateRandomString(1024 * 1024 * 20);
      String uploadId = "";

      ServerResponse response = await bcTest.bcWrapper.fileService
          .uploadFileFromMemory(
              cloudPath, fileNameLarge, true, true, utf8.encode(fileData));

      expect(response.statusCode, 200);
      expect(bcTest.bcWrapper.isInitialized, true);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      // cleaup
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

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
      if (uploadResponse.data != null) {
        expect(uploadResponse.data, isMap);
        Map<String, dynamic> body = uploadResponse.data!;
        expect(body['fileDetails']['cloudLocation'], isA<String>());
        expect(body['fileDetails']['downloadUrl'], isA<String>(),
            reason: "Should get a downloadUrl");
        expect(body['fileDetails']['fileSize'], fileData.length,
            reason: "File size should match");
        expect(body['fileDetails']['cloudFilename'], fileNameLarge,
            reason: "Should return cloudFilename");
      }
    },tags: 'fileService');

    test("listUserFiles", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response =
          await bcTest.bcWrapper.fileService.listUserFiles(cloudPath, true);
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['fileList'], isList);
      }
    },tags: 'fileService');
    test("getCDNUrl", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.fileService
          .getCDNUrl(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['appServerUrl'], isA<String>());
        expect(body['cdnUrl'], isA<String>());
      }
    },tags: 'fileService');

    test("deleteUserFile", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.fileService
          .deleteUserFile(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        debugPrint(body.toString());
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['cloudFilename'], fileNameLarge);
      }
    },tags: 'fileService');
    test("deleteUserFiles", () async {
      expect(bcTest.bcWrapper.isInitialized, true);
      ServerResponse response =
          await bcTest.bcWrapper.fileService.deleteUserFiles(cloudPath, true);
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['fileList'], isList);
      }
    },tags: 'fileService');

    // end test
    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });

  group("GlobalFile Tests", () {
    test("getGlobalFileList", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.globalFileService
          .getGlobalFileList('/fname', true);

      expect(response.statusCode, 200);
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
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
      expect(response.data, isMap);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        expect(body['appServerUrl'], isA<String>());
        expect(body['cdnUrl'], isA<String>());
      }
    });

    /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
  });
}
