// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Serves the setup panel on its own ephemeral loopback port and opens the registered OAuth
// callback port only while a login is in flight. Same checks as braincloud-js-secure's server.js.
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'setup_session.dart';

const _loginTimeout = Duration(minutes: 10);
const _tokenHeader = 'x-setup-token';

const _securityHeaders = {
  'Cache-Control': 'no-store',
  'X-Content-Type-Options': 'nosniff',
  'Referrer-Policy': 'no-referrer',
  'Content-Security-Policy': "default-src 'self'; img-src 'self'; style-src 'self' 'unsafe-inline'; "
      "script-src 'self' 'unsafe-inline'; connect-src 'self'; frame-ancestors 'none'; form-action 'none'",
};

Future<List<int>> _panelAsset(String name) async {
  final uri = await Isolate.resolvePackageUri(Uri.parse('package:braincloud/src/setup/panel/$name'));
  return File.fromUri(uri!).readAsBytes();
}

Future<List<HttpServer>> _listen(int port, void Function(HttpRequest) handler) async {
  final v4 = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
  v4.listen(handler);
  try {
    final v6 = await HttpServer.bind(InternetAddress.loopbackIPv6, v4.port, v6Only: true);
    v6.listen(handler);
    return [v4, v6];
  } catch (_) {
    return [v4];
  }
}

void _close(List<HttpServer> servers) {
  for (final s in servers) {
    s.close(force: true);
  }
}

Future<void> _send(HttpRequest req, int status, String type, Object body, [Map<String, String> extra = const {}]) async {
  final res = req.response..statusCode = status;
  res.headers.set('Content-Type', type);
  _securityHeaders.forEach(res.headers.set);
  extra.forEach(res.headers.set);
  if (body is List<int>) {
    res.add(body);
  } else {
    res.write(body);
  }
  await res.close();
}

bool _hostAllowed(HttpRequest req, int port) {
  final host = req.headers.value('host') ?? '';
  return host.toLowerCase() == 'localhost:$port' || host == '127.0.0.1:$port' || host == '[::1]:$port';
}

bool _originAllowed(HttpRequest req, int port) {
  final origin = req.headers.value('origin');
  return origin == null ||
      origin.toLowerCase() == 'http://localhost:$port' ||
      origin == 'http://127.0.0.1:$port' ||
      origin == 'http://[::1]:$port';
}

Future<Map<String, dynamic>> _readBody(HttpRequest req) async {
  try {
    final bytes = <int>[];
    await for (final chunk in req) {
      bytes.addAll(chunk);
      if (bytes.length > 64 * 1024) return {};
    }
    final text = utf8.decode(bytes).trim();
    final json = text.isEmpty ? null : jsonDecode(text);
    return json is Map<String, dynamic> ? json : {};
  } catch (_) {
    return {};
  }
}

String _str(Object? v) => v == null ? '' : '$v';

class SetupServer {
  final SetupSession session;
  final int _requestedPanelPort;
  final String token = base64Url(List.generate(24, (_) => Random.secure().nextInt(256)));
  List<HttpServer> _panel = [];
  List<HttpServer> _callback = [];
  Timer? _callbackTimer;
  int panelPort = 0;
  final _done = Completer<void>();
  void Function()? onLogin;

  SetupServer(this.session, {int panelPort = 0}) : _requestedPanelPort = panelPort;

  Future<void> get done => _done.future;

  String url() => 'http://localhost:$panelPort/';

  Future<void> start() async {
    _panel = await _listen(_requestedPanelPort, _handlePanel);
    panelPort = _panel.first.port;
  }

  void stop() {
    _stopCallback();
    _close(_panel);
    _panel = [];
  }

  Future<String> beginLogin(String? serverUrl, bool fromIde) async {
    _stopCallback();
    try {
      _callback = await _listen(session.callbackPort, _handleCallback);
    } catch (_) {
      throw StateError('Another brainCloud login is in progress (port ${session.callbackPort} is busy). '
          'Finish or cancel it, then try again.');
    }
    _callbackTimer = Timer(_loginTimeout, () {
      _stopCallback();
      session.cancelLogin();
      onLogin?.call();
    });
    return session.beginLogin(serverUrl, fromIde);
  }

