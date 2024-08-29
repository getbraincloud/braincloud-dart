//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

enum AuthenticationType {
  anonymous('Anonymous'),
  universal('Universal'),
  email('Email'),
  facebook('Facebook'),
  facebookLimited('FacebookLimited'),
  oculus(''),
  playstationNetwork(''),
  playstationNetwork5(''),
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
  nintendo(''),
  unknown('');

  const AuthenticationType(this.value);
  final String value;
}

extension AuthenticationTypeExtension on AuthenticationType {
  String toShortString() {
    return value;
    // return toString().split('.').last;
  }
}
