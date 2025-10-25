// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createexamindicator_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateExamIndicator _$CreateExamIndicatorFromJson(Map<String, dynamic> json) =>
    CreateExamIndicator(
      name: json['name'] as String?,
      valueType: $enumDecodeNullable(_$ValueTypeEnumMap, json['valueType']),
      unit: json['unit'] as String?,
      normalRange: json['normalRange'] as String?,
    );

Map<String, dynamic> _$CreateExamIndicatorToJson(
  CreateExamIndicator instance,
) => <String, dynamic>{
  'name': instance.name,
  'valueType': _$ValueTypeEnumMap[instance.valueType]!,
  if (instance.unit case final value?) 'unit': value,
  if (instance.normalRange case final value?) 'normalRange': value,
};

const _$ValueTypeEnumMap = {
  ValueType.numeric: 'numeric',
  ValueType.text: 'text',
  ValueType.boolean: 'boolean',
};
