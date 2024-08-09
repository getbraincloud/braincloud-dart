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
  /// <param name="cbObject">The callback object</param>
  void checkFilenameExists(String groupId, String folderPath, String fileName,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FolderPath.Value] = folderPath;
    data[OperationParam.FileName.Value] = fileName;

    _sendRequest(
        ServiceOperation.checkFilenameExists, success, failure, cbObject, data);
  }

  /// <summary>
  /// Check if filename exists for provided path and name.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fullPathFilename">File cloud name in full path</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void checkFullpathFilenameExists(String groupId, String fullPathFilename,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FullPathFilename.Value] = fullPathFilename;

    _sendRequest(ServiceOperation.checkFullpathFilenameExists, success, failure,
        cbObject, data);
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
  /// <param name="cbObject">The callback object</param>
  void copyFile(
      String groupId,
      String fileId,
      int version,
      String newTreeId,
      int treeVersion,
      String newFilename,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;
    data[OperationParam.Version.Value] = version;
    data[OperationParam.NewTreeId.Value] = newTreeId;
    data[OperationParam.TreeVersion.Value] = treeVersion;
    data[OperationParam.NewFilename.Value] = newFilename;
    data[OperationParam.OverwriteIfPresent.Value] = overwriteIfPresent;

    _sendRequest(ServiceOperation.copyFile, success, failure, cbObject, data);
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
  /// <param name="cbObject">The callback object</param>
  void deleteFile(String groupId, String fileId, int version, String filename,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;
    data[OperationParam.Version.Value] = version;
    data[OperationParam.FileName.Value] = filename;

    _sendRequest(ServiceOperation.deleteFile, success, failure, cbObject, data);
  }

  /// <summary>
  /// Return CDN url for file for clients that cannot handle redirect.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getCDNUrl(String groupId, String fileId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;

    _sendRequest(ServiceOperation.getCdnUrl, success, failure, cbObject, data);
  }

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <param name="groupId">ID of the group.</param>
  /// <param name="fileId">The id of the file.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getFileInfo(String groupId, String fileId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;

    _sendRequest(
        ServiceOperation.getFileInfo, success, failure, cbObject, data);
  }

  /// <summary>
  /// Returns information on a file using path and name.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="filename">The file name.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getFileInfoSimple(String groupId, String folderPath, String filename,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FolderPath.Value] = folderPath;
    data[OperationParam.FileName.Value] = filename;

    _sendRequest(
        ServiceOperation.getFileInfoSimple, success, failure, cbObject, data);
  }

  /// <summary>
  /// Returns a list of files.
  /// </summary>
  /// <param name="groupId">The id of the group.</param>
  /// <param name="folderPath">The folder path.</param>
  /// <param name="recurse">Whether to recurse beyond the starting folder.</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getFileList(String groupId, String folderPath, bool recurse,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FolderPath.Value] = folderPath;
    data[OperationParam.Recurse.Value] = recurse;

    _sendRequest(
        ServiceOperation.getFileList, success, failure, cbObject, data);
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
  /// <param name="cbObject">The callback object</param>
  void moveFile(
      String groupId,
      String fileId,
      int version,
      String newTreeId,
      int treeVersion,
      String newFilename,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;
    data[OperationParam.Version.Value] = version;
    data[OperationParam.NewTreeId.Value] = newTreeId;
    data[OperationParam.TreeVersion.Value] = treeVersion;
    data[OperationParam.NewFilename.Value] = newFilename;
    data[OperationParam.OverwriteIfPresent.Value] = overwriteIfPresent;

    _sendRequest(ServiceOperation.moveFile, success, failure, cbObject, data);
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
  /// <param name="cbObject">The callback object</param>
  void moveUserToGroupFile(
      String userCloudPath,
      String userCloudFilename,
      String groupId,
      String groupTreeId,
      String groupFilename,
      Map<String, dynamic> groupFileAcl,
      bool overwriteIfPresent,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.UserCloudPath.Value] = userCloudPath;
    data[OperationParam.UserCloudFilename.Value] = userCloudFilename;
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.GroupTreeId.Value] = groupTreeId;
    data[OperationParam.GroupFilename.Value] = groupFilename;
    data[OperationParam.GroupFileACL.Value] = groupFileAcl;
    data[OperationParam.OverwriteIfPresent.Value] = overwriteIfPresent;

    _sendRequest(
        ServiceOperation.moveUserToGroupFile, success, failure, cbObject, data);
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
  /// <param name="cbObject">The callback object</param>
  void updateFileInfo(
      String groupId,
      String fileId,
      int version,
      String newFilename,
      Map<String, dynamic> newACL,
      SuccessCallback? success,
      FailureCallback? failure,
      dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.GroupId.Value] = groupId;
    data[OperationParam.FileId.Value] = fileId;
    data[OperationParam.Version.Value] = version;
    data[OperationParam.NewFilename.Value] = newFilename;
    data[OperationParam.NewACL.Value] = newACL;

    _sendRequest(
        ServiceOperation.updateFileInfo, success, failure, cbObject, data);
  }

  void _sendRequest(ServiceOperation operation, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject, Map<String, dynamic> data) {
    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc =
        ServerCall(ServiceName.groupFile, operation, data, callback);
    _clientRef.sendRequest(sc);
  }
}
