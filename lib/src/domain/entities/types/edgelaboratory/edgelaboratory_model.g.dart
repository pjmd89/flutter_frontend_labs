// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgelaboratory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeLaboratory _$EdgeLaboratoryFromJson(Map<String, dynamic> json) =>
    EdgeLaboratory(
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => Laboratory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pageInfo:
          json['pageInfo'] == null
              ? null
              : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EdgeLaboratoryToJson(EdgeLaboratory instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
