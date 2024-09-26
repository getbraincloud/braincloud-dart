import 'dart:async';
import 'dart:typed_data';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_response.dart';
import 'package:braincloud_dart/src/util.dart';
import 'package:uuid/uuid.dart';

class BrainCloudFile {
  final BrainCloudClient _clientRef;
  Map<String, Uint8List> fileStorage = {};

  BrainCloudFile(this._clientRef);

  /// <summary>
  /// Prepares a user file upload from memory, allowing the user to bypass
  /// the need to read or write on disk before uploading. On success the file will begin uploading
  /// to the brainCloud server.To be informed of success/failure of the upload
  /// register an IFileUploadCallback with the BrainCloudClient class.
  /// </summary>
  /// <param name="cloudPath">The desired cloud path of the file</param>
  /// <param name="cloudFilename">The desired cloud fileName of the file</param>
  /// <param name="shareable">True if the file is shareable</param>
  /// <param name="replaceIfExists">Whether to replace file if it exists</param>
  /// <param name="fileData">The file memory data in byte[]</param>
  Future<ServerResponse> uploadFileFromMemory(
      String cloudPath,
      String cloudFilename,
      bool shareable,
      bool replaceIfExists,
      Uint8List fileData) async {
    if (fileData.isEmpty) {
      _clientRef.log("File data is empty");
      Future.error(Exception('File data is empty'));
    }
    String guid = const Uuid().v4();
    _clientRef.fileService.fileStorage[guid] = fileData;

    Map<String, dynamic> data = {};
    data[OperationParam.uploadLocalPath.value] = guid;
    data[OperationParam.uploadCloudFilename.value] = cloudFilename;
    data[OperationParam.uploadCloudPath.value] = cloudPath;
    data[OperationParam.uploadShareable.value] = shareable;
    data[OperationParam.uploadReplaceIfExists.value] = replaceIfExists;
    data[OperationParam.uploadFileSize.value] = fileData.length;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.file, ServiceOperation.prepareUserUpload, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Method cancels an upload. If an IFileUploadCallback has been registered with the BrainCloudClient class,
  /// the fileUploadFailed callback method will be called once the upload has been canceled.
  /// NOTE: The upload will still continue in the background on versions of Unity before 5.3
  /// and on Unity mobile platforms.
  /// </summary>
  /// <param name="uploadId">Upload ID of the file to cancel</param>
  void cancelUpload(String uploadId) {
    _clientRef.comms?.cancelUpload(uploadId);
  }

  /// <summary>
  /// Returns the progress of the given upload from 0.0 to 1.0 or -1 if upload not found.
  /// NOTE: This will always return 1 on Unity mobile platforms.
  /// </summary>
  /// <param name="uploadId">The id of the upload</param>
  double? getUploadProgress(String uploadId) {
    return _clientRef.comms?.getUploadProgress(uploadId);
  }

  /// <summary>
  /// Returns the number of bytes uploaded or -1 if upload not found.
  /// NOTE: This will always return the total bytes to transfer on Unity mobile platforms.
  /// </summary>
  /// <param name="uploadId">The id of the upload</param>
  int? getUploadBytesTransferred(String uploadId) {
    return _clientRef.comms?.getUploadBytesTransferred(uploadId);
  }

  /// <summary>
  /// Returns the total number of bytes that will be uploaded or -1 if upload not found.
  /// </summary>
  /// <param name="uploadId">The id of the upload</param>
  int? getUploadTotalBytesToTransfer(String uploadId) {
    return _clientRef.comms?.getUploadTotalBytesToTransfer(uploadId);
  }

  /// <summary>
  /// List user files from the given cloud path
  /// </summary>
  /// <param name="cloudPath">File path</param>
  /// <param name="recurse">Whether to recurse down the path</param>
  Future<ServerResponse> listUserFiles(String cloudPath, bool? recurse) async {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(cloudPath)) {
      data[OperationParam.uploadPath.value] = cloudPath;
    }

    if (recurse != null) {
      data[OperationParam.uploadRecurse.value] = recurse;
    }

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.file, ServiceOperation.listUserFiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Deletes a single user file.
  /// </summary>
  /// <param name="cloudPath">File path</param>
  /// <param name="cloudFileName"></param>
  Future<ServerResponse> deleteUserFile(
      String cloudPath, String cloudFileName) async {
    Map<String, dynamic> data = {};

    data[OperationParam.uploadCloudPath.value] = cloudPath;
    data[OperationParam.uploadCloudFilename.value] = cloudFileName;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.file, ServiceOperation.deleteUserFile, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Delete multiple user files
  /// </summary>
  /// <param name="cloudPath">File path</param>
  /// <param name="recurse">Whether to recurse down the path</param>
  Future<ServerResponse> deleteUserFiles(String cloudPath, bool recurse) async {
    Map<String, dynamic> data = {};

    data[OperationParam.uploadCloudPath.value] = cloudPath;
    data[OperationParam.uploadRecurse.value] = recurse;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.file, ServiceOperation.deleteUserFiles, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }

  /// <summary>
  /// Returns the CDN URL for a file dynamic.
  /// </summary>
  /// <param name="cloudPath">File path</param>
  /// <param name="cloudFilename">Name of file</param>
  Future<ServerResponse> getCDNUrl(
      String cloudPath, String cloudFilename) async {
    Map<String, dynamic> data = {};

    data[OperationParam.uploadCloudPath.value] = cloudPath;
    data[OperationParam.uploadCloudFilename.value] = cloudFilename;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          statusMessage: statusMessage));
    });

    ServerCall sc = ServerCall(
        ServiceName.file, ServiceOperation.getCdnUrl, data, callback);
    _clientRef.sendRequest(sc);

    return completer.future;
  }
}
