import 'package:json_annotation/json_annotation.dart';

part 'entity.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class Entity<T> {
  String? entityId;
  String? entityIndexedId;
  int? version;
  T data;

  Entity(
      {this.entityId, this.entityIndexedId, this.version, required this.data});

  factory Entity.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$EntityFromJson(json, fromJsonT);
  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$EntityToJson(this, toJsonT);

  Entity<T> clone(T data) {
    return Entity(
        data: data,
        entityId: entityId,
        entityIndexedId: entityIndexedId,
        version: version);
  }
}
