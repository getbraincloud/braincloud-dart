//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

enum AuthenticationType {
  anonymous(''),
  universal('Universal'),
  email('Email'),
  facebook(''),
  facebookLimited(''),
  oculus(''),
  playstationNetwork(''),
  playstationNetwork5(''),
  gameCenter(''),
  steam(''),
  apple(''),
  google(''),
  googleOpenId(''),
  twitter(''),
  parse(''),
  handoff(''),
  external('External'),
  settopHandoff('SettopHandoff'),
  ultra(''),
  nintendo(''),
  unknown('');
  const AuthenticationType(this.value); 
  final String value;
}

extension AuthenticationTypeExtension on AuthenticationType {
  String toShortString() {
    return this.value;
    // return toString().split('.').last;
  }
}
