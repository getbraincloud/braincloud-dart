// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Login + team/app selection behind the setup panel, same flow as braincloud-js-secure's session.js.
// The app credential is fetched only to write the config; it never reaches the panel.
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;

import 'builder_client.dart';
import 'project_config.dart' as project;

const clientId = 'dart_plugin';
const defaultCallbackPort = 23456;
const scope = 'openid email builder_api team_info app_info team_read app_read app_create utility_read';
const pluginVersion = '6.1.0';
// Picks this SDK's template team on the server (templateGameTeams).
const templateEngine = 'dart';
// Encodes the dev-machine session at rest, so tokens aren't plain text in the file.
final _sessionKey = _hex('3c8e1a7f62d94b05e7a3f1c8920d6b4e15f7a28c9d03e6b1748fa25c0e9d7b36');

Uint8List _hex(String s) =>
    Uint8List.fromList([for (var i = 0; i < s.length; i += 2) int.parse(s.substring(i, i + 2), radix: 16)]);

final _random = Random.secure();
Uint8List _randomBytes(int n) => Uint8List.fromList(List.generate(n, (_) => _random.nextInt(256)));

String base64Url(List<int> bytes) => base64UrlEncode(bytes).replaceAll('=', '');

String challenge(String verifier) => base64Url(sha256.convert(ascii.encode(verifier)).bytes);

String defaultSessionFile() {
  final home = Platform.environment['HOME'] ?? Platform.environment['USERPROFILE'] ?? '.';
  return p.join(home, '.braincloud', 'dart-setup.json');
}

class SetupSession {
  final String pinnedServer;
  final String output;
  final String? sessionFile;
  final int callbackPort;
  BuilderClient Function(String serverUrl) clientFactory;

  String state = 'logged_out';
  String serverUrl = project.defaultServerUrl;
  String email = '';
  String accessToken = '';
  String builderKey = '';
  String teamId = '';
  List<Map<String, String>> teams = [];
  List<Map<String, Object>> apps = [];
  final Map<String, String> appNames = {};
  // Child app ids picked per parent, so reselecting a parent brings them back.
  final Map<String, List<String>> childApps = {};
  List<Map<String, String>> templates = [];
  String templatesError = '';
  String error = '';
  String status = '';
  String _verifier = '';
  String _oauthState = '';
  bool loginFromIde = false;

  SetupSession(String output,
      {String? sessionFile,
      this.callbackPort = defaultCallbackPort,
      String serverUrl = '',
      BuilderClient Function(String)? clientFactory})
      : output = p.absolute(output),
        sessionFile = sessionFile ?? defaultSessionFile(),
        pinnedServer = serverUrl,
        clientFactory = clientFactory ?? ((url) => BuilderClient(url)) {
    _load();
    final info = project.read(this.output);
    if (info != null) this.serverUrl = info.serverUrl;
    if (pinnedServer.isNotEmpty) this.serverUrl = pinnedServer;
  }

  String redirectUri() => 'http://localhost:$callbackPort/oauth/callback';

  BuilderClient client([String? url]) => clientFactory(url ?? serverUrl);

  // ── Login ──────────────────────────────────────────────────────────

  String beginLogin(String? url, bool fromIde) {
    if (url != null && url.trim().isNotEmpty) serverUrl = url.trim();
    loginFromIde = fromIde;
    _verifier = base64Url(_randomBytes(32));
    _oauthState = base64Url(_randomBytes(16));
    error = '';
    status = '';
    state = 'logging_in';
    _save();
    return client().authorizeUrl(clientId, redirectUri(), scope, _oauthState, challenge(_verifier));
  }

  void cancelLogin() {
    _verifier = '';
    _oauthState = '';
    error = '';
    state = accessToken.isNotEmpty && builderKey.isNotEmpty ? 'logged_in' : 'logged_out';
  }

  Future<void> completeLogin(String? code, String? receivedState, String? oauthError) async {
    if (state != 'logging_in') return;
    if (oauthError != null && oauthError.isNotEmpty) return _fail('Login was not completed ($oauthError).');
    if (_oauthState.isEmpty || _oauthState != receivedState) {
      return _fail('OAuth state mismatch; aborting login for safety.');
    }
    try {
      final c = client();
      accessToken = await c.exchangeCode(clientId, redirectUri(), code ?? '', _verifier);
      _verifier = '';
      _oauthState = '';
      final info = await c.userInfo(accessToken);
      email = info.email;
      teams = info.teams;
      teamId = info.currentTeamId.isNotEmpty ? info.currentTeamId : (teams.isNotEmpty ? teams.first['id']! : '');
      if (teamId.isEmpty) return _fail('No brainCloud team available for this account.');
      builderKey = await c.tempApiKey(accessToken, teamId);
      state = 'logged_in';
      error = '';
      _save();
      await refreshApps();
    } catch (e) {
      _fail('$e');
    }
  }

