import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

class StoredIds {
  final String _path;

  Map<String, String> ids = {};

  StoredIds(this._path);

  Future<void> load() async {
    final file = File(_path);
    debugPrint('Reading test configs from file: $_path');
    Stream<String> lines = file
        .openRead()
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(const LineSplitter()); // Convert stream to individual lines.
    try {
      await for (var line in lines) {
        //debugPrint('$line: ${line.length} characters');

        List<String> keyVal = line.split('=');
        ids[keyVal[0]] = keyVal[1];
      }
      // debugPrint('File is now closed.');
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  String get secretKey => ids['secretKey'] ?? "";
  String get appId => ids['appId'] ?? "";
  String get version => ids['version'] ?? "";
  String get url => ids['url'] ?? "";
  String get email => ids['email'] ?? "";
  set email(val) => ids['email'] = val;
  String get password => ids['password'] ?? "";
  set password(val) => ids['password'] = val;
  String get sharedProfileId => ids['sharedProfileId'] ?? "";
  set sharedProfileId(val) => ids['sharedProfileId'] = val;
  String get customEntityType => ids['customEntityType'] ?? "";
  String get customShardedEntityType => ids['customShardedEntityType'] ?? "";
  String get customOwnedEntityType => ids['customOwnedEntityType'] ?? "";
}
