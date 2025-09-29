// Copyright 2025 bitHeads, Inc. All Rights Reserved.
//----------------------------------------------------
// brainCloud client source code

//----------------------------------------------------

enum AuthenticationType {
  anonymous('Anonymous'),
  universal('Universal'),
  email('Email'),
  facebook('Facebook'),
  facebookLimited('FacebookLimited'),
  oculus('Oculus'),
  playstationNetwork('PlaystationNetwork'),
  playstationNetwork5('PlaystationNetwork5'),
  gameCenter('GameCenter'),
  steam('Steam'),
  apple('Apple'),
  google('Google'),
  googleOpenId('GoogleOpenId'),
  twitter('Twitter'),
  parse('Parse'),
  handoff('Handoff'),
  external('External'),
  settopHandoff('SettopHandoff'),
  ultra('Ultra'),
  nintendo('Nintendo'),
  unknown('UNKNOWN');

  const AuthenticationType(this.value);
  final String value;

  static AuthenticationType fromString(String s) {
    AuthenticationType type = AuthenticationType.values.firstWhere(
        (e) => e.value == s,
        orElse: () => AuthenticationType.unknown);

    return type;
  }

  @override
  String toString() => value;
}
