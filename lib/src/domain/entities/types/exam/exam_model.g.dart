// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Exam _$ExamFromJson(Map<String, dynamic> json) => Exam(
  id: json['_id'] as String? ?? "",
  template:
      json['template'] == null
          ? null
          : ExamTemplate.fromJson(json['template'] as Map<String, dynamic>),
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  baseCost: json['baseCost'] as num? ?? 0,
  created: json['created'] as num? ?? 0,
  updated: json['updated'] as num? ?? 0,
);

Map<String, dynamic> _$ExamToJson(Exam instance) => <String, dynamic>{
  '_id': instance.id,
  if (instance.template case final value?) 'template': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  'baseCost': instance.baseCost,
  'created': instance.created,
  'updated': instance.updated,
};
