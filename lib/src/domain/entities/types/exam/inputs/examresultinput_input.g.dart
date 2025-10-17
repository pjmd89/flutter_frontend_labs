// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examresultinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamResultInput _$ExamResultInputFromJson(Map<String, dynamic> json) =>
    ExamResultInput(
      examID: json['examID'] as String?,
      resultValues:
          (json['resultValues'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$ExamResultInputToJson(ExamResultInput instance) =>
    <String, dynamic>{
      'examID': instance.examID,
      'resultValues': instance.resultValues,
    };