  void logout() {
    accessToken = '';
    builderKey = '';
    teamId = '';
    teams = [];
    apps = [];
    error = '';
    status = '';
    state = 'logged_out';
    _save();
  }

  bool isLoggedIn() => state == 'logged_in';

  void reportError(String message) => error = message;

  /// Picks up a login/logout made from another project's panel (they share the session file).
  void reloadIfIdle() {
    if (state == 'logging_in') return;
    final before = state;
    final beforeTeam = teamId;
    _load();
    if (accessToken.isEmpty || builderKey.isEmpty) {
      state = 'logged_out';
      teams = [];
      apps = [];
    } else if (before != 'logged_in' || beforeTeam != teamId) {
      teams = [];
      apps = [];
    }
  }

  void _fail(String message) {
    accessToken = '';
    builderKey = '';
    teamId = '';
    teams = [];
    apps = [];
    _verifier = '';
    _oauthState = '';
    error = message.isEmpty ? 'Login failed.' : message;
    state = 'logged_out';
    _save();
  }

  // ── Team / app ─────────────────────────────────────────────────────

  Future<void> refreshTeams() async {
    if (!isLoggedIn()) return;
    try {
      final info = await client().userInfo(accessToken);
      teams = info.teams;
      if (info.email.isNotEmpty) email = info.email;
      if (!teams.any((t) => t['id'] == teamId) && teams.isNotEmpty) {
        teamId = teams.first['id']!;
        builderKey = await client().tempApiKey(accessToken, teamId);
        _save();
      }
      error = '';
      await refreshApps();
    } catch (e) {
      _fail('$e');
    }
  }

  Future<void> selectTeam(String? id) async {
    if (!isLoggedIn() || id == null || id.isEmpty || id == teamId) return;
    teamId = id;
    apps = [];
    try {
      // Temp Builder keys are minted per team.
      builderKey = await client().tempApiKey(accessToken, id);
      _save();
      await refreshApps();
    } catch (e) {
      _fail('$e');
    }
  }

  Future<void> refreshApps() async {
    if (!isLoggedIn()) return;
    try {
      apps = await client().apps(email, builderKey, teamId);
      for (final a in apps) {
        appNames[a['id'] as String] = a['name'] as String;
      }
      error = '';
      _save();
    } catch (e) {
      _fail('$e');
    }
  }

  Future<void> selectApp(String? appId) async {
    if (!isLoggedIn() || appId == null || appId.isEmpty) return;
    try {
      final appValue = await _credential(appId);
      final children = <project.ChildApp>[];
      for (final childId in childApps[appId] ?? const <String>[]) {
        if (_isChildOf(childId, appId)) children.add((appId: childId, appValue: await _credential(childId)));
      }
      final current = project.read(output);
      project.write(output,
          appId: appId,
          appValue: appValue,
          children: children,
          serverUrl: serverUrl,
          appVersion: current?.appVersion ?? project.defaultAppVersion);
      project.ensureIgnored(output);
      error = '';
      status = 'Saved ${_name(appId)} to ${p.basename(output)}.';
      _save();
    } catch (e) {
      error = '$e';
    }
  }

  // ── Child apps ─────────────────────────────────────────────────────

  /// [manualValue]: for a child this account can't see; its profile isn't fetched again later.
  Future<void> addChild(String childId, String manualValue) async {
    final id = childId.trim();
    final current = project.load(output);
    if (id.isEmpty) return;
    if (current == null) {
      error = 'Select an app above first.';
      return;
    }
    if (id == current.appId || current.children.any((c) => c.appId == id)) {
      error = '${_name(id)} is already in ${p.basename(output)}.';
      return;
    }
    try {
      final appValue = manualValue.isNotEmpty ? manualValue : await _credential(id);
      final children = [...current.children, (appId: id, appValue: appValue)];
      _writeChildren(current, children);
      error = '';
      status = 'Added child ${_name(id)}.';
      _save();
    } catch (e) {
      error = '$e';
    }
  }

  void removeChild(String childId) {
    final current = project.load(output);
    if (current == null) return;
    _writeChildren(current, current.children.where((c) => c.appId != childId).toList());
    error = '';
    status = 'Removed child ${_name(childId)}.';
    _save();
  }

