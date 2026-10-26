// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// OAuth + Builder API calls, same as braincloud-js-secure's builder.js.
import 'dart:convert';

import 'package:http/http.dart' as http;

const _version = 'v1';

class BuilderError implements Exception {
  final String message;
  final int status;
  BuilderError(this.message, [this.status = 0]);
  @override
  String toString() => message;
}

/// https://api.x.com/dispatcherv2 -> https://api.x.com; portal.* maps to api.*
String baseHost(String serverUrl) {
  final m = RegExp(r'^([a-z]+://)([^/]+)', caseSensitive: false).firstMatch(serverUrl.trim());
  if (m == null) return serverUrl.trim();
  return m[1]! + m[2]!.replaceFirst(RegExp(r'^portal\.'), 'api.');
}

String portalHost(String serverUrl) {
  final base = baseHost(serverUrl);
  final m = RegExp(r'^([a-z]+://)(.+)$', caseSensitive: false).firstMatch(base);
  return m == null ? base : '${m[1]}${m[2]!.replaceFirst(RegExp(r'^api\.'), 'portal.')}/';
}

int _byName(Map<String, String> a, Map<String, String> b) => a['name']!.toLowerCase().compareTo(b['name']!.toLowerCase());

class BuilderClient {
  final String base;
  final http.Client _http;

  BuilderClient(String serverUrl, {http.Client? client})
      : base = baseHost(serverUrl),
        _http = client ?? http.Client();

  String authorizeUrl(String clientId, String redirectUri, String scope, String state, String challenge) {
    final q = Uri(queryParameters: {
      'response_type': 'code',
      'client_id': clientId,
      'redirect_uri': redirectUri,
      'scope': scope,
      'state': state,
      'code_challenge': challenge,
      'code_challenge_method': 'S256',
    }).query.replaceAll('+', '%20');
    return '$base/oauth/authorize?$q';
  }

  Future<String> exchangeCode(String clientId, String redirectUri, String code, String verifier) async {
    const failure = 'Failed to exchange code for token.';
    final json = await _send('POST', '$base/oauth/token', {
      'Content-Type': 'application/x-www-form-urlencoded',
      'Accept': 'application/json',
    }, Uri(queryParameters: {
      'client_id': clientId,
      'grant_type': 'authorization_code',
      'redirect_uri': redirectUri,
      'code': code,
      'code_verifier': verifier,
    }).query, failure);
    final token = json['access_token'];
    if (token == null || token == '') throw BuilderError(failure);
    return '$token';
  }

  Future<({String email, String currentTeamId, List<Map<String, String>> teams})> userInfo(String accessToken) async {
    final user = await _send('GET', '$base/user/me',
        {'Authorization': 'Bearer $accessToken', 'Accept': 'application/json'}, null, 'Failed to fetch user info.');
    final info = (user['team_info'] as Map?) ?? {};
    final teams = [
      for (final t in (info['available_teams'] as List?) ?? [])
        {'id': '${t['teamId'] ?? ''}', 'name': '${t['teamName'] ?? ''}'}
    ]..sort(_byName);
    return (
      email: '${user['email'] ?? ''}',
      currentTeamId: '${(info['current_team'] as Map?)?['teamId'] ?? ''}',
      teams: teams,
    );
  }

  Future<String> tempApiKey(String accessToken, String teamId) async {
    final json = await _send(
        'POST',
        '$base/user/add-temp-api-key?teamId=${Uri.encodeQueryComponent(teamId)}',
        {'Authorization': 'Bearer $accessToken', 'Accept': 'application/json'},
        null,
        'Failed to obtain a Builder API key for this team. Please ensure Builder API is enabled on the '
            'Team Setup -> Team Info screen.');
    for (final entry in ((json['apiKey'] as Map?) ?? {}).values) {
      if (entry is Map && entry['apiKey'] != null) return '${entry['apiKey']}';
    }
    throw BuilderError('Builder API key not found in response.');
  }

