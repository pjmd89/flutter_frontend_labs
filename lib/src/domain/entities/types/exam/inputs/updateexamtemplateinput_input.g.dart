// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updateexamtemplateinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateExamTemplateInput _$UpdateExamTemplateInputFromJson(
  Map<String, dynamic> json,
) => UpdateExamTemplateInput(
  id: json['_id'] as String?,
  name: json['name'] as String?,
  description: json['description'] as String?,
  indicators:
      (json['indicators'] as List<dynamic>?)
          ?.map((e) => CreateExamIndicator.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$UpdateExamTemplateInputToJson(
  UpdateExamTemplateInput instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (instance.name case final value?) 'name': value,
  if (instance.description case final value?) 'description': value,
  if (instance.indicators case final value?) 'indicators': value,
};
