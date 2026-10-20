@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:braincloud/braincloud.dart';
import 'package:braincloud/src/setup/project_config.dart' as project;
import 'package:braincloud/src/setup/setup_server.dart';
import 'package:braincloud/src/setup/setup_session.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _secret = '1cecb2f3-5a60-4b00-8c7e-7867c12eea49';
const _childSecret = '9a8b7c6d-5e4f-4a3b-8c2d-1e0f9a8b7c6d';

final _payload = utf8.encode('{"packetId":1}');

// Values only come back out as signatures.
String _sig(String secret) => AppProfile.fromValue(secret).sign(_payload);

Future<String> _configSig(String file) async {
  final resolved = await BrainCloudAppConfig.fromJson(jsonDecode(File(file).readAsStringSync())).resolve();
  return resolved.profiles[resolved.appId]!.sign(_payload);
}

/// Minimal stand-in for the brainCloud OAuth + Builder API.
Future<HttpServer> _fakeBrainCloud() async {
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  server.listen((req) async {
    final body = await utf8.decodeStream(req);
    Object json;
    switch (req.uri.path) {
      case '/oauth/token':
        final form = Uri.splitQueryString(body);
        json = form['client_id'] == clientId && form['code'] == 'CODE' && form['code_verifier']!.isNotEmpty
            ? {'access_token': 'AT'}
            : {'message': 'bad exchange'};
      case '/user/me':
        json = {
          'email': 'dev@example.com',
          'team_info': {
            'current_team': {'teamId': 'T1'},
            'available_teams': [
              {'teamId': 'T1', 'teamName': 'Team One'}
            ],
          },
        };
      case '/user/add-temp-api-key':
        json = {
          'apiKey': {
            'k': {'apiKey': 'BK'}
          }
        };
      case '/builder/v1/team/T1/app':
        json = {
          'response': {
            'apps': [
              {'appId': '100', 'appName': 'Parent', 'allowParentAssignment': true},
              {'appId': '200', 'appName': 'Child', 'parentAppId': '100'},
            ]
          }
        };
      case '/builder/v1/team/T1/app/100/appsecret':
        json = {
          'response': {
            'app': {'appSecret': _secret}
          }
        };
      case '/builder/v1/team/T1/app/200/appsecret':
        json = {
          'response': {
            'app': {'appSecret': _childSecret}
          }
        };
      default:
        req.response.statusCode = 404;
        json = {'message': 'not found'};
    }
    req.response.headers.contentType = ContentType.json;
    req.response.write(jsonEncode(json));
    await req.response.close();
  });
  return server;
}

Future<int> _freePort() async {
  final s = await ServerSocket.bind(InternetAddress.loopbackIPv4, 0);
  final port = s.port;
  await s.close();
  return port;
}

