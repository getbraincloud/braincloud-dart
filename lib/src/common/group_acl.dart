//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

import 'dart:convert';

enum Access { none, readOnly, readWrite }

class GroupACL {
  Access other = Access.none;
  Access member = Access.none;

  GroupACL(Access otherAccess, Access memberAccess) {
    other = otherAccess;
    member = memberAccess;
  }

  GroupACL.createFromJson(Map<String, dynamic> json)
      : other = json["other"],
        member = json["member"];

  String toJsonString() {
    return jsonEncode({"other": this.other.index, "member": this.member.index});
  }
}
