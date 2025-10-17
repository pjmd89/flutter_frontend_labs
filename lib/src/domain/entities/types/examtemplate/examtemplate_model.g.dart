// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examtemplate_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamTemplate _$ExamTemplateFromJson(Map<String, dynamic> json) => ExamTemplate(
  id: json['_id'] as String? ?? "",
  name: json['name'] as String? ?? "",
  description: json['description'] as String? ?? "",
  indicators:
      (json['indicators'] as List<dynamic>?)
          ?.map((e) => ExamIndicator.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  created: json['created'] as String? ?? "",
  updated: json['updated'] as String? ?? "",
);

Map<String, dynamic> _$ExamTemplateToJson(ExamTemplate instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'indicators': instance.indicators,
      'created': instance.created,
      'updated': instance.updated,
    };