void main() {
  late Directory dir;
  late HttpServer brainCloud;
  late String serverUrl;
  final http = HttpClient();

  setUp(() async {
    dir = await Directory.systemTemp.createTemp('bc_setup_test');
    brainCloud = await _fakeBrainCloud();
    serverUrl = 'http://127.0.0.1:${brainCloud.port}/dispatcherv2';
  });

  tearDown(() async {
    await brainCloud.close(force: true);
    await dir.delete(recursive: true);
  });

  Future<(int, String)> request(String method, Uri uri, {Map<String, String> headers = const {}, Object? body}) async {
    final req = await http.openUrl(method, uri);
    req.followRedirects = false;
    headers.forEach(req.headers.set);
    if (body != null) req.write(jsonEncode(body));
    final res = await req.close();
    return (res.statusCode, await utf8.decodeStream(res));
  }

  test('login, pick an app and a child, write a decodable bc_config.json', () async {
    final output = p.join(dir.path, 'bc_config.json');
    File(output).writeAsStringSync(jsonEncode({'myDefine': 'kept', 'secretKey': 'old'}));
    final session = SetupSession(output,
        sessionFile: p.join(dir.path, 'session.json'), callbackPort: await _freePort(), serverUrl: serverUrl);
    final server = SetupServer(session);
    await server.start();
    final panel = Uri.parse(server.url());
    Future<Map<String, dynamic>> api(String action, [Map<String, Object> body = const {}]) async {
      final (status, text) = await request('POST', panel.resolve('api/$action'),
          headers: {'x-setup-token': server.token, 'content-type': 'application/json'}, body: body);
      expect(status, 200, reason: text);
      return jsonDecode(text) as Map<String, dynamic>;
    }

    // Panel requests without the token are refused.
    expect((await request('POST', panel.resolve('api/state'))).$1, 403);
    expect((await request('GET', panel)).$2, contains(server.token));

    final login = await api('login', {'serverUrl': serverUrl});
    final authorize = Uri.parse(login['authorizeUrl'] as String);
    expect(authorize.queryParameters['client_id'], clientId);
    expect(authorize.queryParameters['code_challenge_method'], 'S256');

    final callback = Uri.parse(authorize.queryParameters['redirect_uri']!)
        .replace(queryParameters: {'code': 'CODE', 'state': authorize.queryParameters['state']!});
    final (status, _) = await request('GET', callback);
    expect(status, 302);
    expect(session.isLoggedIn(), isTrue);

    var state = await api('app', {'appId': '100'});
    expect(state['configured']['appId'], '100');
    expect(state.toString(), isNot(contains(_secret)));

    state = await api('child-add', {'appId': '200'});
    expect(state['configured']['children'], [
      {'id': '200', 'name': 'Child'}
    ]);

    final json = jsonDecode(File(output).readAsStringSync()) as Map<String, dynamic>;
    expect(json['myDefine'], 'kept');
    expect(json.containsKey('secretKey'), isFalse);
    expect(json.containsKey('appId'), isFalse);
    expect(File(output).readAsStringSync(), isNot(contains('"100"')));
    expect(File(output).readAsStringSync(), isNot(contains(_secret)));
    final resolved = await BrainCloudAppConfig.fromJson(json).resolve();
    expect(resolved.appId, '100');
    expect(resolved.profiles.keys, ['100', '200']);
    expect(resolved.profiles['100']!.sign(_payload), _sig(_secret));
    expect(resolved.profiles['200']!.sign(_payload), _sig(_childSecret));

    await api('done');
    await server.done;
    server.stop();
  });

  test('--refresh rewrites the config from CI env vars', () async {
    final output = p.join(dir.path, 'bc_config.json');
    final session = SetupSession(output, sessionFile: null, serverUrl: serverUrl);
    await session.refreshConfig({
      'BRAINCLOUD_APP_ID': '100',
      'BRAINCLOUD_SERVER_URL': serverUrl,
      'BRAINCLOUD_BUILDER_EMAIL': 'ci@example.com',
      'BRAINCLOUD_BUILDER_API_KEY': 'BK',
      'BRAINCLOUD_TEAM_ID': 'T1',
    });
    expect(project.load(output)?.appId, '100');
    expect(await _configSig(output), _sig(_secret));
  });

  test('rewriting the server or children keeps the stored values as-is', () async {
    final output = p.join(dir.path, 'bc_config.json');
    project.write(output, appId: '100', appValue: _secret);
    final stored = jsonDecode(File(output).readAsStringSync())['clientTuning'];

    expect(project.rewrite(output, 'https://example.com/dispatcherv2', '2.0.0'), isTrue);
    final current = project.load(output)!;
    expect(current.serverUrl, 'https://example.com/dispatcherv2');
    expect(jsonDecode(File(output).readAsStringSync())['clientTuning'], stored);

    project.write(output,
        appId: current.appId,
        appValue: current.appValue,
        children: [(appId: '200', appValue: _childSecret)]);
    final resolved = await BrainCloudAppConfig.fromJson(jsonDecode(File(output).readAsStringSync())).resolve();
    expect(resolved.profiles['100']!.sign(_payload), _sig(_secret));
    expect(resolved.profiles['200']!.sign(_payload), _sig(_childSecret));
  });

  test('session file is encoded at rest', () async {
    final sessionFile = p.join(dir.path, 'session.json');
    final session = SetupSession(p.join(dir.path, 'bc_config.json'), sessionFile: sessionFile)
      ..accessToken = 'secret-token'
      ..builderKey = 'BK';
    session.logout(); // saves
    session
      ..accessToken = 'secret-token'
      ..builderKey = 'BK'
      ..saveSettings(null, null, '1', 'x');
    expect(File(sessionFile).readAsStringSync(), isNot(contains('secret-token')));
    expect(SetupSession(p.join(dir.path, 'bc_config.json'), sessionFile: sessionFile).accessToken, 'secret-token');
  });
}
