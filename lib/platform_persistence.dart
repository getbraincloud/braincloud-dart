import 'package:braincloud_dart/src/data_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataPersistence implements DataPersistenceBase {
  static final DataPersistence _instance = DataPersistence._internal();

  factory DataPersistence() {
    return _instance;    
  }

  DataPersistence._internal();

  SharedPreferencesAsync _playerPrefs = SharedPreferencesAsync();

  Future setString(String key, String value) async {
    return _playerPrefs.setString(key, value);
  }

  Future<String?> getString(String key) {
    return _playerPrefs.getString(key);
  }
}