  void cancelLogin() {
    _stopCallback();
    session.cancelLogin();
  }

  void _stopCallback() {
    _callbackTimer?.cancel();
    _callbackTimer = null;
    _close(_callback);
    _callback = [];
  }

  Future<void> _handleCallback(HttpRequest req) async {
    if (!_hostAllowed(req, session.callbackPort) || req.method != 'GET' || req.uri.path != '/oauth/callback') {
      return _send(req, 404, 'text/plain', 'Not found');
    }
    final fromIde = session.loginFromIde;
    final q = req.uri.queryParameters;
    await session.completeLogin(q['code'], q['state'], q['error']);
    if (fromIde) {
      final msg = session.isLoggedIn()
          ? "You're logged in to brainCloud. Return to your app to pick a team and app."
          : "brainCloud login didn't complete. Return to your app for details.";
      await _send(
          req,
          200,
          'text/html; charset=utf-8',
          '<!DOCTYPE html><html><head><meta charset="utf-8"><title>brainCloud</title><style>body{font:14px system-ui,sans-serif;'
              'background:#0f1923;color:#e6edf3;display:flex;align-items:center;justify-content:center;height:100vh;margin:0}'
              'p{max-width:320px;text-align:center}</style></head><body><p>$msg</p></body></html>');
    } else {
      await _send(req, 302, 'text/plain', '', {'Location': url()});
    }
    // Release the shared callback port once the reply is written.
    _stopCallback();
    onLogin?.call();
  }

  Future<void> _handlePanel(HttpRequest req) async {
    try {
      if (!_hostAllowed(req, panelPort)) return await _send(req, 403, 'text/plain', 'Forbidden');
      final path = req.uri.path;
      if (req.method == 'GET') {
        if (path == '/') {
          final html = utf8.decode(await _panelAsset('index.html')).replaceFirst('__SETUP_TOKEN__', token);
          return await _send(req, 200, 'text/html; charset=utf-8', html);
        }
        if (path == '/logo.png' || path == '/logo_light.png') {
          return await _send(req, 200, 'image/png', await _panelAsset(path.substring(1)));
        }
        return await _send(req, 404, 'text/plain', 'Not found');
      }
      if (req.method != 'POST' || !path.startsWith('/api/')) {
        return await _send(req, 405, 'text/plain', 'Method not allowed');
      }
      if (!_originAllowed(req, panelPort) || req.headers.value(_tokenHeader) != token) {
        return await _send(req, 403, 'text/plain', 'Forbidden');
      }
      final body = await _readBody(req);
      final extra = <String, Object?>{};
      final s = session;
      switch (path.substring(5)) {
        case 'state':
          s.reloadIfIdle();
        case 'login':
          try {
            extra['authorizeUrl'] = await beginLogin(_str(body['serverUrl']), body['host'] == 'ide');
          } catch (e) {
            s.reportError(e is StateError ? e.message : '$e');
          }
        case 'cancel':
          cancelLogin();
        case 'logout':
          s.logout();
        case 'teams':
          await s.refreshTeams();
        case 'team':
          await s.selectTeam(_str(body['teamId']));
        case 'apps':
          await s.refreshApps();
        case 'app':
          await s.selectApp(_str(body['appId']));
        case 'child-add':
          await s.addChild(_str(body['appId']), _str(body['appValue']));
        case 'child-remove':
          s.removeChild(_str(body['appId']));
        case 'templates':
          await s.refreshTemplates();
        case 'create':
          final platforms = body['platforms'] is List ? [for (final p in body['platforms'] as List) '$p'] : <String>[];
          await s.createApp(_str(body['appName']), platforms, _str(body['templateAppId']));
        case 'save':
          s.saveSettings(_str(body['serverUrl']), _str(body['appVersion']), _str(body['appId']), _str(body['appValue']));
        case 'done':
          break;
        default:
          return await _send(req, 404, 'text/plain', 'Not found');
      }
      await _send(req, 200, 'application/json', jsonEncode({...s.toJson(), ...extra}));
      if (path == '/api/done' && !_done.isCompleted) _done.complete();
    } catch (_) {
      try {
        await _send(req, 500, 'text/plain', 'Setup error');
      } catch (_) {
        // Response already started.
      }
    }
  }
}
