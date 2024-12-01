import 'package:braincloud_dart/src/data_persistance.dart';

class DataPersistance implements DataPersistanceBase {
  static final DataPersistance _instance = DataPersistance._internal();

  factory DataPersistance() {
    print("***********************************************************");
    print("***********************   WARNING  ************************");
    print("* The Peristance Class in use only persist to memory.     *");
    print("* You should pass in a Custom class to BraincloudWrapper. *");
    print("***********************************************************");
    return _instance;
  }
  DataPersistance._internal();

  Map<String, String> playerPrefs = {};

  Future setString(String key, String value) async {
    playerPrefs[key] = value;
  }

  Future<String?> getString(String key) {
    return Future.value(playerPrefs[key]);
  }
}
