import 'package:braincloud/braincloud.dart';

/// The test app's signing profiles plus the fixed values the suites expect on it.
abstract class TestValues {
  Map<String, AppProfile> profiles = {};
  String appId = '';
  String childAppId = '';
  String version = '';
  String url = '';

  String sharedProfileId = '';
  final String customEntityType = 'DartTestCustomEntity';
  final String customOwnedEntityType = 'DartTestOwnedCustomEntity';
  final String customShardedEntityType = 'athletes';
  final String peerName = 'peerapp';
  final String parentLevelName = 'Master';
  final int WSProxyPort = 9898;

  AppProfile get profile => profiles[appId]!;
  AppProfile get childProfile => profiles[childAppId]!;

  Future<void> load();

  Future<void> useConfig(BrainCloudAppConfig config) async {
    final resolved = await config.resolve();
    appId = resolved.appId;
    childAppId = resolved.profiles.keys.firstWhere((id) => id != appId, orElse: () => '');
    version = config.version;
    url = config.serverUrl;
    profiles = resolved.profiles;
  }
}
