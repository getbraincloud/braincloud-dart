// Bundles the prebuilt config library (native/<os>_<arch>/) for the target being built.
import 'package:code_assets/code_assets.dart';
import 'package:hooks/hooks.dart';

void main(List<String> args) async {
  await build(args, (input, output) async {
    if (!input.config.buildCodeAssets) return;
    final code = input.config.code;
    final dir = _targetDir(code);
    if (dir == null) return; // Unsupported target: init() reports it at runtime.

    final file = input.packageRoot.resolve('native/$dir/${code.targetOS.dylibFileName('braincloud_native')}');
    output.dependencies.add(file);
    output.assets.code.add(CodeAsset(
      package: input.packageName,
      name: 'braincloud_native',
      linkMode: DynamicLoadingBundled(),
      file: file,
    ));
  });
}

String? _targetDir(CodeConfig code) {
  final arch = code.targetArchitecture.name;
  if (!const {'arm', 'arm64', 'ia32', 'x64'}.contains(arch)) return null;
  switch (code.targetOS) {
    case OS.iOS:
      final sim = code.iOS.targetSdk == IOSSdk.iPhoneSimulator;
      return sim ? 'ios_sim_$arch' : 'ios_$arch';
    case OS.android:
    case OS.macOS:
    case OS.linux:
    case OS.windows:
      return '${code.targetOS.name}_$arch';
    default:
      return null;
  }
}
