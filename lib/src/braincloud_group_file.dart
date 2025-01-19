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

  /// Check if filename exists for provided path and name.
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param folderPath
  /// File located cloud path/folder
  ///
  /// @param fileName
  /// File cloud name
  ///
  /// returns `Future<ServerResponse>`
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

  /// Check if filename exists for provided path and name.
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param fullPathFilename
  /// File cloud name in full path
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> checkFullpathFilenameExists(
      {required String groupId, required String fullPathFilename}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fullPathFilename.value] = fullPathFilename;

    return _sendRequest(ServiceOperation.checkFullpathFilenameExists, data);
  }

  /// Copy a file.
  ///
  /// @param groupIdID of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// @param version
  /// The target version of the file.
  ///
  /// @param newTreeId
  /// The id of the destination folder.
  ///
  /// @param treeVersion
  /// The target version of the folder tree.
  ///
  /// @param newFilename
  /// The optional new file name.
  ///
  /// @param overwriteIfPresent
  /// Whether to allow overwrite of an existing file if present.
  ///
  /// returns `Future<ServerResponse>`
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
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// @param version
  /// The target version of the file.
  ///
  /// @param filename
  /// The file name for verification purposes.
  ///
  /// returns `Future<ServerResponse>`
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
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// returns `Future<ServerResponse>`
  Future<ServerResponse> getCDNUrl(
      {required String groupId, required String fileId}) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getCdnUrl, data);
  }

  /// Returns information on a file using fileId.
  ///
  /// @param groupId
  /// ID of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// returns `Future<ServerResponse>`
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
  /// returns `Future<ServerResponse>`
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
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param folderPath
  /// The folder path.
  ///
  /// @param recurse
  /// Whether to recurse beyond the starting folder.
  ///
  /// returns `Future<ServerResponse>`
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
  ///
  /// @param groupId
  /// The id of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// @param version
  /// The target version of the file. As an option, you can use -1 for the latest version of the file
  ///
  /// @param newTreeId
  /// The id of the destination folder.
  ///
  /// @param treeVersion
  /// The target version of the folder tree.
  ///
  /// @param newFilename
  /// The optional new file name.
  ///
  /// @param overwriteIfPresent
  /// Whether to allow overwrite of an existing file if present.
  ///
  /// returns `Future<ServerResponse>`
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

  /// @param groupId
  /// The id of the group.
  ///
  /// @param fileId
  /// The id of the file.
  ///
  /// @param version
  /// The target version of the file. As an option, you can use -1 for the latest version of the file
  ///
  /// @param newFilename
  /// The optional new file name.
  ///
  /// @param newACL
  /// The optional new acl.
  ///
  /// returns `Future<ServerResponse>`
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
