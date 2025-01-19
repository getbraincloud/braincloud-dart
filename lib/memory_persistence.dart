import 'package:braincloud_dart/data_persistence.dart';

class DataPersistence implements DataPersistenceBase {
  static final DataPersistence _instance = DataPersistence._internal();

  factory DataPersistence() {
    print("***********************************************************");
    print("***********************   WARNING  ************************");
    print("* The Peristance Class in use only persist to memory.     *");
    print("* You should pass in a Custom class to BraincloudWrapper. *");
    print("***********************************************************");
    return _instance;
  }
  DataPersistence._internal();

  Map<String, String> playerPrefs = {};

  @override
  Future setString(String key, String value) async {
    playerPrefs[key] = value;
  }

  @override
  Future<String?> getString(String key) {
    return Future.value(playerPrefs[key]);
  }
}
