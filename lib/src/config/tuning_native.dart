// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// FFI binding to the prebuilt decoder bundled by hook/build.dart.
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';

const _asset = 'package:braincloud/braincloud_native';
const _outCap = 512;
const _signatureLen = 32;

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Char>, Int32)>(
    symbol: 'bc_tuning_resolve', assetId: _asset)
external int _resolve(Pointer<Uint8> shares, Pointer<Uint8> pads, int slotLen, Pointer<Char> out, int outCap);

@Native<Int32 Function(Pointer<Uint8>, Pointer<Uint8>, Int32, Pointer<Uint8>, Int32, Pointer<Char>)>(
    symbol: 'bc_tuning_sign', assetId: _asset)
external int _sign(Pointer<Uint8> shares, Pointer<Uint8> pads, int slotLen, Pointer<Uint8> payload, int payloadLen,
    Pointer<Char> outHex);

Future<void> prepareTuning() async {}

Future<String?> resolveTuning(Uint8List shares, Uint8List pads, int slotLen) async =>
    resolveTuningSync(shares, pads, slotLen);

/// Decodes an app id; null for anything that isn't one.
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
    malloc.free(sharesPtr);
    malloc.free(padsPtr);
    malloc.free(outPtr);
  }
}

/// The request signature for [payload]; null on bad arguments.
String? signTuning(Uint8List shares, Uint8List pads, int slotLen, List<int> payload) {
  final sharesPtr = malloc<Uint8>(shares.length);
  final padsPtr = malloc<Uint8>(pads.length);
  final payloadPtr = malloc<Uint8>(payload.isEmpty ? 1 : payload.length);
  final outPtr = malloc<Uint8>(_signatureLen + 1);
  try {
    sharesPtr.asTypedList(shares.length).setAll(0, shares);
    padsPtr.asTypedList(pads.length).setAll(0, pads);
    payloadPtr.asTypedList(payload.length).setAll(0, payload);
    final written = _sign(sharesPtr, padsPtr, slotLen, payloadPtr, payload.length, outPtr.cast());
    if (written != _signatureLen) return null;
    return ascii.decode(outPtr.asTypedList(written));
  } finally {
    malloc.free(sharesPtr);
    malloc.free(padsPtr);
    malloc.free(payloadPtr);
    malloc.free(outPtr);
  }
}