  Future<List<Map<String, Object>>> apps(String email, String apiKey, String teamId) async {
    final json = await _builder('GET', '/builder/$_version/team/${Uri.encodeComponent(teamId)}/app', null, email,
        apiKey, 'Failed to fetch app list.');
    final apps = [
      for (final a in ((json['response'] as Map?)?['apps'] as List?) ?? [])
        <String, Object>{
          'id': '${a['appId']}',
          'name': '${a['appName'] ?? ''}',
          'parentAppId': a['parentAppId'] != null ? '${a['parentAppId']}' : '',
          'isParent': a['allowParentAssignment'] == true,
          'levelName': a['levelName'] != null ? '${a['levelName']}' : '',
        }
    ];
    apps.sort((a, b) => (a['name'] as String).toLowerCase().compareTo((b['name'] as String).toLowerCase()));
    return apps;
  }

  /// Only ever handed to the config writer; never sent to the panel.
  Future<String> appCredential(String email, String apiKey, String teamId, String appId) async {
    final json = await _builder(
        'GET',
        '/builder/$_version/team/${Uri.encodeComponent(teamId)}/app/${Uri.encodeComponent(appId)}/appsecret',
        null,
        email,
        apiKey,
        'Failed to fetch app credentials.');
    final value = ((json['response'] as Map?)?['app'] as Map?)?['appSecret'];
    if (value == null || value == '') throw BuilderError('App credentials not found in response.');
    return '$value';
  }

  /// Live template apps for one engine (the server's templateGameTeams map).
  Future<List<Map<String, String>>> templateApps(String email, String apiKey, String engine) async {
    final query = engine.isEmpty ? '' : '&engine=${Uri.encodeQueryComponent(engine)}';
    final json = await _builder('GET', '/builder/v1/utility/templateapps?liveOnly=true$query', null, email, apiKey,
        'Failed to fetch app templates.');
    return [
      for (final a in ((json['response'] as Map?)?['apps'] as List?) ?? [])
        {'id': '${a['appId']}', 'name': '${a['appName'] ?? ''}'}
    ]..sort(_byName);
  }

  Future<String> createApp(String email, String apiKey, String teamId, String appName, List<String> platforms,
      String templateAppId) async {
    final body = {
      'appName': appName,
      'appOptions': {'supportedPlatforms': platforms, 'gamificationEnabled': true},
      if (templateAppId.isNotEmpty) 'templateAppId': templateAppId,
    };
    final json = await _builder('POST', '/builder/$_version/team/${Uri.encodeComponent(teamId)}/app',
        jsonEncode(body), email, apiKey, 'Failed to create app.');
    return '${((json['response'] as Map?)?['app'] as Map?)?['appId'] ?? ''}';
  }

  Future<Map<String, dynamic>> _builder(
      String method, String path, String? body, String email, String apiKey, String failure) {
    final auth = base64Encode(utf8.encode('$email:$apiKey'));
    return _send(method, base + path,
        {'Authorization': 'Basic $auth', 'Content-Type': 'application/json', 'Accept': 'application/json'}, body, failure);
  }

  Future<Map<String, dynamic>> _send(
      String method, String url, Map<String, String> headers, String? body, String failure) async {
    http.Response res;
    try {
      final req = http.Request(method, Uri.parse(url))..headers.addAll(headers);
      if (body != null) req.body = body;
      res = await http.Response.fromStream(await _http.send(req));
    } catch (_) {
      throw BuilderError('$failure (network error)');
    }
    Object? json;
    try {
      json = jsonDecode(res.body);
    } catch (_) {
      // Non-JSON body; reported below.
    }
    if (res.statusCode < 200 || res.statusCode >= 300 || json is! Map<String, dynamic>) {
      final map = json is Map ? json : const {};
      final detail = map['message'] ??
          (map['reason_code'] != null ? 'reason code ${map['reason_code']}' : null) ??
          'HTTP ${res.statusCode}';
      throw BuilderError('$detail\n$failure', res.statusCode);
    }
    return json;
  }
}
