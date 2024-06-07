//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

import 'dart:convert';

enum Access { none, readOnly, readWrite }

class ACL {
  Access other = Access.none;

  Access get() {
    return other;
  }

  set(Access access) {
    other = access;
  }

  ACL(Access access) {
    other = access;
  }

  static ACL none() {
    ACL acl = ACL(Access.none);
    return acl;
  }

  static ACL readOnly() {
    ACL acl = ACL(Access.readOnly);
    return acl;
  }

  static ACL readWrite() {
    ACL acl = ACL(Access.readWrite);
    return acl;
  }

  ACL.createFromJson(Map<String, dynamic> json) : other = json["other"];

  String toJsonString() {
    return json.encode(other);
  }
}
