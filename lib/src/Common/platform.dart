//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

enum Platform {
  appleTVOS,
  amazon,
  blackBerry,
  facebook,
  flutter,
  oculus,
  googlePlayAndroid,
  iOS,
  linux,
  mac,
  pS3,
  pS4,
  pSVita,
  roku,
  tizen,
  unknown,
  watchOS,
  web,
  wii,
  windowsPhone,
  windows,
  xbox360,
  xboxOne,
  nintendo
}

extension PlatformExtension on Platform {
  static Platform fromString(String s) {
    Platform type = Platform.values.firstWhere(
        (e) => e.toString() == 'AuthTypes.$s',
        orElse: () => Platform.unknown);

    return type;
  }

  String toShortString() {
    return toString().split('.').last;
  }
}
