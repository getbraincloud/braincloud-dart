import 'dart:convert';
import 'dart:io';

import 'package:braincloud/braincloud.dart';

import '../config/lib/braincloud_tuning.dart';
import 'test_values.dart';

/// The test app, from the setup tool's test/config/bc_config.json and tuning file.
class StoredIds extends TestValues {
  final String _path;

  StoredIds([this._path = 'test/config/bc_config.json']);

  @override
  Future<void> load() async {
    if (profiles.isNotEmpty) return;
    final file = File(_path);
    if (!file.existsSync()) {
      throw StateError('Missing $_path. Run `dart run braincloud:setup` in test/config.');
    }
    braincloudBootstrap();
    final config = BrainCloudAppConfig.fromJson(jsonDecode(file.readAsStringSync()) as Map<String, dynamic>);
    await useConfig(config);
  }
}
