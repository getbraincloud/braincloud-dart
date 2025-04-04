import 'dart:async';

import 'ids.g.dart';


class StoredIds {
  final String path;

  Map<String, String> ids = {};

  StoredIds(this.path);

  Future<void> load() async {}

  String secretKey = allIds['secretKey'] ?? "";
  String appId = allIds['appId'] ?? "";
  String version = allIds['version'] ?? "";
  String url = allIds['serverUrl'] ?? "";
  String sharedProfileId = allIds['sharedProfileId'] ?? "";
  // set sharofileId(vl) => sharedProfileId = val ?? "";
  String customEntityType = allIds['customEntityType'] ?? "";
  String customShardedEntityType = allIds['customShardedEntityType'] ?? "";
  String customOwnedEntityType = allIds['customOwnedEntityType'] ?? "";
  String peerName = allIds['peerName'] ?? "";
  String parentLevelName = allIds['parentLevelName'] ?? "";
  String childAppId = allIds['childAppId'] ?? "";
  String childSecret = allIds['childSecret'] ?? "";
  int get WSProxyPort => int.parse(allIds['WSProxyPort'] ?? "8080");
}