  void _writeChildren(project.FullConfig current, List<project.ChildApp> children) {
    project.write(output,
        appId: current.appId,
        appValue: current.appValue,
        serverUrl: current.serverUrl,
        appVersion: current.appVersion,
        children: children);
    // Manual children aren't remembered; their profile can't be fetched again.
    if (apps.isNotEmpty) {
      childApps[current.appId] =
          children.map((c) => c.appId).where((id) => _isChildOf(id, current.appId)).toList();
    }
  }

  bool _isChildOf(String childId, String parentId) =>
      apps.any((a) => a['id'] == childId && a['parentAppId'] == parentId);

  Future<String> _credential(String appId) => client().appCredential(email, builderKey, teamId, appId);

  Future<void> refreshTemplates() async {
    if (!isLoggedIn()) return;
    try {
      try {
        templates = await client().templateApps(email, builderKey, templateEngine);
        stderr.writeln('Templates for "$templateEngine" on $serverUrl: ${templates.map((t) => t['name']).join(', ')}');
      } catch (e) {
        // Server without a template team for this engine: use the default list.
        stderr.writeln('No "$templateEngine" templates on $serverUrl, using the default list: $e');
        templates = await client().templateApps(email, builderKey, '');
      }
      templatesError = templates.isNotEmpty ? '' : 'No templates are available yet.';
    } catch (_) {
      templates = [];
      templatesError = 'No templates are available yet.';
    }
  }

  Future<void> createApp(String? appName, List<String> platforms, String templateAppId) async {
    final name = (appName ?? '').trim();
    if (name.isEmpty) {
      error = 'App name is required.';
      return;
    }
    try {
      final appId = await client().createApp(email, builderKey, teamId, name, platforms, templateAppId);
      await refreshApps();
      if (appId.isNotEmpty) {
        appNames[appId] = name;
        await selectApp(appId);
      }
    } catch (e) {
      error = '$e';
    }
  }

  // ── Credentials section Save ───────────────────────────────────────

  void saveSettings(String? url, String? appVersion, String? manualAppId, String? manualValue) {
    final serverUrl = (url ?? '').trim().isEmpty ? project.defaultServerUrl : url!.trim();
    final version = (appVersion ?? '').trim().isEmpty ? project.defaultAppVersion : appVersion!.trim();
    try {
      final appId = (manualAppId ?? '').trim();
      if (appId.isNotEmpty && (manualValue ?? '').isNotEmpty) {
        // Same app: keep its children. A different app starts without any.
        final current = project.load(output);
        final children = current != null && current.appId == appId ? current.children : <project.ChildApp>[];
        project.write(output,
            appId: appId, appValue: manualValue!, children: children, serverUrl: serverUrl, appVersion: version);
      } else if (!project.rewrite(output, serverUrl, version)) {
        error = 'Select an app above, or enter an App ID and App Secret.';
        return;
      }
      project.ensureIgnored(output);
      this.serverUrl = serverUrl;
      error = '';
      status = 'Saved.';
      _save();
    } catch (e) {
      error = '$e';
    }
  }

  // ── Headless refresh ───────────────────────────────────────────────

  /// Rewrites the config from the saved session, or CI env vars, keeping its version/server.
  Future<void> refreshConfig(Map<String, String> env) async {
    final current = project.read(output);
    String pick(String key, String? fallback, String last) =>
        (env[key] ?? '').isNotEmpty ? env[key]! : ((fallback ?? '').isNotEmpty ? fallback! : last);
    final appId = pick('BRAINCLOUD_APP_ID', current?.appId, '');
    final url = pick('BRAINCLOUD_SERVER_URL', current?.serverUrl, serverUrl);
    final version = pick('BRAINCLOUD_APP_VERSION', current?.appVersion, project.defaultAppVersion);
    if (appId.isEmpty) throw BuilderError('No app configured yet. Run setup first, or set BRAINCLOUD_APP_ID.');
    final c = client(url);
    String appValue;
    final ciEmail = env['BRAINCLOUD_BUILDER_EMAIL'] ?? '';
    final ciKey = env['BRAINCLOUD_BUILDER_API_KEY'] ?? '';
    final ciTeam = env['BRAINCLOUD_TEAM_ID'] ?? '';
    if (ciEmail.isNotEmpty && ciKey.isNotEmpty && ciTeam.isNotEmpty) {
      appValue = await c.appCredential(ciEmail, ciKey, ciTeam, appId);
    } else {
      if (builderKey.isEmpty || teamId.isEmpty) throw BuilderError('Not logged in. Run setup first.');
      try {
        appValue = await c.appCredential(email, builderKey, teamId, appId);
      } catch (e) {
        if (accessToken.isEmpty) rethrow;
        // Temp Builder keys expire; re-mint once from the OAuth session.
        builderKey = await c.tempApiKey(accessToken, teamId);
        _save();
        appValue = await c.appCredential(email, builderKey, teamId, appId);
      }
    }
    // Children keep their encoded profiles; manual ones can't be fetched again.
    final loaded = project.load(output);
    final children = loaded != null && loaded.appId == appId ? loaded.children : <project.ChildApp>[];
    project.write(output, appId: appId, appValue: appValue, children: children, serverUrl: url, appVersion: version);
  }

