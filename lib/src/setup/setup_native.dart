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

typedef _BuildNative = Int32 Function(Pointer<Uint8>, Int32, Pointer<Uint8>, Pointer<Uint8>);
typedef _Build = int Function(Pointer<Uint8>, int, Pointer<Uint8>, Pointer<Uint8>);

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

/// Encodes [value] as 32 `(share, salt)` slots.
({Uint8List shares, Uint8List salts, int slotLen}) buildTuning(String value) {
  final bytes = utf8.encode(value);
  final valuePtr = malloc<Uint8>(bytes.length);
  // Strided at bytes.length per slot (an upper bound); slotLen says how much is used.
  final sharesPtr = malloc<Uint8>(_slotCount * bytes.length);
  final saltsPtr = malloc<Uint8>(_slotCount * bytes.length);
  try {
    valuePtr.asTypedList(bytes.length).setAll(0, bytes);
    final slotLen = _build(valuePtr, bytes.length, sharesPtr, saltsPtr);
    final stridedShares = sharesPtr.asTypedList(_slotCount * bytes.length);
    final stridedSalts = saltsPtr.asTypedList(_slotCount * bytes.length);
    final shares = Uint8List(_slotCount * slotLen);
    final salts = Uint8List(_slotCount * slotLen);
    for (var i = 0; i < _slotCount; i++) {
      shares.setRange(i * slotLen, (i + 1) * slotLen, stridedShares, i * bytes.length);
      salts.setRange(i * slotLen, (i + 1) * slotLen, stridedSalts, i * bytes.length);
    }
    return (shares: shares, salts: salts, slotLen: slotLen);
  } finally {
    valuePtr.asTypedList(bytes.length).fillRange(0, bytes.length, 0);
    malloc.free(valuePtr);
    malloc.free(sharesPtr);
    malloc.free(saltsPtr);
  }
}
