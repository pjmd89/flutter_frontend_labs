// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examresult_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResult _$ExamResultFromJson(Map<String, dynamic> json) => ExamResult(
  exam:
      json['exam'] == null
          ? null
          : Exam.fromJson(json['exam'] as Map<String, dynamic>),
  cost: json['cost'] as num? ?? 0,
  indicatorValues:
      (json['indicatorValues'] as List<dynamic>?)
          ?.map((e) => IndicatorValue.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ExamResultToJson(ExamResult instance) =>
    <String, dynamic>{
      if (instance.exam case final value?) 'exam': value,
      'cost': instance.cost,
      'indicatorValues': instance.indicatorValues,
    };
