
abstract interface class DataPersistenceBase {
  Future setString(String key, String value);
  Future<String?> getString(String key);
}
