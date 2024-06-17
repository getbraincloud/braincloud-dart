import 'dart:convert';

import 'package:braincloud_dart/src/braincloud_client.dart';
import 'package:braincloud_dart/src/internal/operation_param.dart';
import 'package:braincloud_dart/src/internal/server_call.dart';
import 'package:braincloud_dart/src/internal/service_name.dart';
import 'package:braincloud_dart/src/internal/service_operation.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

class BrainCloudS3Handling {
  final BrainCloudClient _clientRef;

  BrainCloudS3Handling(this._clientRef);

  /// <summary>
  /// Sends an array of file details and returns
  /// the details of any of those files that have changed
  /// </summary>
  /// <remarks>
  /// Service Name - S3Handling
  /// Service Operation - GetUpdatedFiles
  /// </remarks>
  /// <param name="category">
  /// Category of files on server to compare against
  /// </param>
  /// <param name="fileDetailsJson">
  /// An array of file details
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getUpdatedFiles(String category, String fileDetailsJson,
      SuccessCallback? success, FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(category)) {
      data[OperationParam.S3HandlingServiceFileCategory.Value] = category;
    }

    data[OperationParam.S3HandlingServiceFileDetails.Value] =
        jsonDecode(fileDetailsJson);

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(ServiceName.S3Handling,
        ServiceOperation.getUpdatedFiles, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Retrieves the details of custom files stored on the server
  /// </summary>
  /// <remarks>
  /// Service Name - S3Handling
  /// Service Operation - GetFileList
  /// </remarks>
  /// <param name="category">
  /// Category of files to retrieve
  /// </param>
  /// <param name="success">
  /// The success callback.
  /// </param>
  /// <param name="failure">
  /// The failure callback.
  /// </param>
  /// <param name="cbObject">
  /// The user object sent to the callback.
  /// </param>
  void getFileList(String category, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};

    if (Util.isOptionalParameterValid(category)) {
      data[OperationParam.S3HandlingServiceFileCategory.Value] = category;
    }

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.S3Handling, ServiceOperation.getFileList, data, callback);
    _clientRef.sendRequest(sc);
  }

  /// <summary>
  /// Returns the CDN URL for a file
  /// </summary>
  /// <param name="fileId">ID of file</param>
  /// <param name="success">The success callback</param>
  /// <param name="failure">The failure callback</param>
  /// <param name="cbObject">The callback object</param>
  void getCDNUrl(String fileId, SuccessCallback? success,
      FailureCallback? failure, dynamic cbObject) {
    Map<String, dynamic> data = {};
    data[OperationParam.S3HandlingServiceFileId.Value] = fileId;

    ServerCallback? callback = BrainCloudClient.createServerCallback(
        success, failure,
        cbObject: cbObject);
    ServerCall sc = ServerCall(
        ServiceName.S3Handling, ServiceOperation.getCdnUrl, data, callback);
    _clientRef.sendRequest(sc);
  }
}
