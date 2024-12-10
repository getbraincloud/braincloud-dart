//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum PlatformID {
  appleTVOS('APPLE_TV_OS'),
  amazon('AMAZON'),
  blackBerry('BB'),
  facebook('FB'),
  oculus('Oculus'),
  googlePlayAndroid('ANG'),
  iOS('IOS'),
  linux('LINUX'),
  mac('MAC'),
  pS3('PS3'),
  pS4('PS4'),
  pSVita('PS_VITA'),
  roku('ROKU'),
  tizen('TIZEN'),
  unknown('UNKNOWN'),
  watchOS('WATCH_OS'),
  web("WEB"),
  wii('WII'),
  windowsPhone('WINP'),
  windows('WINDOWS'),
  xbox360('XBOX_360'),
  xboxOne('XBOX_ONE'),
  nintendo('NINTENDO'),
  steam('STEAM');

  const PlatformID(this.value);
  final String value;

  static PlatformID fromString(String s) {
    PlatformID type = PlatformID.values
        .firstWhere((e) => e.value == s, orElse: () => PlatformID.unknown);

    return type;
  }

  @override
  String toString() => value;
}
