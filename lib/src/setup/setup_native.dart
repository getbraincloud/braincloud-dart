// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// FFI binding to the setup library, loaded by path (not bundled into apps).
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ffi/ffi.dart';
import 'package:path/path.dart' as p;

const _slotCount = 32;

const _checkLength = 12;

typedef _BuildNative = Int32 Function(
    Pointer<Uint8>, Int32, Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>);
typedef _Build = int Function(Pointer<Uint8>, int, Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>, Pointer<Uint8>);

String _libraryPath() {
  final lib = Isolate.resolvePackageUriSync(Uri.parse('package:braincloud/braincloud.dart'));
  if (lib == null) throw StateError('Could not locate the braincloud package.');
  final root = p.dirname(p.dirname(lib.toFilePath()));
  final file = Platform.isWindows
      ? 'braincloud_setup.dll'
      : (Platform.isMacOS ? 'libbraincloud_setup.dylib' : 'libbraincloud_setup.so');
  return p.join(root, 'native', 'setup', Abi.current().toString(), file);
}

late final _Build _build = () {
  final path = _libraryPath();
  if (!File(path).existsSync()) {
    throw UnsupportedError('brainCloud setup is not supported on ${Abi.current()} (no $path).');
  }
  return DynamicLibrary.open(path).lookupFunction<_BuildNative, _Build>('bc_tuning_build');
}();

/// Encodes [value] as 32 `(share, salt)` slots. Without [tuning] it's an app id; with the
/// project's tuning value it's a value, and [check] is set.
({Uint8List shares, Uint8List seeds, int slotLen, Uint8List? check}) buildTuning(String value, {List<int>? tuning}) {
  final bytes = utf8.encode(value);
  final valuePtr = malloc<Uint8>(bytes.isEmpty ? 1 : bytes.length);
  // Strided at bytes.length per slot (an upper bound); slotLen says how much is used.
  final sharesPtr = malloc<Uint8>(bytes.isEmpty ? 1 : _slotCount * bytes.length);
  final seedsPtr = malloc<Uint8>(bytes.isEmpty ? 1 : _slotCount * bytes.length);
  final tuningPtr = tuning == null ? nullptr : malloc<Uint8>(tuning.length);
  final checkPtr = malloc<Uint8>(_checkLength);
  try {
    valuePtr.asTypedList(bytes.length).setAll(0, bytes);
    if (tuning != null) tuningPtr.asTypedList(tuning.length).setAll(0, tuning);
    final slotLen = _build(valuePtr, bytes.length, tuningPtr, sharesPtr, seedsPtr, checkPtr);
    if (slotLen < 0) throw StateError('Could not encode the value.');
    final stridedShares = sharesPtr.asTypedList(_slotCount * bytes.length);
    final stridedSeeds = seedsPtr.asTypedList(_slotCount * bytes.length);
    final shares = Uint8List(_slotCount * slotLen);
    final seeds = Uint8List(_slotCount * slotLen);
    for (var i = 0; i < _slotCount; i++) {
      shares.setRange(i * slotLen, (i + 1) * slotLen, stridedShares, i * bytes.length);
      seeds.setRange(i * slotLen, (i + 1) * slotLen, stridedSeeds, i * bytes.length);
    }
    final check = tuning == null ? null : Uint8List.fromList(checkPtr.asTypedList(_checkLength));
    return (shares: shares, seeds: seeds, slotLen: slotLen, check: check);
  } finally {
    valuePtr.asTypedList(bytes.length).fillRange(0, bytes.length, 0);
    malloc.free(valuePtr);
    malloc.free(sharesPtr);
    malloc.free(seedsPtr);
    if (tuning != null) {
      tuningPtr.asTypedList(tuning.length).fillRange(0, tuning.length, 0);
      malloc.free(tuningPtr);
    }
    malloc.free(checkPtr);
  }
}
