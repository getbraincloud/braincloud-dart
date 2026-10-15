// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:convert';

import 'client_tuning.dart';

/// App settings written by `dart run braincloud:setup` into `bc_config.json`.
///
/// Build with `--dart-define-from-file=bc_config.json` and [BrainCloudAppConfig.fromEnvironment]
/// picks them up; `BrainCloudWrapper.initFromConfig()` does that for you.
class BrainCloudAppConfig {
  static const defaultServerUrl = 'https://api.braincloudservers.com/dispatcherv2';

  final String serverUrl;
  final String version;

  /// Encoded app id (a JSON string). Empty when [appId] is used instead.
  final String clientProfile;

  /// Encoded app secret (a JSON string). Empty when [secretKey] is used instead.
  final String clientTuning;

  /// Plain app id, for configs written by hand.
  final String appId;

  /// Plain app secret, for configs written by hand.
  final String secretKey;

  /// Child apps as `[encoded id, encoded secret]` bundle pairs.
  final List<dynamic> childApps;

  const BrainCloudAppConfig({
    this.serverUrl = defaultServerUrl,
    this.version = '1.0.0',
    this.clientProfile = '',
    this.clientTuning = '',
    this.appId = '',
    this.secretKey = '',
    this.childApps = const [],
  });

  /// The values baked in by `--dart-define-from-file=bc_config.json`.
  factory BrainCloudAppConfig.fromEnvironment() => BrainCloudAppConfig.fromJson(const {
        'serverUrl': String.fromEnvironment('serverUrl'),
        'version': String.fromEnvironment('version'),
        'clientProfile': String.fromEnvironment('clientProfile'),
        'clientTuning': String.fromEnvironment('clientTuning'),
        'appId': String.fromEnvironment('appId'),
        'secretKey': String.fromEnvironment('secretKey'),
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
      appId: str('appId'),
      secretKey: str('secretKey'),
      childApps: children is List
          ? children
          : (children is String && children.isNotEmpty ? jsonDecode(children) as List<dynamic> : const []),
    );
  }

  bool get isPresent =>
      (clientProfile.isNotEmpty || appId.isNotEmpty) && (clientTuning.isNotEmpty || secretKey.isNotEmpty);

  /// The app id, plus app id -> secret for the app and its children.
  Future<({String appId, Map<String, String> secrets})> resolve() async {
    if (!isPresent) {
      throw StateError('No brainCloud config found. Run `dart run braincloud:setup`, then build with '
          '--dart-define-from-file=bc_config.json');
    }
    final id = clientProfile.isNotEmpty ? await _decode(clientProfile) : appId;
    final secrets = {id: clientTuning.isNotEmpty ? await _decode(clientTuning) : secretKey};
    for (final pair in childApps) {
      secrets[await _decode((pair as List)[0] as Object)] = await _decode(pair[1] as Object);
    }
    return (appId: id, secrets: secrets);
  }

  static Future<String> _decode(Object tuning) async {
    final value = await resolveClientTuning(tuning);
    if (value == null || value.isEmpty) throw StateError('brainCloud config could not be decoded.');
    return value;
  }
}
