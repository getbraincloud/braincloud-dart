import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:braincloud_dart/src/Common/acl.dart';
import 'package:braincloud_dart/src/Entity/enums/enitity_state.dart';
import 'package:braincloud_dart/src/braincloud_entity.dart';
import 'package:braincloud_dart/src/server_callback.dart';
import 'package:braincloud_dart/src/util.dart';

abstract class BCEntity {
  String? entityId;
  String? entityType;
  ACL? acl;
  int version = -1; // skip version checking for now...

  Map<String, dynamic> data = {};

  // one way to support delta updates...
  //IDictionary<String, dynamic> m_cachedServerData = {};

  EntityState state = EntityState.New;

  // members used if we send a create to the server but in the meantime the client has updated the entity
  bool updateWhenCreated = false;
  SuccessCallback? updateWhenCreatedSuccessCb;
  FailureCallback? updateWhenCreatedFailureCb;

  // properties managed by the server
  DateTime? createdAt;
  DateTime? updatedAt;

  late BrainCloudEntity bcEntityService;

  //JsonData m_cachedServerObject;

  void createEntity(SuccessCallback? success, FailureCallback? failure);
  void updateEntity(SuccessCallback? success, FailureCallback? failure);
  void updateSharedEntity(String targetProfileId, SuccessCallback? success,
      FailureCallback? failure);
  void deleteEntity(SuccessCallback? success, FailureCallback? failure);

  BCEntity(BrainCloudEntity braincloud) {
    bcEntityService = braincloud;
  }

  /// <summary>
  /// Store the Entity dynamic to the braincloud server. This will result in one of the following operations:
  ///
  /// 1) CreateEntity
  /// 2) UpdateEntity
  /// 3) DeleteEntity
  ///
  /// Certain caveats must be observed:
  /// a) Store operation will be ignored if an entity has been deleted or is in the process of being deleted.
  /// b) TODO: remove this caveat!: Store operation will queue an update if an entity is in the process of being created on the server.
  /// If the entity fails to be created, the update failure callback will not be run.
  ///
  /// </param>
  /// <param name="success">
  /// A callback to run when store operation is completed successfully.
  /// </param>
  /// <param name="failure">
  /// A callback to run when store operation fails.
  /// </param>
  void storeAsync(SuccessCallback? success, FailureCallback? failure) {
    if (state == EntityState.Deleting || state == EntityState.Deleted) {
      return;
    }

    if (state == EntityState.Creating) {
      // a store async call came in while we are waiting for the server to create the dynamic... queue an update
      updateWhenCreated = true;
      updateWhenCreatedSuccessCb = success;
      updateWhenCreatedFailureCb = failure;
      return;
    }

    if (state == EntityState.New) {
      createEntity(success, failure);

      state = EntityState.Creating;
    } else {
      updateEntity(success, failure);
      // we don't currently need a state to say an update is in progress... and if we add this state we
      // need to keep track of how many updates are queued in order to set the state back to ready when *all*
      // updates have completed. So just removing the state for now... an update queued should not have any impact
      // on whether the user can transition to the delete state.
      //m_state = EntityState.Updating;
    }
  }

  /// <summary>
  /// Store the Entity dynamic to the braincloud server. This will result in one of the following operations:
  ///
  /// 1) CreateEntity
  /// 2) UpdateSharedEntity
  /// 3) DeleteEntity
  ///
  /// Certain caveats must be observed:
  /// a) Store operation will be ignored if an entity has been deleted or is in the process of being deleted.
  /// b) TODO: remove this caveat!: Store operation will queue an update if an entity is in the process of being created on the server.
  /// If the entity fails to be created, the update failure callback will not be run.
  ///
  /// </param>
  /// <param name="success">
  /// A callback to run when store operation is completed successfully.
  /// </param>
  /// <param name="failure">
  /// A callback to run when store operation fails.
  /// </param>
  void storeAsyncShared(String targetProfileId, SuccessCallback? success,
      FailureCallback? failure) {
    if (state == EntityState.Deleting || state == EntityState.Deleted) {
      return;
    }

    if (state == EntityState.Creating) {
      // a store async call came in while we are waiting for the server to create the dynamic... queue an update
      updateWhenCreated = true;
      updateWhenCreatedSuccessCb = success;
      updateWhenCreatedFailureCb = failure;
      return;
    }

    if (state == EntityState.New) {
      createEntity(success, failure);

      state = EntityState.Creating;
    } else {
      updateSharedEntity(targetProfileId, success, failure);
      // we don't currently need a state to say an update is in progress... and if we add this state we
      // need to keep track of how many updates are queued in order to set the state back to ready when *all*
      // updates have completed. So just removing the state for now... an update queued should not have any impact
      // on whether the user can transition to the delete state.
      //m_state = EntityState.Updating;
    }
  }

