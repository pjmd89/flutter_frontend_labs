// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typeaccess_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypeAccess _$TypeAccessFromJson(Map<String, dynamic> json) => TypeAccess(
  id: json['_id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  operations:
      (json['operations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$TypeAccessToJson(TypeAccess instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'operations': instance.operations,
    };
