// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createexaminput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateExamInput _$CreateExamInputFromJson(Map<String, dynamic> json) =>
    CreateExamInput(
      template: json['template'] as String?,
      laboratory: json['laboratory'] as String?,
      baseCost: json['baseCost'] as num?,
    );

Map<String, dynamic> _$CreateExamInputToJson(CreateExamInput instance) =>
    <String, dynamic>{
      'template': instance.template,
      'laboratory': instance.laboratory,
      'baseCost': instance.baseCost,
    };
