// Copyright 2025 bitHeads, Inc. All Rights Reserved.
//----------------------------------------------------
// brainCloud client source code

//----------------------------------------------------

typedef ACL = Map<String,int>;

abstract class ACLs {
  static ACL get none => {'other': 0};
  static ACL get read => {'other': 1};
  static ACL get readWrite => {'other': 2};
}

