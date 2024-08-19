import 'dart:convert';

import 'package:braincloud_dart/src/Entity/bc_user_entity.dart';
import 'package:braincloud_dart/src/braincloud_entity.dart';

class BCEntityFactory {
  BrainCloudEntity entityService;
  final Map<String, dynamic> _registeredClasses = {};

  BCEntityFactory(this.entityService);

  // BCUserEntity CreateUserEntityFromType(String type) {

  // }

  // T NewEntity<T>(string entityType) where T : BCEntity
  // {
  //     T e = (T)CreateRegisteredEntityClass(entityType);

  //     //we're never creating the instance before as suspected.
  //     if (e == null)
  //     {
  //         //added so new entity would actually create an instance THIS WORKS! Creates the exact kind of instance we needed!
  //         e = (T)Activator.CreateInstance(typeof(T), new Object[] { entityService });
  //     }
  //     e.BrainCloudEntityService = entityService;
  //     e.EntityType = entityType;
  //     return e;
  // }

  BCUserEntity? newUserEntity(String entityType) {
    BCUserEntity? e = createRegisteredEntityClass(entityType);
    e ??= BCUserEntity(entityService);
    e.entityType = entityType;
    return e;
  }

  List<BCUserEntity> newUserEntitiesFromGetList(String json) {
    Map<String, dynamic> jsonObj = jsonDecode(json);
    try {
      return newUserEntitiesFromJsonString(json, jsonObj["data"]["entityList"]);
    } catch (e) {
      return [];
    }
  }

  List<BCUserEntity> newUserEntitiesFromReadPlayerState(String json) {
    Map<String, dynamic> jsonObj = jsonDecode(json);
    try {
      return newUserEntitiesFromJsonString(json, jsonObj["data"]["entities"]);
    } catch (e) {
      return [];
    }
  }

  List<BCUserEntity> newUserEntitiesFromStartMatch(String json) {
    Map<String, dynamic> jsonObj = jsonDecode(json);
    try {
      return newUserEntitiesFromJsonString(
          json, jsonObj["data"]["initialSharedData"]["entities"]);
    } catch (e) {
      return [];
    }
  }

  List<BCUserEntity> newUserEntitiesFromDataResponse(String json) {
    Map<String, dynamic> jsonObj = jsonDecode(json);
    try {
      return newUserEntitiesFromJsonString(
          json, jsonObj["data"]["response"]["entities"]);
    } catch (e) {
      return [];
    }
  }

  // void RegisterEntityClass<T>(String entityType)
  // {
  //     Type type = typeof(T);
  //     Type[] constructorParams = new Type[] { };

  //     ConstructorInfo ci = type.GetConstructor(constructorParams);
  //     if (ci != null)
  //     {
  //         _registeredClasses[entityType] = ci;
  //     }
  // }

  BCUserEntity? createRegisteredEntityClass(String entityType) {
    if (_registeredClasses.containsKey(entityType)) {
      var ci = _registeredClasses[entityType];
      return ci.Invoke(null);
    }
    return null;
  }

  BCUserEntity? newUserFromDictionary(Map<String, dynamic>? inDict) {
    BCUserEntity? toReturn;
    if (inDict != null) {
      try {
        toReturn = newUserEntity(inDict["entityType"]);
        toReturn?.readFromJson(inDict);
      } catch (e) {
        /* do nadda */
      }
    }

    return toReturn;
  }

  // the list of entitiies
  List<BCUserEntity> newUserEntitiesFromJsonString(
      String json, List entitiesJson) {
    List<BCUserEntity> entities = [];
    Map<String, dynamic>? child;
    for (int i = 0; i < entitiesJson.length; ++i) {
      try {
        child = entitiesJson[i];
        BCUserEntity? entity = newUserFromDictionary(child);
        if (entity != null) {
          entities.add(entity);
        }
      } catch (e) {
        /* do nadda */
      }
    }
    return entities;
  }
}
