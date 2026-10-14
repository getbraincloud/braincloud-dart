// `dart run braincloud:setup` -- see lib/src/setup/setup_main.dart.
import 'dart:io';

import 'package:braincloud/src/setup/setup_main.dart';

Future<void> main(List<String> args) async {
  try {
    exitCode = await runSetup(args);
  } catch (e) {
    stderr.writeln('$e');
    exitCode = 1;
  }
  exit(exitCode);
}
