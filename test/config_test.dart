import 'dart:convert';
import 'dart:io';

import 'package:braincloud/braincloud.dart';
import 'package:braincloud/src/config/client_tuning.dart';
import 'package:braincloud/src/config/tuning_native.dart';
import 'package:test/test.dart';

void main() {
  const guid = '1cecb2f3-5a60-4b00-8c7e-7867c12eea49';

  test('round-trips a GUID through the bundled decoder', () async {
    final built = buildTuning(guid);
    final bundle = nestTuning(built.shares, built.pads, built.slotLen);
    expect(await resolveClientTuning(jsonEncode(bundle)), guid);
  });

  test('round-trips a non-GUID value', () async {
    final built = buildTuning('plain text secret é😀');
    expect(await resolveClientTuning(nestTuning(built.shares, built.pads, built.slotLen)), 'plain text secret é😀');
  });

  Map<String, dynamic> encode(String value) {
    final built = buildTuning(value);
    return nestTuning(built.shares, built.pads, built.slotLen);
  }

  test('BrainCloudAppConfig resolves the encoded app id, secret and children', () async {
    final config = BrainCloudAppConfig.fromJson({
      'clientProfile': jsonEncode(encode('123')),
      'clientTuning': jsonEncode(encode(guid)),
      'childApps': jsonEncode([
        [encode('456'), encode(guid)]
      ]),
    });
    final resolved = await config.resolve();
    expect(resolved.appId, '123');
    expect(resolved.secrets, {'123': guid, '456': guid});
  });

  test('BrainCloudAppConfig falls back to a plain secretKey', () async {
    final config = BrainCloudAppConfig.fromJson({'appId': '1', 'secretKey': 'plain'});
    expect((await config.resolve()).secrets, {'1': 'plain'});
  });

  test('decodes a config written by braincloud-dart-secure', () async {
    final file = File('../../data/bc_chat_internal.json');
    if (!file.existsSync()) return markTestSkipped('no data/bc_chat_internal.json');
    final config = BrainCloudAppConfig.fromJson(jsonDecode(file.readAsStringSync()));
    final resolved = await config.resolve();
    final secret = resolved.secrets[resolved.appId]!;
    expect(secret, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')));
  });
}
