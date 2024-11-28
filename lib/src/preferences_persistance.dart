
abstract interface class PreferencesPersistanceBase {
  Future setString(String key, String value);
  Future<String?> getString(String key);
}
