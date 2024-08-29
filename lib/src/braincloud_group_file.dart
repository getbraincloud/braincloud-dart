import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudGroupFile {
  final BrainCloudClient _clientRef;

  BrainCloudGroupFile(this._clientRef);

  /// <summary>
  /// Check if filename exists for provided path and name.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="folderPath">File located cloud path/folder</param>
  /// <param name="fileName">File cloud name</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void checkFilenameExists(String groupId, String folderPath, String fileName,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = fileName;

    _sendRequest(ServiceOperation.checkFilenameExists, success, failure, data);
  }

  /// <summary>
  /// Check if filename exists for provided path and name.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fullPathFilename">File cloud name in full path</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void checkFullpathFilenameExists(String groupId, String fullPathFilename,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fullPathFilename.value] = fullPathFilename;

    _sendRequest(
        ServiceOperation.checkFullpathFilenameExists, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void copyFile(
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

    _sendRequest(ServiceOperation.copyFile, success, failure, data);
  }

  /// <summary>
  /// Delete a file.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="version">The target version of the file.</param>
  /// <param name="filename">The file name for verification purposes.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void deleteFile(String groupId, String fileId, int version, String filename,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.fileName.value] = filename;

    _sendRequest(ServiceOperation.deleteFile, success, failure, data);
  }

  /// <summary>
  /// Return CDN url for file for clients that cannot handle redirect.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getCDNUrl(String groupId, String fileId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    _sendRequest(ServiceOperation.getCdnUrl, success, failure, data);
  }

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getFileInfo(String groupId, String fileId, SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;

    _sendRequest(ServiceOperation.getFileInfo, success, failure, data);
  }

  /// <summary>
  /// Returns information on a file using path and name.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="filename">The file name.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getFileInfoSimple(String groupId, String folderPath, String filename,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.fileName.value] = filename;

    _sendRequest(ServiceOperation.getFileInfoSimple, success, failure, data);
  }

  /// <summary>
  /// Returns a list of files.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="recurse">Whether to recurse beyond the starting folder.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void getFileList(String groupId, String folderPath, bool recurse,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.folderPath.value] = folderPath;
    data[OperationParam.recurse.value] = recurse;

    _sendRequest(ServiceOperation.getFileList, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void moveFile(
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

    _sendRequest(ServiceOperation.moveFile, success, failure, data);
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
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void moveUserToGroupFile(
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

    _sendRequest(ServiceOperation.moveUserToGroupFile, success, failure, data);
  }

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="version">The target version of the file. As an option, you can use -1 for the latest version of the file</param>
  /// <param name="newFilename">The optional new file name.</param>
  /// <param name="newACL"> 	The optional new acl.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  void updateFileInfo(
      String groupId,
      String fileId,
      int version,
      String newFilename,
      Map<String, dynamic> newACL,
      SuccessCallback? success,
      FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.groupId.value] = groupId;
    data[OperationParam.fileId.value] = fileId;
    data[OperationParam.version.value] = version;
    data[OperationParam.newFilename.value] = newFilename;
    data[OperationParam.newACL.value] = newACL;

    _sendRequest(ServiceOperation.updateFileInfo, success, failure, data);
  }

  void _sendRequest(ServiceOperation operation, SuccessCallback? success,
      FailureCallback? failure, Map<String, dynamic> data) {
    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall sc =
        ServerCall(ServiceName.groupFile, operation, data, callback);
    _clientRef.sendRequest(sc);
  }
}
