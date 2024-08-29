import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BrainCloudGlobalFile {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalFile(this._clientRef);

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalFile
  /// Service Operation - GetFileInfo
  /// <param name="fileId">
  /// The Id of the file
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getFileInfo(
      String fileId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(
        ServiceName.globalFile, ServiceOperation.getFileInfo, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Returns information on a file using path and name
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalFile
  /// Service Operation - GetFileInfoSimple
  /// <param name="folderPath">
  /// The folderpath
  /// </param>
  /// <param name="filename">
  /// The filename
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getFileInfoSimple(String folderPath, String filename,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceFileName.value] = filename;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getFileInfoSimple, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Return CDN url for file for clients that cannot handle redirect.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalFile
  /// Service Operation - GetGlobalCDNUrl
  /// <param name="fileId">
  /// The Id of the file
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getGlobalCDNUrl(
      String fileId, SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalCDNUrl, data, callback);
    _clientRef.sendRequest(serverCall);
  }

  /// <summary>
  /// Returns a list of files.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalFile
  /// Service Operation - GetGlobalFileList
  /// <param name="folderPath">
  /// The folderpath
  /// </param>
  /// <param name="recurse">
  /// do we recurse?
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  void getGlobalFileList(String folderPath, bool recurse,
      SuccessCallback? success, FailureCallback? failure) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceRecurse.value] = recurse;

    ServerCallback? callback =
        BrainCloudClient.createServerCallback(success, failure);
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalFileList, data, callback);
    _clientRef.sendRequest(serverCall);
  }
}
