// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgeexamtemplate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeExamTemplate _$EdgeExamTemplateFromJson(Map<String, dynamic> json) =>
    EdgeExamTemplate(
      edges:
          (json['edges'] as List<dynamic>?)
              ?.map((e) => ExamTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pageInfo:
          json['pageInfo'] == null
              ? null
              : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EdgeExamTemplateToJson(EdgeExamTemplate instance) =>
    <String, dynamic>{
      'edges': instance.edges,
      if (instance.pageInfo case final value?) 'pageInfo': value,
    };
