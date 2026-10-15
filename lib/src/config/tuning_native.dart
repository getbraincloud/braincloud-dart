// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// FFI binding to the prebuilt decoder bundled by hook/build.dart.
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _asset = 'package:braincloud/braincloud_native';
const _slotCount = 32;
const _outCap = 512;

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Char>, Int32)>(
    symbol: 'bc_tuning_resolve', assetId: _asset)
external int _resolve(Pointer<Uint8> shares, Pointer<Uint8> pads, int slotLen, Pointer<Char> out, int outCap);

@Native<Int32 Function(Pointer<Uint8>, Int32, Pointer<Uint8>, Pointer<Uint8>)>(
    symbol: 'bc_tuning_build', assetId: _asset)
external int _build(Pointer<Uint8> value, int valueLen, Pointer<Uint8> outShares, Pointer<Uint8> outPads);

Future<String?> resolveTuning(Uint8List shares, Uint8List pads, int slotLen) async =>
    resolveTuningSync(shares, pads, slotLen);

String? resolveTuningSync(Uint8List shares, Uint8List pads, int slotLen) {
  final sharesPtr = malloc<Uint8>(shares.length);
  final padsPtr = malloc<Uint8>(pads.length);
  final outPtr = malloc<Uint8>(_outCap);
  try {
    sharesPtr.asTypedList(shares.length).setAll(0, shares);
    padsPtr.asTypedList(pads.length).setAll(0, pads);
    final written = _resolve(sharesPtr, padsPtr, slotLen, outPtr.cast(), _outCap);
    if (written < 0) return null;
    return utf8.decode(outPtr.asTypedList(written));
  } finally {
    outPtr.asTypedList(_outCap).fillRange(0, _outCap, 0);
    malloc.free(sharesPtr);
    malloc.free(padsPtr);
    malloc.free(outPtr);
  }
}

/// Encodes [value] as 32 `(share, pad)` slots. Setup tool only.
({Uint8List shares, Uint8List pads, int slotLen}) buildTuning(String value) {
  final bytes = utf8.encode(value);
  final valuePtr = malloc<Uint8>(bytes.length);
  // Strided at bytes.length per slot (an upper bound); slotLen says how much is used.
  final sharesPtr = malloc<Uint8>(_slotCount * bytes.length);
  final padsPtr = malloc<Uint8>(_slotCount * bytes.length);
  try {
    valuePtr.asTypedList(bytes.length).setAll(0, bytes);
    final slotLen = _build(valuePtr, bytes.length, sharesPtr, padsPtr);
    final stridedShares = sharesPtr.asTypedList(_slotCount * bytes.length);
    final stridedPads = padsPtr.asTypedList(_slotCount * bytes.length);
    final shares = Uint8List(_slotCount * slotLen);
    final pads = Uint8List(_slotCount * slotLen);
    for (var i = 0; i < _slotCount; i++) {
      shares.setRange(i * slotLen, (i + 1) * slotLen, stridedShares, i * bytes.length);
      pads.setRange(i * slotLen, (i + 1) * slotLen, stridedPads, i * bytes.length);
    }
    return (shares: shares, pads: pads, slotLen: slotLen);
  } finally {
    valuePtr.asTypedList(bytes.length).fillRange(0, bytes.length, 0);
    malloc.free(valuePtr);
    malloc.free(sharesPtr);
    malloc.free(padsPtr);
  }
}
