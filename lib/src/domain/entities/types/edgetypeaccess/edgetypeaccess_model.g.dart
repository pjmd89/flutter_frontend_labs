// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgetypeaccess_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeTypeAccess _$EdgeTypeAccessFromJson(Map<String, dynamic> json) =>
    EdgeTypeAccess(
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => TypeAccess.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pageInfo:
          json['pageInfo'] == null
              ? null
              : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EdgeTypeAccessToJson(EdgeTypeAccess instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
