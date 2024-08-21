// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entity<T> _$EntityFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    Entity<T>(
      entityId: json['entityId'] as String?,
      entityIndexedId: json['entityIndexedId'] as String?,
      version: (json['version'] as num?)?.toInt(),
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$EntityToJson<T>(
  Entity<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'entityId': instance.entityId,
      'entityIndexedId': instance.entityIndexedId,
      'version': instance.version,
      'data': toJsonT(instance.data),
    };
