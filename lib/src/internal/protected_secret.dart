// Copyright 2026 bitHeads, Inc. All Rights Reserved.
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

/// Holds an app secret without keeping a single plain-text copy of it around
/// in memory. The secret's UTF-8 bytes are split into a random "pad" and the
/// secret XOR'd with that pad (`masked[i] = secretBytes[i] ^ pad[i]`) -- on
/// its own, neither buffer reveals anything about the secret.
///
/// The real bytes are only ever reconstructed transiently, inside
/// [useBytes], for the one caller that needs them (request signing); the
/// temporary buffer is wiped before [useBytes] returns.
class ProtectedSecret {
  final Uint8List _pad;
  final Uint8List _masked;

  ProtectedSecret._(this._pad, this._masked);

  factory ProtectedSecret(String secret) {
    final secretBytes = Uint8List.fromList(utf8.encode(secret));
    final pad = _randomBytes(secretBytes.length);
    final masked = Uint8List(secretBytes.length);
    for (var i = 0; i < secretBytes.length; i++) {
      masked[i] = secretBytes[i] ^ pad[i];
    }
    secretBytes.fillRange(0, secretBytes.length, 0);
    return ProtectedSecret._(pad, masked);
  }

  static final Random _random = Random.secure();

  static Uint8List _randomBytes(int length) {
    final bytes = Uint8List(length);
    for (var i = 0; i < length; i++) {
      bytes[i] = _random.nextInt(256);
    }
    return bytes;
  }

  /// Reconstructs the secret's raw UTF-8 bytes, passes them to [action], then
  /// zeroes the temporary buffer before returning [action]'s result.
  T useBytes<T>(T Function(Uint8List secretBytes) action) {
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

/// MD5s [payloadBytes] followed by [secretBytes] without ever concatenating
/// them into a single buffer first -- equivalent to
/// `md5(payloadBytes + secretBytes)`, but the two inputs are fed to the hash
/// as separate chunks so the caller never has to build a combined
/// payload+secret buffer just to sign a request.
String calculateChunkedMd5(List<int> payloadBytes, List<int> secretBytes) {
  final digestSink = _DigestSink();
  final byteSink = md5.startChunkedConversion(digestSink);
  byteSink.add(payloadBytes);
  byteSink.add(secretBytes);
  byteSink.close();
  return digestSink.digest.toString();
}
