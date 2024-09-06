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

  /// <summary>
  /// Check if filename exists for provided path and name.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="folderPath">File located cloud path/folder</param>
  /// <param name="fileName">File cloud name</param>

  Future<ServerResponse> checkFilenameExists(String groupId, String folderPath,
      String fileName, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = fileName;

    return _sendRequest(ServiceOperation.checkFilenameExists, data);
  }

  /// <summary>
  /// Check if filename exists for provided path and name.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fullPathFilename">File cloud name in full path</param>

  Future<ServerResponse> checkFullpathFilenameExists(
      String groupId,
      String fullPathFilename,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fullPathFilename.value] = fullPathFilename;

    return _sendRequest(ServiceOperation.checkFullpathFilenameExists, data);
  }

  /// <summary>
  /// Copy a file.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fileId"> 	The id of the file.</param>
  /// <param name="version"> 	The target version of the file.</param>
  /// <param name="newTreeId">The id of the destination folder.</param>
  /// <param name="treeVersion">The target version of the folder tree.</param>
  /// <param name="newFilename">The optional new file name.</param>
  /// <param name="overwriteIfPresent">Whether to allow overwrite of an existing file if present.</param>

  Future<ServerResponse> copyFile(
      String groupId,
      String fileId,
      int version,
      String newTreeId,
      int treeVersion,
      String newFilename,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure) {
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

  /// <summary>
  /// Delete a file.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="version">The target version of the file.</param>
  /// <param name="filename">The file name for verification purposes.</param>

  Future<ServerResponse> deleteFile(String groupId, String fileId, int version,
      String filename, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.fileName.value] = filename;

    return _sendRequest(ServiceOperation.deleteFile, data);
  }

  /// <summary>
  /// Return CDN url for file for clients that cannot handle redirect.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>

  Future<ServerResponse> getCDNUrl(String groupId, String fileId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getCdnUrl, data);
  }

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  Future<ServerResponse> getFileInfo(String groupId, String fileId,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    return _sendRequest(ServiceOperation.getFileInfo, data);
  }

  /// <summary>
  /// Returns information on a file using path and name.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="filename">The file name.</param>
  Future<ServerResponse> getFileInfoSimple(String groupId, String folderPath,
      String filename, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = filename;

    return _sendRequest(ServiceOperation.getFileInfoSimple, data);
  }

  /// <summary>
  /// Returns a list of files.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="recurse">Whether to recurse beyond the starting folder.</param>
  Future<ServerResponse> getFileList(String groupId, String folderPath,
      bool recurse, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.recurse.value] = recurse;

    return _sendRequest(ServiceOperation.getFileList, data);
  }

  /// <summary>
  /// Move a file.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="version">The target version of the file. As an option, you can use -1 for the latest version of the file</param>
  /// <param name="newTreeId">The id of the destination folder.</param>
  /// <param name="treeVersion">The target version of the folder tree.</param>
  /// <param name="newFilename">The optional new file name.</param>
  /// <param name="overwriteIfPresent">Whether to allow overwrite of an existing file if present.</param>
  Future<ServerResponse> moveFile(
      String groupId,
      String fileId,
      int version,
      String newTreeId,
      int treeVersion,
      String newFilename,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure) {
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

  /// <summary>
  /// Move a file from user space to group space.
  /// </summary>
  /// <param name="userCloudPath">The user file folder.</param>
  /// <param name="userCloudFilename">The user file name.</param>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="groupTreeId">The id of the destination folder.</param>
  /// <param name="groupFilename">The group file name.</param>
  /// <param name="groupFileAcl">The acl of the new group file.</param>
  /// <param name="overwriteIfPresent">Whether to allow overwrite of an existing file if present.</param>
  Future<ServerResponse> moveUserToGroupFile(
      String userCloudPath,
      String userCloudFilename,
      String groupId,
      String groupTreeId,
      String groupFilename,
      Map<String, dynamic> groupFileAcl,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure) {
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

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="version">The target version of the file. As an option, you can use -1 for the latest version of the file</param>
  /// <param name="newFilename">The optional new file name.</param>
  /// <param name="newACL"> 	The optional new acl.</param>
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

  Future<ServerResponse> _sendRequest(
      ServiceOperation operation, Map<String, dynamic> data) {
    Completer<ServerResponse> completer = Completer();

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        (response) =>
            completer.complete(ServerResponse(statusCode: 200, body: response)),
        (statusCode, reasonCode, statusMessage) => completer.completeError(
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
