// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgecompany_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeCompany _$EdgeCompanyFromJson(Map<String, dynamic> json) => EdgeCompany(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => Company.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeCompanyToJson(EdgeCompany instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
