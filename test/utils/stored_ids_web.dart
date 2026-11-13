import 'package:braincloud/braincloud.dart';

import '../config/lib/braincloud_tuning.dart';
import 'test_values.dart';

/// Web: the test app from `--dart-define-from-file=test/config/bc_config.json`.
class StoredIds extends TestValues {
  StoredIds([String? _]);

  @override
  Future<void> load() async {
    if (profiles.isNotEmpty) return;
    braincloudBootstrap();
    await useConfig(BrainCloudAppConfig.fromEnvironment());
  }
}
