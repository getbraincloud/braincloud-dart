// Copyright 2026 bitHeads, Inc. All Rights Reserved.
//----------------------------------------------------
// brainCloud client source code

//----------------------------------------------------
class AuthenticationIds {
  String externalId;
  String authenticationToken;
  String authenticationSubType; // Empty string for most auth types

  AuthenticationIds(
      this.externalId, this.authenticationToken, this.authenticationSubType);
}
