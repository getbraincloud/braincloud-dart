import '../gen/version.gen.dart';

class Version {
  //NOTE any Version suffix like +1 will be converted to .1 here, anything but numbers or . will be stripped
  static String getVersion() => packageVersion
      .replaceAll(RegExp('[+-]'), '.')
      .replaceAll(RegExp('![0-9.]'), '');
}