  /// <summary>
  /// Deletes an entity on the server. If an entity has already been deleted this method will do nothing.
  /// </param>
  /// <param name="success">
  /// A callback to run when delete operation is completed successfully.
  /// </param>
  /// <param name="failure">
  /// A callback to run when delete operation fails.
  /// </param>
  void deleteAsync(SuccessCallback? success, FailureCallback? failure) {
    if (state == EntityState.New) {
      // preston: caveat - if the dynamic was created asynchronously, and we're still waiting to hear back from the server,
      // the dynamic won't actually get deleted on the server. We can handle this later in the storeAsync/create callback
      return;
    }

    if (state == EntityState.Deleting || state == EntityState.Deleted) {
      // if it's already deleted or being deleted, don't delete again
      return;
    }

    deleteEntity(success, failure);
    state = EntityState.Deleting;
  }

  bool contains(String key) {
    return data.containsKey(key);
  }

  void remove(String key) {
    if (data.containsKey(key)) {
      data.remove(key);
    }
  }

  void updateTimeStamps(Map<String, dynamic> json) {
    try {
      createdAt = Util.bcTimeToDateTime(json["createdAt"]);
      updatedAt = Util.bcTimeToDateTime(json["updatedAt"]);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void queueUpdates() {
    if (updateWhenCreated) {
      storeAsync(updateWhenCreatedSuccessCb, updateWhenCreatedFailureCb);
      updateWhenCreated = false;
      updateWhenCreatedSuccessCb = null;
      updateWhenCreatedFailureCb = null;
    }
  }

  String toJsonString() {
    return jsonEncode(data);
  }

  // void ReadFromJson(String json) {
  //   dynamic jsonObj = jsonDecode(json);
  //   ReadFromJson(jsonObj);
  // }

  void readFromJson(dynamic jsonObj) {
    state = EntityState.Ready;
    entityType = jsonObj["entityType"];
    entityId = jsonObj["entityId"];
    acl = ACL.createFromJson(jsonObj["acl"]);
    updateTimeStamps(jsonObj);
    data = jsonToDictionary(jsonObj["data"]);
  }

  @override
  String toString() {
    return toJsonString();
  }

  static Map<String, dynamic> jsonToDictionary(dynamic jsonObj) {
    Map<String, dynamic> dict = {};

    for (var child in jsonObj) {
      var dictEntry = child;
      var childValue = dictEntry.Value;
      var childKey = dictEntry.Key;

      if (childValue != null) {
        dict[childKey] = jsonToDictionary(childValue);
      } else if (childValue != null) {
        dict[childKey] = jsonToList(childValue);
      } else {
        dict[childKey] = childValue;
      }
    }

    return dict;
  }

  static List<dynamic> jsonToList(dynamic jsonObj) {
    List<dynamic> list = [];
    var arr = jsonObj;
    if (arr != null) {
      dynamic child;
      for (int i = 0; i < arr.Length; ++i) {
        child = arr.GetValue(i);
        if (child is Map) {
          list.add(jsonToDictionary(child));
        } else if (child is List) {
          list.add(jsonToList(child));
        } else {
          list.add(child);
        }
      }
    }

    return list;
  }
}
