//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

typedef ACL = Map<String,int>;

abstract class ACLs {
  static ACL get none => {'other': 0};
  static ACL get read => {'other': 1};
  static ACL get readWrite => {'other': 2};
}

