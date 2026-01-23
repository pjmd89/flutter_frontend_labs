// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'examindicator_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamIndicator _$ExamIndicatorFromJson(Map<String, dynamic> json) =>
    ExamIndicator(
      name: json['name'] as String? ?? "",
      valueType: $enumDecodeNullable(_$ValueTypeEnumMap, json['valueType']),
      unit: json['unit'] as String? ?? "",
      normalRange: json['normalRange'] as String? ?? "",
    );

Map<String, dynamic> _$ExamIndicatorToJson(ExamIndicator instance) =>
    <String, dynamic>{
      'name': instance.name,
      if (_$ValueTypeEnumMap[instance.valueType] case final value?)
        'valueType': value,
      'unit': instance.unit,
      'normalRange': instance.normalRange,
    };

const _$ValueTypeEnumMap = {
  ValueType.nUMERIC: 'NUMERIC',
  ValueType.tEXT: 'TEXT',
  ValueType.bOOLEAN: 'BOOLEAN',
};
