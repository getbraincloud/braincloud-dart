// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:convert';

import '../app_profile.dart';
import 'client_tuning.dart';

/// App settings written by `dart run braincloud:setup` into `bc_config.json`.
///
/// Build with `--dart-define-from-file=bc_config.json` and [BrainCloudAppConfig.fromEnvironment]
/// picks them up; `BrainCloudWrapper.initFromConfig()` does that for you.
class BrainCloudAppConfig {
  static const defaultServerUrl = 'https://api.braincloudservers.com/dispatcherv2';

  final String serverUrl;
  final String version;

  /// The app id, as written by setup.
  final String clientProfile;

  /// The app's settings, as written by setup.
  final String clientTuning;

  /// Child apps, as written by setup.
  final List<dynamic> childApps;

  const BrainCloudAppConfig({
    this.serverUrl = defaultServerUrl,
    this.version = '1.0.0',
    this.clientProfile = '',
    this.clientTuning = '',
    this.childApps = const [],
  });

  /// The values baked in by `--dart-define-from-file=bc_config.json`.
  factory BrainCloudAppConfig.fromEnvironment() => BrainCloudAppConfig.fromJson(const {
        'serverUrl': String.fromEnvironment('serverUrl'),
        'version': String.fromEnvironment('version'),
        'clientProfile': String.fromEnvironment('clientProfile'),
        'clientTuning': String.fromEnvironment('clientTuning'),
        'childApps': String.fromEnvironment('childApps'),
      });

  /// From the contents of a `bc_config.json` (e.g. loaded as an asset).
  factory BrainCloudAppConfig.fromJson(Map<String, dynamic> json) {
    String str(String key) => json[key] is Map ? jsonEncode(json[key]) : (json[key] ?? '').toString();
    final children = json['childApps'];
    return BrainCloudAppConfig(
      serverUrl: str('serverUrl').isEmpty ? defaultServerUrl : str('serverUrl'),
      version: str('version').isEmpty ? '1.0.0' : str('version'),
      clientProfile: str('clientProfile'),
      clientTuning: str('clientTuning'),
      childApps: children is List
          ? children
          : (children is String && children.isNotEmpty ? jsonDecode(children) as List<dynamic> : const []),
    );
  }

  bool get isPresent => clientProfile.isNotEmpty && clientTuning.isNotEmpty;

  /// The app id, plus a signing profile for the app and each of its children.
  Future<({String appId, Map<String, AppProfile> profiles})> resolve() async {
    if (!isPresent) {
      throw StateError('No brainCloud config found. Run `dart run braincloud:setup`, then build with '
          '--dart-define-from-file=bc_config.json');
    }
    final id = await _appId(clientProfile);
    final profiles = {id: await tuningProfile(clientTuning)};
    for (final pair in childApps) {
      profiles[await _appId((pair as List)[0] as Object)] = await tuningProfile(pair[1] as Object);
    }
    return (appId: id, profiles: profiles);
  }

  static Future<String> _appId(Object tuning) async {
    final value = await resolveClientTuning(tuning);
    if (value == null || value.isEmpty) throw StateError('brainCloud config could not be read.');
    return value;
  }
}
