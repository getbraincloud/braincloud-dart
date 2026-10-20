// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Where bc_config.json lives in a project, and reading/writing/gitignoring it.
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import '../config/braincloud_config.dart';
import '../config/client_tuning.dart';
import '../config/tuning_native.dart';
import 'setup_native.dart';

const configName = 'bc_config.json';
const defaultServerUrl = BrainCloudAppConfig.defaultServerUrl;
const defaultAppVersion = '1.0.0';

/// [appValue] is plaintext (a String) when new, or the stored encoded bundle (a Map) when
/// read back: setup never decodes it, only passes it through.
typedef ChildApp = ({String appId, Object appValue});
typedef FullConfig = ({String appId, Object appValue, String serverUrl, String appVersion, List<ChildApp> children});

String defaultOutput(String projectDir) => p.join(projectDir, configName);

Map<String, dynamic>? _json(String file) {
  final f = File(file);
  if (!f.existsSync()) return null;
  try {
    final json = jsonDecode(f.readAsStringSync());
    return json is Map<String, dynamic> ? json : null;
  } catch (_) {
    return null;
  }
}

/// `appId`, `serverUrl`, `appVersion`, `childIds` of an existing config, or null. Never the app values.
({String appId, String serverUrl, String appVersion, List<String> childIds})? read(String file) {
  final full = load(file);
  if (full == null) return null;
  return (
    appId: full.appId,
    serverUrl: full.serverUrl,
    appVersion: full.appVersion,
    childIds: [for (final c in full.children) c.appId],
  );
}

Map<String, dynamic> _bundle(Object tuning) =>
    tuning is String ? jsonDecode(tuning) as Map<String, dynamic> : tuning as Map<String, dynamic>;

String _decodeId(Object tuning) {
  final flat = flattenTuning(_bundle(tuning));
  final value = resolveTuningSync(flat.shares, flat.pads, flat.slotLen);
  if (value == null) throw const FormatException('undecodable app id');
  return value;
}

/// The config with app ids decoded and values left encoded, for rewriting it.
FullConfig? load(String file) {
  final json = _json(file);
  if (json == null) return null;
  final config = BrainCloudAppConfig.fromJson(json);
  if (!config.isPresent) return null;
  try {
    return (
      appId: _decodeId(config.clientProfile),
      appValue: _bundle(config.clientTuning),
      serverUrl: config.serverUrl,
      appVersion: config.version,
      children: [
        for (final pair in config.childApps)
          (appId: _decodeId((pair as List)[0] as Object), appValue: _bundle(pair[1] as Object))
      ],
    );
  } catch (_) {
    return null;
  }
}

Map<String, dynamic> _encode(String value) {
  final built = buildTuning(value);
  return nestTuning(built.shares, built.pads, built.slotLen);
}

Map<String, dynamic> _encodeValue(Object value) => value is String ? _encode(value) : _bundle(value);

/// Writes the config, keeping any other keys (dart-defines) already in the file.
void write(String file,
    {required String appId,
    required Object appValue,
    String? serverUrl,
    String? appVersion,
    List<ChildApp> children = const []}) {
  final json = _json(file) ?? <String, dynamic>{};
  json
    ..remove('secretKey')
    ..remove('appId')
    ..['serverUrl'] = (serverUrl == null || serverUrl.isEmpty) ? defaultServerUrl : serverUrl
    ..['clientProfile'] = jsonEncode(_encode(appId))
    ..['clientTuning'] = jsonEncode(_encodeValue(appValue))
    ..['version'] = (appVersion == null || appVersion.isEmpty) ? defaultAppVersion : appVersion;
  if (children.isEmpty) {
    json.remove('childApps');
  } else {
    json['childApps'] = jsonEncode([
      for (final c in children) [_encode(c.appId), _encodeValue(c.appValue)]
    ]);
  }
  Directory(p.dirname(file)).createSync(recursive: true);
  File(file).writeAsStringSync('${const JsonEncoder.withIndent('    ').convert(json)}\n');
}

/// Re-encodes the existing config with a new server/version. False if there's no usable config.
bool rewrite(String file, String serverUrl, String appVersion) {
  final current = load(file);
  if (current == null) return false;
  write(file,
      appId: current.appId,
      appValue: current.appValue,
      serverUrl: serverUrl,
      appVersion: appVersion,
      children: current.children);
  return true;
}

String? _repoRoot(String file) {
  var dir = p.dirname(p.absolute(file));
  while (true) {
    if (FileSystemEntity.isDirectorySync(p.join(dir, '.git')) || File(p.join(dir, '.git')).existsSync()) return dir;
    final parent = p.dirname(dir);
    if (parent == dir) return null;
    dir = parent;
  }
}

String _relative(String root, String file) => p.relative(p.absolute(file), from: root).split(p.separator).join('/');

bool isIgnored(String file) {
  final root = _repoRoot(file);
  if (root == null) return false;
  final gitignore = File(p.join(root, '.gitignore'));
  if (!gitignore.existsSync()) return false;
  final rel = _relative(root, file);
  final name = p.basename(file);
  return gitignore
      .readAsLinesSync()
      .map((l) => l.trim())
      .any((l) => l == rel || l == '/$rel' || l == name || l == '**/$name');
}

void ensureIgnored(String file) {
  final root = _repoRoot(file);
  if (root == null || isIgnored(file)) return;
  final gitignore = File(p.join(root, '.gitignore'));
  final existing = gitignore.existsSync() ? gitignore.readAsStringSync() : '';
  final prefix = existing.isNotEmpty && !existing.endsWith('\n') ? '\n' : '';
  gitignore.writeAsStringSync('$prefix# brainCloud app config (generated)\n/${_relative(root, file)}\n',
      mode: FileMode.append);
}
