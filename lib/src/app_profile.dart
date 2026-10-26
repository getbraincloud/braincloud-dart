// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Signs requests for one app.
///
/// `BrainCloudWrapper.init()` builds these from `bc_config.json`; use
/// [AppProfile.fromValue] with `init(appProfile:)` when initializing by hand.
class AppProfile {
  /// Returns the request signature for [payload].
  final String Function(List<int> payload) sign;

  /// A profile backed by your own signer.
  const AppProfile(this.sign);

  /// A profile for the app's secret key.
  factory AppProfile.fromValue(String secretKey) {
    final held = _HeldValue(secretKey);
    return AppProfile((payload) => held.use((bytes) => calculateChunkedMd5(payload, bytes)));
  }
}

class _HeldValue {
  final Uint8List _noise;
  final Uint8List _held;

  _HeldValue._(this._noise, this._held);

  factory _HeldValue(String value) {
    final bytes = Uint8List.fromList(utf8.encode(value));
    final noise = _randomBytes(bytes.length);
    final held = Uint8List(bytes.length);
    for (var i = 0; i < bytes.length; i++) {
      held[i] = bytes[i] ^ noise[i];
    }
    bytes.fillRange(0, bytes.length, 0);
    return _HeldValue._(noise, held);
  }

  static final Random _random = Random.secure();

  static Uint8List _randomBytes(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }

  /// Runs [action] with the value's bytes.
  T use<T>(T Function(Uint8List bytes) action) {
    final bytes = Uint8List(_held.length);
    for (var i = 0; i < _held.length; i++) {
      bytes[i] = _held[i] ^ _noise[i];
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
