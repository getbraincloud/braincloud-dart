// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:async';

import '/src/braincloud_client.dart';
import '/src/internal/operation_param.dart';
import '/src/internal/server_call.dart';
import '/src/internal/service_name.dart';
import '/src/internal/service_operation.dart';
import '/src/server_callback.dart';
import '/src/server_response.dart';

class BrainCloudGroupFile {
  final BrainCloudClient _clientRef;

  BrainCloudGroupFile(this._clientRef);

  /// Check if filename exists for provided path and name
  /// Service Name GroupFile
  /// Service Operation  CheckFilenameExists
  ///
  /// @param groupId ID of the group.
  /// @param folderPath The path of the file
  /// @param filename The filename of the file
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> checkFilenameExists(
      {required String groupId,
      required String folderPath,
      required String filename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = filename;

    return _sendRequest(ServiceOperation.checkFilenameExists, data);
  }

  /// Check if filename exists for provided full path name
  /// Service Name GroupFile
  /// Service Operation CheckFullpathFilenameExists
  ///
  /// @param groupId ID of the group.
  /// @param fullPathFilename The full path of the file
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> checkFullpathFilenameExists(
      {required String groupId, required String fullPathFilename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fullPathFilename.value] = fullPathFilename;

    return _sendRequest(ServiceOperation.checkFullpathFilenameExists, data);
  }

  /// Copy a file.
  /// Service Name GroupFile
  /// Service Operation CopyFile
  ///
  /// @param groupId ID of the group
  /// @param fileId ID of the file
  /// @param version Target version of the file
  /// @param newTreeId ID of the destination folder
  /// @param treeVersion Target version of the folder tree
  /// @param newFilename Optional new file name
  /// @param overwriteIfPresent Whether to allow overwrite of an existing file if present
  /// @return Future<ServerResponse>
  ///
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
  /// Service Name GroupFile
  /// Service Operation DeleteFile
  ///
  /// @param groupId the groupId
  /// @param fileId the fileId
  /// @param version the version
  /// @param newFilename the newFilename
  /// @return Future<ServerResponse>
  ///
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
  /// Service Name GroupFile
  /// Service Operation GetCdnUrl
  ///
  /// @param groupId the groupId
  /// @param fileId the fileId
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getCDNUrl(
      {required String groupId, required String fileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getCdnUrl, data);
  }

  /// Returns information on a file using fileId.
  /// Service Name GroupFile
  /// Service Operation GetFileInfo
  ///
  /// @param groupId the groupId
  /// @param fileId the fileId
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> getFileInfo(
      {required String groupId, required String fileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getFileInfo, data);
  }

  /// Returns information on a file using path and name.
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param folderPath
  /// The folder path.
  ///
  /// @param filename
  /// The file name.
  //
  /// Returns information on a file using path and name.
  /// Service Name GroupFile
  /// Service Operation GetFileInfoSimple
  ///
  /// @param groupId the groupId
  /// @param folderPath the folderPath
  /// @param fileName the fileName
  /// @return Future<ServerResponse>
  ///
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
  /// Service Name GroupFile
  /// Service Operation GetFileList
  ///
  /// @param groupId the groupId
  /// @param folderPath the folderPath
  /// @param recurse true to recurse
  /// @return Future<ServerResponse>
  ///
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
  /// Service Name GroupFile
  /// Service Operation MoveFile
  ///
  /// @param groupId the groupId
  /// @param fileId the fileId
  /// @param version the version
  /// @param newTreeId the newTreeId
  /// @param newFilename the newFilename
  /// @return Future<ServerResponse>
  ///
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
  ///
  /// @param userCloudPath
  /// The user file folder.
  ///
  /// @param userCloudFilename
  /// The user file name.
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param groupTreeId
  /// The id of the destination folder.
  ///
  /// @param groupFilename
  /// The group file name.
  ///
  /// @param groupFileAcl
  /// The acl of the new group file.
  ///
  /// @param overwriteIfPresent
  /// Whether to allow overwrite of an existing file if present.
  ///
  /// returns `Future<ServerResponse>`
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

  /// Rename or edit permissions of an uploaded file. Does not change the contents of the file.
  /// Service Name GroupFile
  /// Service Operation UpdateFileInfo
  ///
  /// @param groupId ID of the group
  /// @param fileId ID of the file
  /// @param version Target version of the file
  /// @param newFilename Optional new file name
  /// @param newACL Optional new acl
  /// @return Future<ServerResponse>
  ///
  Future<ServerResponse> updateFileInfo(
      {required String groupId,
      required String fileId,
      required int version,
      required String newFilename,
      required Map<String, dynamic> newAcl}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.newFilename.value] = newFilename;
    data[OperationParam.newACL.value] = newAcl;

    return _sendRequest(ServiceOperation.updateFileInfo, data);
  }

  /// returns `Future<ServerResponse>`
  Future<ServerResponse> _sendRequest(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) => completer.complete(ServerResponse.fromJson(response)),
        (statusCode, reasonCode, statusMessage) => completer.complete(
            ServerResponse(
                statusCode: statusCode,
                reasonCode: reasonCode,
                error: statusMessage)));
    ServerCall sc =
        ServerCall(ServiceName.groupFile, operation, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
