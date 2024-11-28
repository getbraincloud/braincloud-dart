import 'package:braincloud_dart/src/preferences_persistance.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class PlatformPersistance implements PreferencesPersistanceBase {
  static final PlatformPersistance _instance = PlatformPersistance._internal();

  factory PlatformPersistance() {
    return _instance;
  }

  PlatformPersistance._internal();

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
    throw ("ServiceBinding not yet available, no data will be persisted, consider delaying initialization or providing your own PreferencesPersistance");
    // _local_playerPrefs[key] = value;
    // return Future.value();
  }

  Future<String?> getString(String key) {
    if (_isServicesBindingAvailable()) return _playerPrefs.getString(key);
    throw ("ServiceBinding not yet available, no data can be retrived, consider delaying initialization or providing your own PreferencesPersistance");
    // return Future.value(_local_playerPrefs[key]);
  }
}
