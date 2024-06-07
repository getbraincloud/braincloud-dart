//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------
class AuthenticationIds {
  String externalId;
  String authenticationToken;
  String authenticationSubType; // Empty string for most auth types

  AuthenticationIds(
      this.externalId, this.authenticationToken, this.authenticationSubType);
}
