// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Signs requests for one app.
///
/// `BrainCloudWrapper.initFromConfig()` builds these from `bc_config.json`; use
/// [AppProfile.fromValue] with `init(appProfile:)` when initializing by hand.
class AppProfile {
  /// Returns the request signature for [payload].
  final String Function(List<int> payload) sign;

  /// A profile backed by your own signer.
  const AppProfile(this.sign);

  /// A profile for the app's secret key, held masked in memory.
  factory AppProfile.fromValue(String secretKey) {
    final masked = _MaskedValue(secretKey);
    return AppProfile((payload) => masked.use((bytes) => calculateChunkedMd5(payload, bytes)));
  }
}

class _MaskedValue {
  final Uint8List _pad;
  final Uint8List _masked;

  _MaskedValue._(this._pad, this._masked);

  factory _MaskedValue(String value) {
    final bytes = Uint8List.fromList(utf8.encode(value));
    final pad = _randomBytes(bytes.length);
    final masked = Uint8List(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      masked[i] = bytes[i] ^ pad[i];
    }
    bytes.fillRange(0, bytes.length, 0);
    return _MaskedValue._(pad, masked);
  }

  static final Random _random = Random.secure();

  static Uint8List _randomBytes(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }

  /// Passes the raw bytes to [action]; they're wiped afterwards.
  T use<T>(T Function(Uint8List bytes) action) {
    final bytes = Uint8List(_masked.length);
    for (var i = 0; i < _masked.length; i++) {
      bytes[i] = _masked[i] ^ _pad[i];
    }
    try {
      return action(bytes);
    } finally {
      bytes.fillRange(0, bytes.length, 0);
    }
  }
}

class _DigestSink implements Sink<Digest> {
  Digest? _digest;

  @override
  void add(Digest data) => _digest = data;

  @override
  void close() {}

  Digest get digest => _digest!;
}

/// `md5(payloadBytes + valueBytes)` without building a combined buffer.
String calculateChunkedMd5(List<int> payloadBytes, List<int> valueBytes) {
  final digestSink = _DigestSink();
  final byteSink = md5.startChunkedConversion(digestSink);
  byteSink.add(payloadBytes);
  byteSink.add(valueBytes);
  byteSink.close();
  return digestSink.digest.toString();
}
