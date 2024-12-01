
abstract interface class DataPersistanceBase {
  Future setString(String key, String value);
  Future<String?> getString(String key);
}
