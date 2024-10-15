import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudGroupFile {
  final BrainCloudClient _clientRef;

  BrainCloudGroupFile(this._clientRef);

  /// Check if filename exists for provided path and name.

  /// @param groupIdID of the group.
  /// @param folderPathFile located cloud path/folder
  /// @param fileNameFile cloud name

  /// @returns Future<ServerResponse>
  Future<ServerResponse> checkFilenameExists({required String groupId, required String folderPath,
      required String fileName}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = fileName;

    return _sendRequest(ServiceOperation.checkFilenameExists, data);
  }

  /// Check if filename exists for provided path and name.

  /// @param groupIdID of the group.
  /// @param fullPathFilenameFile cloud name in full path

  /// @returns Future<ServerResponse>
  Future<ServerResponse> checkFullpathFilenameExists(
      {required String groupId,
      required String fullPathFilename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fullPathFilename.value] = fullPathFilename;

    return _sendRequest(ServiceOperation.checkFullpathFilenameExists, data);
  }

  /// Copy a file.

  /// @param groupIdID of the group.
  /// @param fileId 	The id of the file.
  /// @param version 	The target version of the file.
  /// @param newTreeIdThe id of the destination folder.
  /// @param treeVersionThe target version of the folder tree.
  /// @param newFilenameThe optional new file name.
  /// @param overwriteIfPresentWhether to allow overwrite of an existing file if present.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> copyFile(
      {required String groupId,
      required String fileId,
      required int version,
      required String newTreeId,
      required int treeVersion,
      required String newFilename,
      required bool overwriteIfPresent}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.newTreeId.value] = newTreeId;
    data[OperationParam.treeVersion.value] = treeVersion;
    data[OperationParam.newFilename.value] = newFilename;
    data[OperationParam.overwriteIfPresent.value] = overwriteIfPresent;

    return _sendRequest(ServiceOperation.copyFile, data);
  }

  /// Delete a file.

  /// @param groupIdThe id of the group.
  /// @param fileIdThe id of the file.
  /// @param versionThe target version of the file.
  /// @param filenameThe file name for verification purposes.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> deleteFile(
    {required String groupId, 
    required String fileId, 
    required int version,
    required String filename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.fileName.value] = filename;

    return _sendRequest(ServiceOperation.deleteFile, data);
  }

  /// Return CDN url for file for clients that cannot handle redirect.

  /// @param groupIdThe id of the group.
  /// @param fileIdThe id of the file.

  /// @returns Future<ServerResponse>
  Future<ServerResponse> getCDNUrl(
    {required String groupId, 
    required String fileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getCdnUrl, data);
  }

  /// Returns information on a file using fileId.

  /// @param groupIdID of the group.
  /// @param fileIdThe id of the file.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> getFileInfo(
    {required String groupId, 
    required String fileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getFileInfo, data);
  }

  /// Returns information on a file using path and name.

  /// @param groupIdThe id of the group.
  /// @param folderPathThe folder path.
  /// @param filenameThe file name.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> getFileInfoSimple(
    {required String groupId, 
    required String folderPath,
    required String filename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = filename;

    return _sendRequest(ServiceOperation.getFileInfoSimple, data);
  }

  /// Returns a list of files.

  /// @param groupIdThe id of the group.
  /// @param folderPathThe folder path.
  /// @param recurseWhether to recurse beyond the starting folder.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> getFileList(
    {required String groupId, 
    required String folderPath,
    required bool recurse}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.recurse.value] = recurse;

    return _sendRequest(ServiceOperation.getFileList, data);
  }

  /// Move a file.

  /// @param groupIdThe id of the group.
  /// @param fileIdThe id of the file.
  /// @param versionThe target version of the file. As an option, you can use -1 for the latest version of the file
  /// @param newTreeIdThe id of the destination folder.
  /// @param treeVersionThe target version of the folder tree.
  /// @param newFilenameThe optional new file name.
  /// @param overwriteIfPresentWhether to allow overwrite of an existing file if present.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> moveFile(
      {required String groupId,
      required String fileId,
      required int version,
      required String newTreeId,
      required int treeVersion,
      required String newFilename,
      required bool overwriteIfPresent}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.newTreeId.value] = newTreeId;
    data[OperationParam.treeVersion.value] = treeVersion;
    data[OperationParam.newFilename.value] = newFilename;
    data[OperationParam.overwriteIfPresent.value] = overwriteIfPresent;

    return _sendRequest(ServiceOperation.moveFile, data);
  }

  /// Move a file from user space to group space.

  /// @param userCloudPathThe user file folder.
  /// @param userCloudFilenameThe user file name.
  /// @param groupIdThe id of the group.
  /// @param groupTreeIdThe id of the destination folder.
  /// @param groupFilenameThe group file name.
  /// @param groupFileAclThe acl of the new group file.
  /// @param overwriteIfPresentWhether to allow overwrite of an existing file if present.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> moveUserToGroupFile(
      {required String userCloudPath,
      required String userCloudFilename,
      required String groupId,
      required String groupTreeId,
      required String groupFilename,
      required Map<String, dynamic> groupFileAcl,
      required bool overwriteIfPresent}) async {

    Map<String, dynamic> data = {};
    data[OperationParam.userCloudPath.value] = userCloudPath;
    data[OperationParam.userCloudFilename.value] = userCloudFilename;
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.groupTreeId.value] = groupTreeId;
    data[OperationParam.groupFilename.value] = groupFilename;
    data[OperationParam.groupFileACL.value] = groupFileAcl;
    data[OperationParam.overwriteIfPresent.value] = overwriteIfPresent;

    return _sendRequest(ServiceOperation.moveUserToGroupFile, data);
  }

  /// Returns information on a file using fileId.

  /// @param groupIdThe id of the group.
  /// @param fileIdThe id of the file.
  /// @param versionThe target version of the file. As an option, you can use -1 for the latest version of the file
  /// @param newFilenameThe optional new file name.
  /// @param newACL 	The optional new acl.
  /// @returns Future<ServerResponse>
  Future<ServerResponse> updateFileInfo(
      {required String groupId,
      required String fileId,
      required int version,
      required String newFilename,
      required Map<String, dynamic> newACL}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.newFilename.value] = newFilename;
    data[OperationParam.newACL.value] = newACL;

    return _sendRequest(ServiceOperation.updateFileInfo, data);
  }

  /// @returns Future<ServerResponse>
  Future<ServerResponse> _sendRequest(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                statusMessage: statusMessage)));
    ServerCall sc =
        ServerCall(ServiceName.groupFile, operation, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
