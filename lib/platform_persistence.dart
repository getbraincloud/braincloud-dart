import 'package:braincloud_dart/src/data_persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class DataPersistence implements DataPersistenceBase {
  static final DataPersistence _instance = DataPersistence._internal();

  factory DataPersistence() {
    return _instance;    
  }

  DataPersistence._internal();

  SharedPreferencesAsync _playerPrefs = SharedPreferencesAsync();

  bool _isServicesBindingAvailable() {
    try {
      // ignore: unnecessary_null_comparison
      return ServicesBinding.instance != null;
    } catch (e) {
      return false;
    }
  }

  Future setString(String key, String value) async {
    if (_isServicesBindingAvailable())
      return _playerPrefs.setString(key, value);
    throw ("ServiceBinding not yet available, no data will be persisted, consider delaying initialization or providing your own PreferencesPersistence");
  }

  Future<String?> getString(String key) {
    if (_isServicesBindingAvailable()) return _playerPrefs.getString(key);
    throw ("ServiceBinding not yet available, no data can be retrived, consider delaying initialization or providing your own PreferencesPersistence");
  }
}
