// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edgeexam_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EdgeExam _$EdgeExamFromJson(Map<String, dynamic> json) => EdgeExam(
  edges:
      (json['edges'] as List<dynamic>?)
          ?.map((e) => Exam.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  pageInfo:
      json['pageInfo'] == null
          ? null
          : PageInfo.fromJson(json['pageInfo'] as Map<String, dynamic>),
);

Map<String, dynamic> _$EdgeExamToJson(EdgeExam instance) => <String, dynamic>{
  'edges': instance.edges,
  if (instance.pageInfo case final value?) 'pageInfo': value,
};
