// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:typed_data';

Never _unsupported() => throw UnsupportedError('brainCloud config is not supported on this platform.');

Future<void> prepareTuning() async => _unsupported();

Future<String?> resolveTuning(Uint8List shares, Uint8List salts, int slotLen) async => _unsupported();

String? signTuning(Uint8List shares, Uint8List salts, int slotLen, List<int> payload) => _unsupported();
