// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Maps bc_config.json's encoded bundles to/from the decoder's flat slot arrays.
import 'dart:convert';
import 'dart:typed_data';

import '../app_profile.dart';
import 'bootstrap.dart';
import 'tuning_unsupported.dart'
    if (dart.library.ffi) 'tuning_native.dart'
    if (dart.library.js_interop) 'tuning_web.dart' as codec;

const List<String> tuningKeyPool = [
  'region', 'locale', 'channel', 'segment', 'zone', 'realm', 'cohort', 'tier',
  'variant', 'flavor', 'edition', 'track', 'stage', 'wave', 'batch', 'bucket',
  'shard', 'cluster', 'node', 'ring', 'sector', 'district', 'domain', 'cell',
  'grid', 'lane', 'slice', 'layer', 'tag', 'label', 'marker', 'facet',
];

/// Format revision of value bundles: slots keyed by the build's tuning value.
const tuningRevision = 2;
const tuningLength = 32;
const checkLength = 12;

const _unreadable = 'brainCloud config could not be read.';

List<int> _ints(dynamic v) => (v as List<dynamic>).cast<int>();

/// The flat `(shares, seeds, slotLen)` arrays of a decoded bundle, in [tuningKeyPool] order.
({Uint8List shares, Uint8List seeds, int slotLen}) flattenTuning(Map<String, dynamic> bundle) {
  final slotLen = _ints((bundle[tuningKeyPool[0]] as List<dynamic>)[0]).length;
  final shares = <int>[];
  final seeds = <int>[];
  for (final name in tuningKeyPool) {
    final pair = bundle[name] as List<dynamic>;
    shares.addAll(_ints(pair[0]));
    seeds.addAll(_ints(pair[1]));
  }
  return (shares: Uint8List.fromList(shares), seeds: Uint8List.fromList(seeds), slotLen: slotLen);
}

/// Inverse of [flattenTuning]. With [check], a value bundle of the current revision.
Map<String, dynamic> nestTuning(Uint8List shares, Uint8List seeds, int slotLen, {List<int>? check}) => {
      for (var i = 0; i < tuningKeyPool.length; i++)
        tuningKeyPool[i]: [
          shares.sublist(i * slotLen, (i + 1) * slotLen),
          seeds.sublist(i * slotLen, (i + 1) * slotLen),
        ],
      if (check != null) ...{'revision': tuningRevision, 'check': check},
    };

Map<String, dynamic> tuningBundle(Object tuning) =>
    tuning is String ? jsonDecode(tuning) as Map<String, dynamic> : tuning as Map<String, dynamic>;

/// The bundle's check if it's a value bundle of the current revision, else null.
Uint8List? tuningCheck(Map<String, dynamic> bundle) {
  final check = bundle['check'];
  if (bundle['revision'] != tuningRevision || check is! List || check.length != checkLength) return null;
  return Uint8List.fromList(check.cast<int>());
}

/// Decodes an encoded app id (a bundle, or its JSON string). Null if it isn't one.
Future<String?> resolveClientTuning(Object tuning) async {
  final flat = flattenTuning(tuningBundle(tuning));
  return codec.resolveTuning(flat.shares, flat.seeds, flat.slotLen);
}

Uint8List _value(TuningFill fill) {
  final value = Uint8List.fromList(fill());
  if (value.length != tuningLength) throw StateError(_unreadable);
  return value;
}

/// A profile that signs with an encoded value, read with the build's tuning value.
Future<AppProfile> tuningProfile(Object tuning, [TuningFill? fill]) async {
  final bundle = tuningBundle(tuning);
  final check = tuningCheck(bundle);
  final source = fill ?? registeredTuning;
  if (check == null || source == null) throw StateError(_unreadable);
  final flat = flattenTuning(bundle);
  await codec.prepareTuning();
  final value = _value(source);
  final ok = codec.checkTuning(flat.shares, flat.seeds, flat.slotLen, value, check);
  value.fillRange(0, value.length, 0);
  if (!ok) throw StateError(_unreadable);
  return AppProfile((payload) {
    final value = _value(source);
    try {
      return codec.signTuning(flat.shares, flat.seeds, flat.slotLen, value, check, payload) ??
          (throw StateError('brainCloud config could not be used to sign.'));
    } finally {
      value.fillRange(0, value.length, 0);
    }
  });
}
