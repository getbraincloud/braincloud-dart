// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// FFI binding to the config library bundled by hook/build.dart.
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _asset = 'package:braincloud/braincloud_native';
const _outCap = 512;
const _signatureLen = 32;

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Char>, Int32)>(
    symbol: 'bc_tuning_resolve', assetId: _asset)
external int _resolve(Pointer<Uint8> shares, Pointer<Uint8> salts, int slotLen, Pointer<Char> out, int outCap);

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>, Int32, Pointer<Char>)>(
    symbol: 'bc_tuning_sign', assetId: _asset)
external int _sign(Pointer<Uint8> shares, Pointer<Uint8> salts, int slotLen, Pointer<Uint8> payload, int payloadLen,
    Pointer<Char> outHex);

Future<void> prepareTuning() async {}

Future<String?> resolveTuning(Uint8List shares, Uint8List salts, int slotLen) async =>
    resolveTuningSync(shares, salts, slotLen);

/// Decodes an app id; null for anything that isn't one.
String? resolveTuningSync(Uint8List shares, Uint8List salts, int slotLen) {
  final sharesPtr = malloc<Uint8>(shares.length);
  final saltsPtr = malloc<Uint8>(salts.length);
  final outPtr = malloc<Uint8>(_outCap);
  try {
    sharesPtr.asTypedList(shares.length).setAll(0, shares);
    saltsPtr.asTypedList(salts.length).setAll(0, salts);
    final written = _resolve(sharesPtr, saltsPtr, slotLen, outPtr.cast(), _outCap);
    if (written < 0) return null;
    return utf8.decode(outPtr.asTypedList(written));
  } finally {
    malloc.free(sharesPtr);
    malloc.free(saltsPtr);
    malloc.free(outPtr);
  }
}

/// The request signature for [payload]; null on bad arguments.
String? signTuning(Uint8List shares, Uint8List salts, int slotLen, List<int> payload) {
  final sharesPtr = malloc<Uint8>(shares.length);
  final saltsPtr = malloc<Uint8>(salts.length);
  final payloadPtr = malloc<Uint8>(payload.isEmpty ? 1 : payload.length);
  final outPtr = malloc<Uint8>(_signatureLen + 1);
  try {
    sharesPtr.asTypedList(shares.length).setAll(0, shares);
    saltsPtr.asTypedList(salts.length).setAll(0, salts);
    payloadPtr.asTypedList(payload.length).setAll(0, payload);
    final written = _sign(sharesPtr, saltsPtr, slotLen, payloadPtr, payload.length, outPtr.cast());
    if (written != _signatureLen) return null;
    return ascii.decode(outPtr.asTypedList(written));
  } finally {
    malloc.free(sharesPtr);
    malloc.free(saltsPtr);
    malloc.free(payloadPtr);
    malloc.free(outPtr);
  }
}
