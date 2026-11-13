// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Where bc_config.json and its tuning file live in a project, and reading/writing/gitignoring them.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path/path.dart' as p;

import '../config/braincloud_config.dart';
import '../config/client_tuning.dart';
import '../config/tuning_native.dart';
import 'builder_client.dart';
import 'setup_native.dart';
import 'tuning_source.dart';

const configName = 'bc_config.json';
const defaultServerUrl = BrainCloudAppConfig.defaultServerUrl;
const defaultAppVersion = '1.0.0';
const unreadable = "Saved values can't be read. Select the app again.";

/// [appValue] is a String when new, or the stored bundle (a Map) when read back.
typedef ChildApp = ({String appId, Object appValue});
typedef FullConfig = ({String appId, Object appValue, String serverUrl, String appVersion, List<ChildApp> children});

String defaultOutput(String projectDir) => p.join(projectDir, configName);

/// The tuning file: lib/ of the package holding the config, so the app can import it.
String tuningPath(String file) {
  final start = p.dirname(p.absolute(file));
  var dir = start;
  while (true) {
    if (File(p.join(dir, 'pubspec.yaml')).existsSync()) return p.join(dir, 'lib', tuningFileName);
    final parent = p.dirname(dir);
    if (parent == dir || Directory(p.join(dir, '.git')).existsSync()) break;
    dir = parent;
  }
  return p.join(start, 'lib', tuningFileName);
}

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

String _decodeId(Object tuning) {
  final flat = flattenTuning(tuningBundle(tuning));
  final value = resolveTuningSync(flat.shares, flat.seeds, flat.slotLen);
  if (value == null) throw const FormatException('undecodable app id');
  return value;
}

/// Ids and value bundles, without the tuning value. Null for no config or an older format.
FullConfig? _stored(String file) {
  final json = _json(file);
  if (json == null) return null;
  final config = BrainCloudAppConfig.fromJson(json);
  if (!config.isPresent) return null;
  try {
    final main = tuningBundle(config.clientTuning);
    final children = [
      for (final pair in config.childApps)
        (appId: _decodeId((pair as List)[0] as Object), appValue: tuningBundle(pair[1] as Object))
    ];
    if (tuningCheck(main) == null || children.any((c) => tuningCheck(c.appValue) == null)) return null;
    return (
      appId: _decodeId(config.clientProfile),
      appValue: main,
      serverUrl: config.serverUrl,
      appVersion: config.version,
      children: children,
    );
  } catch (_) {
    return null;
  }
}

/// `appId`, `serverUrl`, `appVersion`, `childIds` of an existing config, or null. Reads without the tuning value.
({String appId, String serverUrl, String appVersion, List<String> childIds})? read(String file) {
  final stored = _stored(file);
  if (stored == null) return null;
  return (
    appId: stored.appId,
    serverUrl: stored.serverUrl,
    appVersion: stored.appVersion,
    childIds: [for (final c in stored.children) c.appId],
  );
}

bool _reads(Object bundle, List<int> value) {
  final b = tuningBundle(bundle);
  final check = tuningCheck(b);
  if (check == null) return false;
  final flat = flattenTuning(b);
  return checkTuning(flat.shares, flat.seeds, flat.slotLen, value, check);
}

bool _matches(FullConfig stored, List<int> value) =>
    _reads(stored.appValue, value) && stored.children.every((c) => _reads(c.appValue, value));

/// The config with app ids decoded and values left encoded, for rewriting it. Null if there's no
/// readable config; throws if it's there but the tuning file is missing or doesn't match.
FullConfig? load(String file) {
  final stored = _stored(file);
  if (stored == null) return null;
  final value = readTuning(tuningPath(file));
  try {
    if (value == null || !_matches(stored, value)) throw BuilderError(unreadable);
    return stored;
  } finally {
    value?.fillRange(0, value.length, 0);
  }
}

/// `present` / `matches` for the panel.
({bool present, bool matches}) tuningState(String file) {
  final value = readTuning(tuningPath(file));
  final stored = _stored(file);
  final out = (present: value != null, matches: value != null && stored != null && _matches(stored, value));
  value?.fillRange(0, value.length, 0);
  return out;
}

/// The project's tuning value, or null.
Uint8List? projectTuning(String file) => readTuning(tuningPath(file));

Map<String, dynamic> _encodeId(String value) {
  final built = buildTuning(value);
  return nestTuning(built.shares, built.seeds, built.slotLen);
}

