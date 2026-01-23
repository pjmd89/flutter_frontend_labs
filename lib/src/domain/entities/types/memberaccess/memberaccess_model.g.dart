// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memberaccess_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberAccess _$MemberAccessFromJson(Map<String, dynamic> json) => MemberAccess(
  type: json['type'] as String? ?? "",
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$MemberAccessToJson(MemberAccess instance) =>
    <String, dynamic>{
      'type': instance.type,
      'permissions': instance.permissions,
    };
