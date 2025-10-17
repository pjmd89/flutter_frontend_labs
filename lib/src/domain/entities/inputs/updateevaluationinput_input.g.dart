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
  resultsByExam:
      (json['resultsByExam'] as List<dynamic>?)
          ?.map((e) => ExamResultInput.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UpdateEvaluationInputToJson(
  UpdateEvaluationInput instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.observations case final value?) 'observations': value,
  if (instance.resultsByExam case final value?) 'resultsByExam': value,
};
