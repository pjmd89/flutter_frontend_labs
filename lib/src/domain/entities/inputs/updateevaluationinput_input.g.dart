// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateevaluationinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateEvaluationInput _$UpdateEvaluationInputFromJson(
  Map<String, dynamic> json,
) => UpdateEvaluationInput(
  id: json['_id'] as String?,
  observations:
      (json['observations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  valuesByExam:
      (json['valuesByExam'] as List<dynamic>?)
          ?.map((e) => ExamResultInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  allResultsCompleted: json['allResultsCompleted'] as bool?,
);

Map<String, dynamic> _$UpdateEvaluationInputToJson(
  UpdateEvaluationInput instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.observations case final value?) 'observations': value,
  if (instance.valuesByExam case final value?) 'valuesByExam': value,
  if (instance.allResultsCompleted case final value?)
    'allResultsCompleted': value,
};
