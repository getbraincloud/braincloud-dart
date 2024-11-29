import 'dart:async';
import 'dart:convert';
import 'dart:io';


class StoredIds {
  final String _path;

  Map<String, String> ids = {};

  StoredIds(this._path);

  Future<void> load() async {
    final file = File(_path);
    print('Reading test configs from file: $_path');
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
      print('Error: $e');
    }
  }

  String get secretKey => ids['secretKey'] ?? "";
  String get appId => ids['appId'] ?? "";
  String get version => ids['version'] ?? "";
  String get url => ids['serverUrl'] ?? "";
  String get sharedProfileId => ids['sharedProfileId'] ?? "";
  set sharedProfileId(val) => ids['sharedProfileId'] = val;
  String get customEntityType => ids['customEntityType'] ?? "";
  String get customShardedEntityType => ids['customShardedEntityType'] ?? "";
  String get customOwnedEntityType => ids['customOwnedEntityType'] ?? "";
  String get peerName => ids['peerName'] ?? "";
  String get parentLevelName => ids['parentLevelName'] ?? "";
  String get childAppId => ids['childAppId'] ?? "";
  String get childSecret => ids['childSecret'] ?? "";
}
