import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:braincloud_dart/braincloud_dart.dart';
import 'package:test/test.dart';
import 'utils/test_base.dart';
import 'utils/test_users.dart';

const bool kIsWeb = bool.fromEnvironment('dart.library.js_util');

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

      final imageData = kIsWeb ? Uint8List.fromList(generateRandomString(1024 * 4).codeUnits) : File('test/TestImg.png').readAsBytesSync();

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
    });
    test("cancelUpload", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      // ensure no other callback registered.
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      String filename = "largeFile.txt";
      String fileData = generateRandomString(
          1024 * 1024 * 20); // 20mb is the default max allowed in bC
      String uploadId = "";

      var response = await bcTest.bcWrapper.fileService.uploadFileFromMemory(
          cloudPath, filename, true, true, utf8.encode(fileData));

      print("uploadFileFromMemory results ${response.toString()}");
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
      print("bytesTransferred: $bytesTransferred ");
      while (bytesTransferred <= 0 && maxTries > 0) {
        await Future.delayed(const Duration(milliseconds: 75));
        //  await pumpEventQueue(times: 50);
        maxTries--;
        bytesTransferred =
            bcTest.bcWrapper.fileService.getUploadBytesTransferred(uploadId) ??
                0;
        print("bytesTransferred: $bytesTransferred");
      }
      print("Cancelling Upload $uploadId now...");

      // now cancel it.
      bcTest.bcWrapper.fileService.cancelUpload(uploadId);
      ServerResponse error = await uploadCompleterFuture;
      // cleanup
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      print("After cancel results ${error.toString()}");

      expect(error.statusCode, 900);
      expect(error.reasonCode, 90100);
      expect(error.error, isNotNull);
      expect(error.error?.trim(),
          "Upload of largeFile.txt cancelled by user");
      if (error.data != null) {
        expect(error.data, isMap);
        Map<String, dynamic> body = error.data!;
        print(body.toString());
      }
    },timeout: Timeout.parse("90s"));

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
    },timeout: Timeout.parse("90s"));

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
    });
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
    });

    test("deleteUserFile", () async {
      expect(bcTest.bcWrapper.isInitialized, true);

      ServerResponse response = await bcTest.bcWrapper.fileService
          .deleteUserFile(cloudPath, fileNameLarge);
      expect(response.statusCode, 200);
      if (response.data != null) {
        expect(response.data, isMap);
        Map<String, dynamic> body = response.data!;
        print(body.toString());
        expect(body['fileDetails'], isMap);
        expect(body['fileDetails']['cloudFilename'], fileNameLarge);
      }
    });
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

  });

  group("GroupFile Tests", () {
    String groupId = "";
    List<FileDetail> groupAvailableFiles = [];
    const String groupCloudPath = "";
    const String groupFileNameImage = "GroupTestFile.png";

    // helper fiunction

    createUserFile() async {

      final imageData = kIsWeb ? Uint8List.fromList(generateRandomString(1024 * 1024 * 20).codeUnits) : File('test/TestImg.png').readAsBytesSync();

      // ensure no other callback registered.
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();

      var uploadCompleterFuture =
          bcTest.bcWrapper.brainCloudClient.registerFileUploadCallback();

      Future<ServerResponse> uploadFuture =  bcTest.bcWrapper.fileService.uploadFileFromMemory(
          groupCloudPath, groupFileNameImage, true, true, imageData);
      bcTest.bcWrapper.brainCloudClient.insertEndOfMessageBundleMarker();
      
      ServerResponse response = await uploadFuture;

      expect(response.statusCode, 200, reason: "Failed to upload TestImd");

      ServerResponse uploadResponse = await uploadCompleterFuture;

      print("++++ createUserFile uploadResponse returned ${uploadResponse.data}");

      // expect(uploadResponse.data?['fileDetails']['fileId'], isA<String>(),
      //     reason: "Should get a downloadUrl");
      // String fileId = uploadResponse.data?['fileDetails']['fileId'];

      // cleanup
      bcTest.bcWrapper.brainCloudClient.deregisterFileUploadCallback();
      
      return Future.value();      
    }

    createGroupFile() async {
      await createUserFile();

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .moveUserToGroupFile(
              userCloudPath: groupCloudPath,
              userCloudFilename: groupFileNameImage,
              groupId: groupId,
              groupTreeId: "",
              groupFilename: groupFileNameImage,
              groupFileAcl: {"member": 2, "other": 0},
              overwriteIfPresent: true);
      

      expect(response.data?['fileDetails']['fileId'], isNotNull);
      groupAvailableFiles.add(FileDetail(
          groupFileNameImage,
          response.data?['fileDetails']['fileId'],
          response.data?['fileDetails']['version']));
      print("!!! groupFileId is now $groupAvailableFiles");
      
      return Future.value();
    }

    setUpAll(() async {
      // Ensure the there is a group that include the current user.
      ServerResponse response = await bcTest.bcWrapper.groupService.createGroup(
          name: "test",
          groupType: "test",
          isOpenGroup: false,
          jsonData: {"reason": "Group to test groupd files"});
      print("Group File setUpAll createGroup returned ${response.data}");
      groupId = response.data?["groupId"];
    });

    test("moveUserToGroupFile", () async {
      await createUserFile();

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .moveUserToGroupFile(
              userCloudPath: groupCloudPath,
              userCloudFilename: groupFileNameImage,
              groupId: groupId,
              groupTreeId: "",
              groupFilename: groupFileNameImage,
              groupFileAcl: {"member": 2, "other": 0},
              overwriteIfPresent: true);
      print("moveUserToGroupFile returned ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull,
          reason: "moveUserToGroupFile should return data");
      expect(response.data?['fileDetails'], isNotNull,
          reason: "moveUserToGroupFile should return data.fileDetails");
    },timeout: Timeout.parse("90s"));
    test("checkFilenameExists", () async {
      // Ensure there is a file
      if (groupAvailableFiles.isEmpty) await createGroupFile();

      print(
          "--pre-checkFilenameExists returned groupId:$groupId groupCloudPath:$groupCloudPath groupFileNameImage:$groupFileNameImage");
      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .checkFilenameExists(
              groupId: groupId,
              folderPath: groupCloudPath,
              filename: groupFileNameImage);

      print("checkFilenameExists returned ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['exists'], isA<bool>());
    },timeout: Timeout.parse("90s"));

    test("checkFullpathFilenameExists", () async {
      // Ensure there is a file
      if (groupAvailableFiles.isEmpty) await createGroupFile();

      print(
          "--pre-checkFullpathFilenameExists returned groupId:$groupId fullPath:$groupCloudPath/$groupFileNameImage");
      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .checkFullpathFilenameExists(
              groupId: groupId,
              fullPathFilename: "$groupCloudPath/$groupFileNameImage");
      print("checkFilenameExists returned ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['exists'], isA<bool>());
    },timeout: Timeout.parse("90s"));

    test("copyFile", () async {
      FileDetail filedetail = groupAvailableFiles.first;
      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .copyFile(
              groupId: groupId,
              fileId: filedetail.fileId,
              version: filedetail.version,
              newTreeId: "",
              treeVersion: 0,
              newFilename: "copied$groupFileNameImage",
              overwriteIfPresent: true);

      print("copyFile returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['fileDetails'], isNotNull);
      // expect(response.data?['fileDetails'], isNotNull);
      expect(response.data?['fileDetails']['fileId'], isA<String>());
      groupAvailableFiles.add(FileDetail(
          "copied$groupFileNameImage",
          response.data?['fileDetails']['fileId'],
          response.data?['fileDetails']['version']));
    },timeout: Timeout.parse("90s"));

    test("deleteFile", () async {
      // Ensure there is a file to delete
      if (groupAvailableFiles.isEmpty) await createGroupFile();

      FileDetail filedetail = groupAvailableFiles.removeLast();
      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .deleteFile(
              groupId: groupId,
              fileId: filedetail.fileId,
              version: filedetail.version,
              filename: filedetail.name);
      print("deleteFile returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['fileDetails'], isNotNull);
    },timeout: Timeout.parse("90s"));
    test("getCDNUrl", () async {
      // Ensure there is a file
      if (groupAvailableFiles.isEmpty) await createGroupFile();
      FileDetail filedetail = groupAvailableFiles.first;

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .getCDNUrl(groupId: groupId, fileId: filedetail.fileId);
      print("getCDNUrl returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['cdnUrl'], isA<String>());
      expect(response.data?['groupId'], isA<String>());
      expect(response.data?['appServerUrl'], isA<String>());
    });
    test("getFilelnfo", () async {
      // Ensure there is a file
      if (groupAvailableFiles.isEmpty) await createGroupFile();

      FileDetail filedetail = groupAvailableFiles.first;

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .getFileInfo(groupId: groupId, fileId: filedetail.fileId);
      print("getFileInfo returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['fileDetails'], isNotNull);
      expect(response.data?['groupId'], isA<String>(),
          reason: "groupdId should be a string");
      expect(response.data?['fileDetails']['url'], isA<String>(),
          reason: "appServerUrl should be a string");
    });
    test("getFileInfoSimple", () async {
      // Ensure there is a file
      if (groupAvailableFiles.isEmpty) await createGroupFile();
      FileDetail filedetail = groupAvailableFiles.first;

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .getFileInfoSimple(
              groupId: groupId, filename: filedetail.name, folderPath: "");
      print("getFileInfoSimple returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['fileDetails'], isNotNull);
      expect(response.data?['groupId'], isA<String>(),
          reason: "groupdId should be a string");
      expect(response.data?['fileDetails']['url'], isA<String>(),
          reason: "appServerUrl should be a string");
    },timeout: Timeout.parse("90s"));
    test("getFileList", () async {
      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .getFileList(groupId: groupId, folderPath: "", recurse: false);
      print("getFileList returned : ${response.data}");
      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull);
      expect(response.data?['treeVersion'], isNotNull);
      expect(response.data?['fileList'], isNotNull);
    },timeout: Timeout.parse("90s"));
    test("moveFile", () async {
      if (groupAvailableFiles.isEmpty) await createGroupFile();
      FileDetail filedetail = groupAvailableFiles.first;
      String destFolderName = "";
      String destFolderId = "";
      int destFolderVersion = 0;

      ServerResponse findFolderResponse = await bcTest
          .bcWrapper.groupFileService
          .getFileList(groupId: groupId, folderPath: "", recurse: true);
      if (findFolderResponse.data?['fileList'].isNotEmpty &&
          findFolderResponse.data?['fileList']['folders'].isNotEmpty) {
        print(
            "===--===--===--== findFolderResponse ${findFolderResponse.data?['fileList']['folders']}");
        destFolderName =
            findFolderResponse.data?['fileList']['folders'].keys.first;
        destFolderId = findFolderResponse.data?['fileList']['folders']
            [destFolderName]['treeId'];
        destFolderVersion = findFolderResponse.data?['fileList']['folders']
            [destFolderName]['version'];
      }

      if (destFolderId.isNotEmpty) {
        ServerResponse response = await bcTest.bcWrapper.groupFileService
            .moveFile(
                groupId: groupId,
                fileId: filedetail.fileId,
                version: filedetail.version,
                newTreeId: destFolderId,
                treeVersion: destFolderVersion,
                newFilename: filedetail.name,
                overwriteIfPresent: true);

        expect(response.statusCode, StatusCodes.ok);
        expect(response.data, isNotNull,
            reason: "moveUserToGroupFile should return data");
        expect(response.data?['fileDetails'], isNotNull,
            reason: "moveUserToGroupFile should return data.fileDetails");
      } else {
        print("=== findFolderResponse $findFolderResponse");
        markTestSkipped("Did not find a folder to move to.");
      }
    },timeout: Timeout.parse("90s"));
    test("updateFileInfo", () async {
      if (groupAvailableFiles.isEmpty) await createGroupFile();
      FileDetail filedetail = groupAvailableFiles.first;

      ServerResponse response = await bcTest.bcWrapper.groupFileService
          .updateFileInfo(
              groupId: groupId,
              fileId: filedetail.fileId,
              version: filedetail.version,
              newFilename: "new_${filedetail.name}",
              newAcl: {"member": 2, "other": 0});

      expect(response.statusCode, StatusCodes.ok);
      expect(response.data, isNotNull,
          reason: "moveUserToGroupFile should return data");
      expect(response.data?['fileDetails'], isNotNull,
          reason: "moveUserToGroupFile should return data.fileDetails");
    });

  });
      /// END TEST
    tearDownAll(() {
      bcTest.dispose();
    });
}

class FileDetail {
  String fileId;
  int version;
  String name;

  FileDetail(this.name, this.fileId, this.version) {}
}