Map<String, dynamic> _encodeValue(Object value, List<int> tuning) {
  if (value is! String) return tuningBundle(value);
  final built = buildTuning(value, tuning: tuning);
  return nestTuning(built.shares, built.seeds, built.slotLen, check: built.check);
}

/// Writes the config, keeping any other keys (dart-defines) already in the file.
/// Reuses the project's tuning value (one value covers every env's config); [tuning] replaces it,
/// otherwise a new one is minted. Writes the tuning file first and puts it back if the config fails.
/// Stored (Map) values only carry over under the value they were made with.
void write(String file,
    {required String appId,
    required Object appValue,
    String? serverUrl,
    String? appVersion,
    List<ChildApp> children = const [],
    List<int>? tuning}) {
  final tPath = tuningPath(file);
  final existing = readTuning(tPath);
  final value = Uint8List.fromList(tuning ?? existing ?? newTuning());
  final replace = existing == null || !sameTuning(existing, value);
  try {
    if (replace && (appValue is! String || children.any((c) => c.appValue is! String))) {
      throw BuilderError(unreadable);
    }
    final json = _json(file) ?? <String, dynamic>{};
    json
      ..remove('secretKey')
      ..remove('appId')
      ..['serverUrl'] = (serverUrl == null || serverUrl.isEmpty) ? defaultServerUrl : serverUrl
      ..['clientProfile'] = jsonEncode(_encodeId(appId))
      ..['clientTuning'] = jsonEncode(_encodeValue(appValue, value))
      ..['version'] = (appVersion == null || appVersion.isEmpty) ? defaultAppVersion : appVersion;
    if (children.isEmpty) {
      json.remove('childApps');
    } else {
      json['childApps'] = jsonEncode([
        for (final c in children) [_encodeId(c.appId), _encodeValue(c.appValue, value)]
      ]);
    }

    final tFile = File(tPath);
    final previous = replace && tFile.existsSync() ? tFile.readAsBytesSync() : null;
    if (replace) {
      tFile.parent.createSync(recursive: true);
      tFile.writeAsStringSync(tuningSource(value));
    }
    try {
      Directory(p.dirname(file)).createSync(recursive: true);
      File(file).writeAsStringSync('${const JsonEncoder.withIndent('    ').convert(json)}\n');
    } catch (_) {
      if (replace && previous != null) {
        tFile.writeAsBytesSync(previous);
      } else if (replace) {
        tFile.deleteSync();
      }
      rethrow;
    }
  } finally {
    value.fillRange(0, value.length, 0);
    existing?.fillRange(0, existing.length, 0);
  }
  ensureIgnored(file);
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

const _ignoreHeader = '# brainCloud app config (generated)';

bool _ignoredIn(List<String> lines, String root, String file) {
  final rel = _relative(root, file);
  final name = p.basename(file);
  return lines.any((l) => l == rel || l == '/$rel' || l == name || l == '**/$name');
}

bool isIgnored(String file) {
  final root = _repoRoot(file);
  if (root == null) return false;
  final gitignore = File(p.join(root, '.gitignore'));
  if (!gitignore.existsSync()) return false;
  return _ignoredIn(gitignore.readAsLinesSync().map((l) => l.trim()).toList(), root, file);
}

/// Adds the config and its tuning file to the repo's .gitignore, under one header.
void ensureIgnored(String file) {
  final root = _repoRoot(file);
  if (root == null) return;
  final gitignore = File(p.join(root, '.gitignore'));
  final existing = gitignore.existsSync() ? gitignore.readAsStringSync() : '';
  final lines = existing.split(RegExp(r'\r?\n')).map((l) => l.trim()).toList();
  final missing = [
    for (final f in [file, tuningPath(file)])
      if (!_ignoredIn(lines, root, f)) '/${_relative(root, f)}'
  ];
  if (missing.isEmpty) return;
  final header = existing.split('\n').indexWhere((l) => l.trim() == _ignoreHeader);
  if (header >= 0) {
    final all = existing.split('\n')..insertAll(header + 1, missing);
    gitignore.writeAsStringSync(all.join('\n'));
    return;
  }
  final prefix = existing.isNotEmpty && !existing.endsWith('\n') ? '\n' : '';
  gitignore.writeAsStringSync('$prefix$_ignoreHeader\n${missing.join('\n')}\n', mode: FileMode.append);
}
