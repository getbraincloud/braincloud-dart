import 'package:braincloud_dart/src/preferences_persistance.dart';

class MemoryPersistance implements PreferencesPersistanceBase {
  static final MemoryPersistance _instance = MemoryPersistance._internal();

  factory MemoryPersistance() {
    return _instance;
  }
  MemoryPersistance._internal();

  Map<String, String> playerPrefs = {};

  Future setString(String key, String value) async {
    playerPrefs[key] = value;
  }

  Future<String?> getString(String key) {
    return Future.value(playerPrefs[key]);
  }
}
