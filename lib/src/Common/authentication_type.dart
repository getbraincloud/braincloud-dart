//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

enum AuthenticationType {
  anonymous,
  universal,
  email,
  facebook,
  facebookLimited,
  oculus,
  playstationNetwork,
  playstationNetwork5,
  gameCenter,
  steam,
  apple,
  google,
  googleOpenId,
  twitter,
  parse,
  handoff,
  external,
  settopHandoff,
  ultra,
  nintendo,
  unknown
}

extension AuthenticationTypeExtension on AuthenticationType {
  String toShortString() {
    return toString().split('.').last;
  }
}
