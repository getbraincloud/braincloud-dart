import 'package:braincloud_dart/src/Entity/bc_entity.dart';
import 'package:braincloud_dart/src/Entity/enums/enitity_state.dart';
import 'package:braincloud_dart/src/server_callback.dart';

class BCUserEntity extends BCEntity {
  BCUserEntity(super.braincloud);

  void cbCreateSuccess(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"];
    updateTimeStamps(data);

    entityId = data["entityId"];

    state = EntityState.Ready;

    queueUpdates(); // important - kicks off any queued updates that happened before we retrieved an id from the server
  }

  void cbCreateFailure(int statusCode, int reasonCode, String statusMessage) {}

  void cbUpdateSuccess(Map<String, dynamic> json) {
    Map<String, dynamic> data = json["data"];
    updateTimeStamps(data);
  }

  void cbUpdateFailure(int statusCode, int reasonCode, String statusMessage) {}

  void cbDeleteSuccess(Map<String, dynamic> json) {
    state = EntityState.Deleted;
  }

  void cbDeleteFailure(int statusCode, int reasonCode, String statusMessage) {}

  @override
  void createEntity(SuccessCallback? success, FailureCallback? failure) {
    String jsonData = toJsonString();
    String? jsonAcl = acl?.toJsonString();
    bcEntityService.createEntity(entityType!, jsonData, jsonAcl, (json) {
      cbCreateSuccess(json);
      success?.call(json);
    }, (statusCode, reasonCode, statusMessage) {
      cbCreateFailure(statusCode, reasonCode, statusMessage);
      failure?.call(statusCode, reasonCode, statusMessage);
    }, this);
  }

  @override
  void updateEntity(SuccessCallback? success, FailureCallback? failure) {
    String jsonData = toJsonString();
    String? jsonAcl = acl?.toJsonString();
    bcEntityService.updateEntity(
        entityId!, entityType!, jsonData, jsonAcl, version, (jsonResponse) {
      cbUpdateSuccess(jsonResponse);
      success?.call(jsonResponse);
    }, (statusCode, reasonCode, statusMessage) {
      cbUpdateFailure(statusCode, reasonCode, statusMessage);
      failure?.call(statusCode, reasonCode, statusMessage);
    }, this);
  }

  @override
  void updateSharedEntity(String targetProfileId, SuccessCallback? success,
      FailureCallback? failure) {
    String jsonData = toJsonString();
    bcEntityService.updateSharedEntity(
        entityId!, targetProfileId, entityType!, jsonData, version,
        (jsonResponse) {
      cbUpdateSuccess(jsonResponse);
      success?.call(jsonResponse);
    }, (statusCode, reasonCode, statusMessage) {
      cbUpdateFailure(statusCode, reasonCode, statusMessage);
      failure?.call(statusCode, reasonCode, statusMessage);
    }, this);
  }

  @override
  void deleteEntity(SuccessCallback? success, FailureCallback? failure) {
    bcEntityService.deleteEntity(entityId!, version, (json) {
      cbDeleteSuccess(json);
      success?.call(json);
    }, (statusCode, reasonCode, statusMessage) {
      cbDeleteFailure(statusCode, reasonCode, statusMessage);
      failure?.call(statusCode, reasonCode, statusMessage);
    }, this);
  }
}
