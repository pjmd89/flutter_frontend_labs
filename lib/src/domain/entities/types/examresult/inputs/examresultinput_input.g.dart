// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examresultinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResultInput _$ExamResultInputFromJson(Map<String, dynamic> json) =>
    ExamResultInput(
      exam: json['exam'] as String?,
      indicatorValues:
          (json['indicatorValues'] as List<dynamic>?)
              ?.map(
                (e) => SetIndicatorValue.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
    );

Map<String, dynamic> _$ExamResultInputToJson(ExamResultInput instance) =>
    <String, dynamic>{
      'exam': instance.exam,
      'indicatorValues': instance.indicatorValues,
    };