  // ── Panel state ────────────────────────────────────────────────────

  Map<String, Object?> toJson() {
    final info = project.read(output);
    final out = <String, Object?>{
      'pluginVersion': pluginVersion,
      'sdkName': 'Dart / Flutter SDK',
      'sdkUrl': 'https://github.com/getbraincloud/braincloud-dart',
      'state': state,
      'email': email,
      'error': error,
      'status': status,
      'serverUrl': serverUrl,
      'defaultServerUrl': project.defaultServerUrl,
      'portalUrl': portalHost(serverUrl),
      'teamId': teamId,
      'teams': teams,
      'apps': apps,
      'templates': templates,
      'templatesError': templatesError,
      'configured': {
        'present': info != null,
        'appId': info?.appId ?? '',
        'appName': info != null ? (appNames[info.appId] ?? '') : '',
        'children': [
          for (final id in info?.childIds ?? const <String>[]) {'id': id, 'name': appNames[id] ?? ''}
        ],
        'appVersion': info?.appVersion ?? project.defaultAppVersion,
        'output': output,
        'fileName': p.basename(output),
        'writtenAt': info != null ? File(output).lastModifiedSync().millisecondsSinceEpoch : 0,
        'gitignored': project.isIgnored(output),
      },
    };
    status = '';
    return out;
  }

  String _name(String appId) {
    final name = appNames[appId];
    return name != null && name.isNotEmpty ? '$name ($appId)' : appId;
  }

  // ── Session persistence (~/.braincloud, encoded, owner-only) ───────

  Uint8List _stream(List<int> salt, int length) {
    final out = Uint8List(length);
    var offset = 0;
    for (var n = 0; offset < length; n++) {
      final counter = Uint8List(4)..buffer.asByteData().setUint32(0, n, Endian.little);
      final block = Hmac(sha256, _sessionKey).convert([...salt, ...counter]).bytes;
      final take = min(block.length, length - offset);
      out.setRange(offset, offset + take, block);
      offset += block.length;
    }
    return out;
  }

  void _save() {
    final file = sessionFile;
    if (file == null) return;
    final plain = utf8.encode(jsonEncode({
      'serverUrl': serverUrl,
      'email': email,
      'accessToken': accessToken,
      'builderKey': builderKey,
      'teamId': teamId,
      'appNames': appNames,
      'childApps': childApps,
    }));
    final salt = _randomBytes(16);
    final ks = _stream(salt, plain.length);
    for (var i = 0; i < plain.length; i++) {
      plain[i] ^= ks[i];
    }
    try {
      Directory(p.dirname(file)).createSync(recursive: true);
      File(file).writeAsStringSync(jsonEncode({'v': 1, 's': base64Encode(salt), 'd': base64Encode(plain)}));
      if (!Platform.isWindows) Process.runSync('chmod', ['600', file]);
    } catch (_) {
      // Losing the session only means logging in again.
    }
  }

  void _load() {
    final file = sessionFile;
    if (file == null || !File(file).existsSync()) return;
    try {
      final stored = jsonDecode(File(file).readAsStringSync()) as Map<String, dynamic>;
      final data = base64Decode(stored['d'] as String);
      final ks = _stream(base64Decode(stored['s'] as String), data.length);
      for (var i = 0; i < data.length; i++) {
        data[i] ^= ks[i];
      }
      final s = jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
      if (pinnedServer.isNotEmpty && s['serverUrl'] != pinnedServer) return;
      if ((s['serverUrl'] ?? '') != '') serverUrl = s['serverUrl'] as String;
      email = (s['email'] ?? '') as String;
      accessToken = (s['accessToken'] ?? '') as String;
      builderKey = (s['builderKey'] ?? '') as String;
      teamId = (s['teamId'] ?? '') as String;
      appNames.addAll(((s['appNames'] ?? {}) as Map).cast<String, String>());
      ((s['childApps'] ?? {}) as Map).forEach((k, v) => childApps[k as String] = (v as List).cast<String>());
      if (accessToken.isNotEmpty && builderKey.isNotEmpty) state = 'logged_in';
    } catch (_) {
      // Unreadable session: start logged out.
    }
  }
}
