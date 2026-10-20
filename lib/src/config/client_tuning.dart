// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Maps bc_config.json's `clientTuning` bundle to/from the decoder's flat slot arrays.
import 'dart:convert';
import 'dart:typed_data';

import '../app_profile.dart';
import 'tuning_unsupported.dart'
    if (dart.library.ffi) 'tuning_native.dart'
    if (dart.library.js_interop) 'tuning_web.dart' as codec;

const List<String> tuningKeyPool = [
  'region', 'locale', 'channel', 'segment', 'zone', 'realm', 'cohort', 'tier',
  'variant', 'flavor', 'edition', 'track', 'stage', 'wave', 'batch', 'bucket',
  'shard', 'cluster', 'node', 'ring', 'sector', 'district', 'domain', 'cell',
  'grid', 'lane', 'slice', 'layer', 'tag', 'label', 'marker', 'facet',
];

List<int> _ints(dynamic v) => (v as List<dynamic>).cast<int>();

/// The flat `(shares, pads, slotLen)` arrays of a decoded bundle, in [tuningKeyPool] order.
({Uint8List shares, Uint8List pads, int slotLen}) flattenTuning(Map<String, dynamic> bundle) {
  final slotLen = _ints((bundle[tuningKeyPool[0]] as List<dynamic>)[0]).length;
  final shares = <int>[];
  final pads = <int>[];
  for (final name in tuningKeyPool) {
    final pair = bundle[name] as List<dynamic>;
    shares.addAll(_ints(pair[0]));
    pads.addAll(_ints(pair[1]));
  }
  return (shares: Uint8List.fromList(shares), pads: Uint8List.fromList(pads), slotLen: slotLen);
}

/// Inverse of [flattenTuning].
Map<String, dynamic> nestTuning(Uint8List shares, Uint8List pads, int slotLen) => {
      for (var i = 0; i < tuningKeyPool.length; i++)
        tuningKeyPool[i]: [
          shares.sublist(i * slotLen, (i + 1) * slotLen),
          pads.sublist(i * slotLen, (i + 1) * slotLen),
        ],
    };

Map<String, dynamic> _bundle(Object tuning) =>
    tuning is String ? jsonDecode(tuning) as Map<String, dynamic> : tuning as Map<String, dynamic>;

/// Decodes an encoded app id (a bundle, or its JSON string). Null if it isn't one.
Future<String?> resolveClientTuning(Object tuning) async {
  final flat = flattenTuning(_bundle(tuning));
  return codec.resolveTuning(flat.shares, flat.pads, flat.slotLen);
}

/// A profile that signs with an encoded value; the value is only decoded natively.
Future<AppProfile> tuningProfile(Object tuning) async {
  final flat = flattenTuning(_bundle(tuning));
  await codec.prepareTuning();
  return AppProfile((payload) =>
      codec.signTuning(flat.shares, flat.pads, flat.slotLen, payload) ??
      (throw StateError('brainCloud config could not be used to sign.')));
}
