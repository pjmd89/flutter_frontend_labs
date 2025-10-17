// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgeuser_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeUser _$EdgeUserFromJson(Map<String, dynamic> json) => EdgeUser(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeUserToJson(EdgeUser instance) => <String, dynamic>{
  'edges': instance.edges,
  if (instance.pageInfo case final value?) 'pageInfo': value,
};
