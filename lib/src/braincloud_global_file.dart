import 'dart:async';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_response.dart';

class BrainCloudGlobalFile {
  final BrainCloudClient _clientRef;

  BrainCloudGlobalFile(this._clientRef);

  /// Returns information on a file using fileId.
  ///
  /// Service Name - GlobalFile
  /// Service Operation - GetFileInfo
  ///
  /// @param fileId
  /// The Id of the file
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getFileInfo({required String fileId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    ServerCall serverCall = ServerCall(
        ServiceName.globalFile, ServiceOperation.getFileInfo, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Returns information on a file using path and name
  ///
  /// Service Name - GlobalFile
  /// Service Operation - GetFileInfoSimple
  ///
  /// @param folderPath
  /// The folderpath
  ///
  /// @param filename
  /// The filename
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getFileInfoSimple(
      {required String folderPath, required String filename}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceFileName.value] = filename;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getFileInfoSimple, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Return CDN url for file for clients that cannot handle redirect.
  ///
  /// Service Name - GlobalFile
  /// Service Operation - GetGlobalCDNUrl
  ///
  /// @param fileId
  /// The Id of the file
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getGlobalCDNUrl({required String fileId}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalCDNUrl, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }

  /// Returns a list of files.
  ///
  /// Service Name - GlobalFile
  /// Service Operation - GetGlobalFileList
  ///
  /// @param folderPath
  /// The folderpath
  ///
  /// @param recurse
  /// do we recurse?
  ///
  /// returns Future<ServerResponse>
  Future<ServerResponse> getGlobalFileList(
      {required String folderPath, required bool recurse}) async {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceRecurse.value] = recurse;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject);
    }, (statusCode, reasonCode, statusMessage) {
      completer.complete(ServerResponse(
          statusCode: statusCode,
          reasonCode: reasonCode,
          error: statusMessage));
    });

    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalFileList, data, callback);
    _clientRef.sendRequest(serverCall);

    return completer.future;
  }
}
