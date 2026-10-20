// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// `dart run braincloud:setup`: opens the setup panel and writes bc_config.json.
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'project_config.dart' as project;
import 'setup_server.dart';
import 'setup_session.dart';

const usage =
    'Usage: dart run braincloud:setup [--out <path>] [--refresh] [--server <url>] [--no-browser] [--timeout <minutes>]';

bool _browse(String url) {
  try {
    if (Platform.isMacOS) {
      Process.start('open', [url], mode: ProcessStartMode.detached);
    } else if (Platform.isWindows) {
      Process.start('cmd', ['/c', 'start', '', url], mode: ProcessStartMode.detached);
    } else {
      Process.start('xdg-open', [url], mode: ProcessStartMode.detached);
    }
    return true;
  } catch (_) {
    return false;
  }
}

Future<int> runSetup(List<String> argv, {void Function(String) log = print, Map<String, String>? env}) async {
  String? out;
  String? server;
  var refresh = false, browser = true, help = false;
  String? bad;
  var timeout = 30;
  final args = argv.isNotEmpty && argv.first == 'setup' ? argv.sublist(1) : argv;
  for (var i = 0; i < args.length; i++) {
    String next() => i + 1 < args.length ? args[++i] : '';
    switch (args[i]) {
      case '--out':
        out = next();
      case '--server':
        server = next();
      case '--refresh':
        refresh = true;
      case '--no-browser':
        browser = false;
      case '--timeout':
        timeout = int.tryParse(next()) ?? 30;
      case '-h' || '--help':
        help = true;
      default:
        bad = args[i];
    }
  }
  if (help || bad != null) {
    log(usage);
    return help ? 0 : 1;
  }

  final output = p.absolute(out ?? project.defaultOutput(Directory.current.path));
  final session = SetupSession(output, serverUrl: server ?? '');

  if (refresh) {
    await session.refreshConfig(env ?? Platform.environment);
    log('Refreshed $output');
    return 0;
  }

  final setup = SetupServer(session);
  await setup.start();
  log('brainCloud setup is open at ${setup.url()}');
  log('Writing config to $output');
  if (!browser || !_browse(setup.url())) log('Open that address in your browser to continue.');
  final timedOut = await setup.done.then((_) => false).timeout(Duration(minutes: timeout), onTimeout: () => true);
  setup.stop();
  if (timedOut) log('brainCloud setup timed out after $timeout minutes.');
  if (project.read(output) != null) {
    log('Done. Build with --dart-define-from-file=${p.basename(output)}, then call:\n'
        '  await BrainCloudWrapper().init();');
  }
  return 0;
}
