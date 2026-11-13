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
external int _resolve(Pointer<Uint8> shares, Pointer<Uint8> seeds, int slotLen, Pointer<Char> out, int outCap);

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>, Pointer<Uint8>)>(
    symbol: 'bc_tuning_check', assetId: _asset)
external int _check(Pointer<Uint8> shares, Pointer<Uint8> seeds, int slotLen, Pointer<Uint8> tuning, Pointer<Uint8> check);

@Native<
        Int32 Function(
            Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Char>)>(
    symbol: 'bc_tuning_sign', assetId: _asset)
external int _sign(Pointer<Uint8> shares, Pointer<Uint8> seeds, int slotLen, Pointer<Uint8> tuning,
    Pointer<Uint8> check, Pointer<Uint8> payload, int payloadLen, Pointer<Char> outHex);

Pointer<Uint8> _copy(List<int> bytes) {
  final ptr = malloc<Uint8>(bytes.isEmpty ? 1 : bytes.length);
  ptr.asTypedList(bytes.length).setAll(0, bytes);
  return ptr;
}

void _wipeFree(Pointer<Uint8> ptr, int length) {
  ptr.asTypedList(length).fillRange(0, length, 0);
  malloc.free(ptr);
}

Future<void> prepareTuning() async {}

Future<String?> resolveTuning(Uint8List shares, Uint8List seeds, int slotLen) async =>
    resolveTuningSync(shares, seeds, slotLen);

/// Decodes an app id; null for anything that isn't one.
String? resolveTuningSync(Uint8List shares, Uint8List seeds, int slotLen) {
  final sharesPtr = malloc<Uint8>(shares.length);
  final seedsPtr = malloc<Uint8>(seeds.length);
  final outPtr = malloc<Uint8>(_outCap);
  try {
    sharesPtr.asTypedList(shares.length).setAll(0, shares);
    seedsPtr.asTypedList(seeds.length).setAll(0, seeds);
    final written = _resolve(sharesPtr, seedsPtr, slotLen, outPtr.cast(), _outCap);
    if (written < 0) return null;
    return utf8.decode(outPtr.asTypedList(written));
  } finally {
    malloc.free(sharesPtr);
    malloc.free(seedsPtr);
    malloc.free(outPtr);
  }
}

/// Whether [tuning] reads the value bundle.
bool checkTuning(Uint8List shares, Uint8List seeds, int slotLen, List<int> tuning, List<int> check) {
  final sharesPtr = _copy(shares);
  final seedsPtr = _copy(seeds);
  final tuningPtr = _copy(tuning);
  final checkPtr = _copy(check);
  try {
    return _check(sharesPtr, seedsPtr, slotLen, tuningPtr, checkPtr) == 1;
  } finally {
    malloc.free(sharesPtr);
    malloc.free(seedsPtr);
    _wipeFree(tuningPtr, tuning.length);
    malloc.free(checkPtr);
  }
}

/// The request signature for [payload]; null on bad arguments or a [tuning] that doesn't read the bundle.
String? signTuning(Uint8List shares, Uint8List seeds, int slotLen, List<int> tuning, List<int> check, List<int> payload) {
  final sharesPtr = _copy(shares);
  final seedsPtr = _copy(seeds);
  final tuningPtr = _copy(tuning);
  final checkPtr = _copy(check);
  final payloadPtr = _copy(payload);
  final outPtr = malloc<Uint8>(_signatureLen + 1);
  try {
    final written =
        _sign(sharesPtr, seedsPtr, slotLen, tuningPtr, checkPtr, payloadPtr, payload.length, outPtr.cast());
    if (written != _signatureLen) return null;
    return ascii.decode(outPtr.asTypedList(written));
  } finally {
    malloc.free(sharesPtr);
    malloc.free(seedsPtr);
    _wipeFree(tuningPtr, tuning.length);
    malloc.free(checkPtr);
    malloc.free(payloadPtr);
    malloc.free(outPtr);
  }
}
