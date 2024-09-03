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

  /// <summary>
  /// Returns information on a file using fileId.
  /// </summary>
  /// <remarks>
  /// Service Name - GlobalFile
  /// Service Operation - GetFileInfo
  /// <param name="fileId">
  /// The Id of the file
  /// </param>
  Future<ServerResponse>  getFileInfo(
      String fileId) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject); 
    },(statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
        statusCode: statusCode,
        reasonCode: reasonCode,
        statusMessage: statusMessage));
    });
    
    ServerCall serverCall = ServerCall(
        ServiceName.globalFile, ServiceOperation.getFileInfo, data, callback);
    _clientRef.sendRequest(serverCall);
    
    return completer.future;
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
  Future<ServerResponse>  getFileInfoSimple(String folderPath, String filename) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceFileName.value] = filename;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject); 
    },(statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
        statusCode: statusCode,
        reasonCode: reasonCode,
        statusMessage: statusMessage));
    });
    
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getFileInfoSimple, data, callback);
    _clientRef.sendRequest(serverCall);
    
    return completer.future;
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
  Future<ServerResponse>  getGlobalCDNUrl(String fileId) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFileId.value] = fileId;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject); 
    },(statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
        statusCode: statusCode,
        reasonCode: reasonCode,
        statusMessage: statusMessage));
    });
    
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalCDNUrl, data, callback);
    _clientRef.sendRequest(serverCall);
    
    return completer.future;
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
  Future<ServerResponse>  getGlobalFileList(String folderPath, bool recurse) {
    Map<String, dynamic> data = {};
    data[OperationParam.globalFileServiceFolderPath.value] = folderPath;
    data[OperationParam.globalFileServiceRecurse.value] = recurse;

    final Completer<ServerResponse> completer = Completer();
    var callback = BrainCloudClient.createServerCallback((response) {
      ServerResponse responseObject = ServerResponse.fromJson(response);
      completer.complete(responseObject); 
    },(statusCode, reasonCode, statusMessage) {
      completer.completeError(ServerResponse(
        statusCode: statusCode,
        reasonCode: reasonCode,
        statusMessage: statusMessage));
    });
    
    ServerCall serverCall = ServerCall(ServiceName.globalFile,
        ServiceOperation.getGlobalFileList, data, callback);
    _clientRef.sendRequest(serverCall);
    
    return completer.future;
  }
}
