// Copyright 2026 bitHeads, Inc. All Rights Reserved.
// Web build of the config library (tuning_wasm.g.dart).
import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';
import 'dart:typed_data';

import 'tuning_wasm.g.dart';

const _outCap = 512;
const _signatureLen = 32;
const _enosys = 52;

@JS('WebAssembly.compile')
external JSPromise<JSObject> _compile(JSUint8Array bytes);

@JS('WebAssembly.instantiate')
external JSPromise<JSObject> _instantiate(JSObject module, JSObject imports);

@JS('WebAssembly.Module.imports')
external JSArray<JSObject> _moduleImports(JSObject module);

@JS('crypto.getRandomValues')
external void _getRandomValues(JSUint8Array view);

JSObject? _exports;

Future<JSObject> _load() async {
  if (_exports != null) return _exports!;
  final module = await _compile(base64Decode(tuningWasm).toJS).toDart;

  late final JSObject exports;
  Uint8List memory() => ((exports['memory'] as JSObject)['buffer'] as JSArrayBuffer).toDart.asUint8List();

  // Only random_get does anything; the rest are WASI stubs libc may reference.
  final wasi = JSObject();
  for (final entry in _moduleImports(module).toDart) {
    final name = (entry['name'] as JSString).toDart;
    wasi[name] = name == 'random_get'
        ? ((JSNumber ptr, JSNumber len) {
            final view = memory().buffer.asUint8List(ptr.toDartInt, len.toDartInt);
            _getRandomValues(view.toJS);
            return 0.toJS;
          }).toJS
        : (() => _enosys.toJS).toJS;
  }
  final imports = JSObject()..['wasi_snapshot_preview1'] = wasi;
  final instance = await _instantiate(module, imports).toDart;
  exports = instance['exports'] as JSObject;
  exports.callMethod<JSAny?>('_initialize'.toJS);
  return _exports = exports;
}

int _call(JSObject exports, String fn, List<int> args) =>
    (exports.callMethodVarArgs<JSNumber>(fn.toJS, [for (final a in args) a.toJS])).toDartInt;

void _free(JSObject exports, int ptr) => exports.callMethod<JSAny?>('free'.toJS, ptr.toJS);

Future<void> prepareTuning() => _load();

Future<String?> resolveTuning(Uint8List shares, Uint8List salts, int slotLen) async {
  final exports = await _load();
  final sharesPtr = _call(exports, 'malloc', [shares.length]);
  final saltsPtr = _call(exports, 'malloc', [salts.length]);
  final outPtr = _call(exports, 'malloc', [_outCap]);
  // Re-read the buffer after each allocation; growth detaches the old one.
  Uint8List memory() => ((exports['memory'] as JSObject)['buffer'] as JSArrayBuffer).toDart.asUint8List();
  try {
    memory().setAll(sharesPtr, shares);
    memory().setAll(saltsPtr, salts);
    final written = _call(exports, 'bc_tuning_resolve', [sharesPtr, saltsPtr, slotLen, outPtr, _outCap]);
    if (written < 0) return null;
    return utf8.decode(memory().sublist(outPtr, outPtr + written));
  } finally {
    for (final p in [sharesPtr, saltsPtr, outPtr]) {
      _free(exports, p);
    }
  }
}

/// The request signature for [payload]; null on bad arguments. Needs [prepareTuning] first.
String? signTuning(Uint8List shares, Uint8List salts, int slotLen, List<int> payload) {
  final exports = _exports;
  if (exports == null) throw StateError('brainCloud config codec not loaded.');
  final sharesPtr = _call(exports, 'malloc', [shares.length]);
  final saltsPtr = _call(exports, 'malloc', [salts.length]);
  final payloadPtr = _call(exports, 'malloc', [payload.isEmpty ? 1 : payload.length]);
  final outPtr = _call(exports, 'malloc', [_signatureLen + 1]);
  Uint8List memory() => ((exports['memory'] as JSObject)['buffer'] as JSArrayBuffer).toDart.asUint8List();
  try {
    memory().setAll(sharesPtr, shares);
    memory().setAll(saltsPtr, salts);
    memory().setAll(payloadPtr, payload);
    final written =
        _call(exports, 'bc_tuning_sign', [sharesPtr, saltsPtr, slotLen, payloadPtr, payload.length, outPtr]);
    if (written != _signatureLen) return null;
    return ascii.decode(memory().sublist(outPtr, outPtr + written));
  } finally {
    for (final p in [sharesPtr, saltsPtr, payloadPtr, outPtr]) {
      _free(exports, p);
    }
  }
}
