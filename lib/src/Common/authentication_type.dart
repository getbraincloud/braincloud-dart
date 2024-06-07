//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

// ignore_for_file: constant_identifier_names

enum AuthenticationType {
  Anonymous,
  Universal,
  Email,
  Facebook,
  FacebookLimited,
  Oculus,
  PlaystationNetwork,
  PlaystationNetwork5,
  GameCenter,
  Steam,
  Apple,
  Google,
  GoogleOpenId,
  Twitter,
  Parse,
  Handoff,
  External,
  SettopHandoff,
  Ultra,
  Nintendo,
  Unknown
}

extension AuthenticationTypeExtension on AuthenticationType {
  String toShortString() {
    return toString().split('.').last;
  }
}
