//----------------------------------------------------
// brainCloud client source code
// Copyright 2024 bitHeads, inc.
//----------------------------------------------------

import 'dart:convert';

enum Access {
  none("NONE"),
  readOnly("READONLY"),
  readWrite("READWRITE");

  const Access(this.value);

  final String value;

  static Access fromString(String s) {
    Access access = Access.values
        .firstWhere((e) => e.value == s, orElse: () => Access.none);

    return access;
  }

  @override
  String toString() => value;
}

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
