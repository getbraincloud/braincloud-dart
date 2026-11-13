@TestOn('vm')
library;

import 'dart:convert';
import 'dart:io';

import 'package:braincloud/braincloud.dart';
import 'package:braincloud/src/setup/project_config.dart' as project;
import 'package:braincloud/src/setup/setup_main.dart';
import 'package:braincloud/src/setup/setup_server.dart';
import 'package:braincloud/src/setup/setup_session.dart';
import 'package:braincloud/src/setup/tuning_source.dart';
import 'package:path/path.dart' as p;
import 'package:test/test.dart';

const _secret = '1cecb2f3-5a60-4b00-8c7e-7867c12eea49';
const _childSecret = '9a8b7c6d-5e4f-4a3b-8c2d-1e0f9a8b7c6d';

final _payload = utf8.encode('{"packetId":1}');

// Values only come back out as signatures.
String _sig(String secret) => AppProfile.fromValue(secret).sign(_payload);

// Stands in for the app's generated braincloudBootstrap().
void _bootstrap(String file) {
  final value = project.projectTuning(file);
  BrainCloudWrapper.bootstrap(() => value ?? const []);
}

Future<String> _configSig(String file) async {
  _bootstrap(file);
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
    expect(state['tuning'], {'present': true, 'matches': true, 'value': ''});
    expect(jsonEncode(state), isNot(contains(tuningFileName)));
    _bootstrap(output);
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
    _bootstrap(output);
    final resolved = await BrainCloudAppConfig.fromJson(jsonDecode(File(output).readAsStringSync())).resolve();
    expect(resolved.profiles['100']!.sign(_payload), _sig(_secret));
    expect(resolved.profiles['200']!.sign(_payload), _sig(_childSecret));
  });

  SetupSession loggedIn(String output) {
    final session = SetupSession(output, sessionFile: null, serverUrl: serverUrl)
      ..state = 'logged_in'
      ..email = 'dev@example.com'
      ..accessToken = 'AT'
      ..builderKey = 'BK'
      ..teamId = 'T1';
    return session;
  }

  test('one tuning value per project: minted on first save, reused across rewrites', () async {
    final output = p.join(dir.path, 'bc_config.json');
    final session = loggedIn(output);
    await session.refreshApps();
    await session.selectApp('100');
    final first = project.projectTuning(output)!;
    await session.selectApp('200');
    expect(session.error, '');
    expect(project.projectTuning(output), first);
    session.saveSettings(serverUrl, '2.0.0', null, null);
    expect(project.projectTuning(output), first);
    expect(await _configSig(output), _sig(_childSecret));
  });

  test('Regenerate and --refresh --new-tuning re-encode with a new value and fetch children again', () async {
    final output = p.join(dir.path, 'bc_config.json');
    final session = loggedIn(output);
    await session.refreshApps();
    await session.selectApp('100');
    await session.addChild('200', '');
    final first = project.projectTuning(output)!;

    await session.retune(newTuning());
    expect(session.error, '');
    final second = project.projectTuning(output)!;
    expect(sameTuning(first, second), isFalse);
    expect(project.tuningState(output), (present: true, matches: true));
    _bootstrap(output);
    final resolved = await BrainCloudAppConfig.fromJson(jsonDecode(File(output).readAsStringSync())).resolve();
    expect(resolved.profiles['200']!.sign(_payload), _sig(_childSecret));

    session.useTuning(newTuning());
    await session.refreshConfig({});
    expect(sameTuning(project.projectTuning(output)!, second), isFalse);
    expect(project.load(output)!.children.single.appId, '200');
    expect(await _configSig(output), _sig(_secret));
  });

  test('a lost tuning value reads as unreadable until the app is selected again', () async {
    final output = p.join(dir.path, 'bc_config.json');
    final session = loggedIn(output);
    await session.refreshApps();
    await session.selectApp('100');
    final first = project.projectTuning(output)!;
    File(project.tuningPath(output)).deleteSync();

    expect(project.read(output)?.appId, '100');
    expect(() => project.load(output), throwsA(predicate((e) => '$e' == project.unreadable)));
    session.saveSettings(serverUrl, '2.0.0', null, null);
    expect(session.error, project.unreadable);
    await session.addChild('200', '');
    expect(session.error, project.unreadable);
    expect(session.toJson()['tuning'], {'present': false, 'matches': false, 'value': ''});

    await session.selectApp('100');
    expect(session.error, '');
    expect(sameTuning(project.projectTuning(output)!, first), isFalse);
    expect(await _configSig(output), _sig(_secret));
  });

  test('a different value reads as a mismatch', () async {
    final output = p.join(dir.path, 'bc_config.json');
    project.write(output, appId: '100', appValue: _secret);
    final value = project.projectTuning(output)!;
    File(project.tuningPath(output)).writeAsStringSync(tuningSource(newTuning()));
    expect(project.tuningState(output), (present: true, matches: false));
    File(project.tuningPath(output)).writeAsStringSync(tuningSource(value));
    expect(project.tuningState(output), (present: true, matches: true));
  });

  test('the tuning file is written first and put back if the config write fails', () async {
    final output = p.join(dir.path, 'bc_config.json');
    project.write(output, appId: '100', appValue: _secret);
    final tuningFile = project.tuningPath(output);
    final before = File(tuningFile).readAsStringSync();
    File(output).deleteSync();
    Directory(output).createSync(); // config write fails
    expect(() => project.write(output, appId: '100', appValue: _secret, tuning: newTuning()), throwsA(anything));
    expect(File(tuningFile).readAsStringSync(), before);

    File(tuningFile).deleteSync();
    expect(() => project.write(output, appId: '100', appValue: _secret), throwsA(anything));
    expect(File(tuningFile).existsSync(), isFalse);
  });

  test('config and tuning file are gitignored under one header', () async {
    Directory(p.join(dir.path, '.git')).createSync();
    File(p.join(dir.path, 'pubspec.yaml')).writeAsStringSync('name: app\n');
    final output = p.join(dir.path, 'bc_config.json');
    project.write(output, appId: '100', appValue: _secret);
    project.write(output, appId: '100', appValue: _secret);
    expect(project.tuningPath(output), p.join(dir.path, 'lib', tuningFileName));
    expect(File(p.join(dir.path, '.gitignore')).readAsStringSync(),
        '# brainCloud app config (generated)\n/bc_config.json\n/lib/$tuningFileName\n');
  });

  test('--show-tuning prints the value; --tuning needs --refresh', () async {
    final output = p.join(dir.path, 'bc_config.json');
    project.write(output, appId: '100', appValue: _secret);
    final lines = <String>[];
    expect(await runSetup(['--out', output, '--show-tuning'], log: lines.add), 0);
    expect(lines.single, tuningHex(project.projectTuning(output)!));
    expect(await runSetup(['--out', output, '--new-tuning'], log: lines.add), 1);
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
