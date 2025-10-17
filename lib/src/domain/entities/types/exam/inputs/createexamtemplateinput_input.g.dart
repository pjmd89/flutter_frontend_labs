// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createexamtemplateinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateExamTemplateInput _$CreateExamTemplateInputFromJson(
  Map<String, dynamic> json,
) => CreateExamTemplateInput(
  name: json['name'] as String?,
  description: json['description'] as String?,
  indicators:
      (json['indicators'] as List<dynamic>?)
          ?.map((e) => CreateExamIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$CreateExamTemplateInputToJson(
  CreateExamTemplateInput instance,
) => <String, dynamic>{
  'name': instance.name,
  if (instance.description case final value?) 'description': value,
  'indicators': instance.indicators,
};
