// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'elemmatchinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ElemMatchInput _$ElemMatchInputFromJson(Map<String, dynamic> json) =>
    ElemMatchInput(
      field: json['field'] as String?,
      fieldMatch: json['fieldMatch'] as String?,
      value: json['value'] as String?,
      kind: $enumDecodeNullable(_$KindEnumEnumMap, json['kind']),
    );

Map<String, dynamic> _$ElemMatchInputToJson(ElemMatchInput instance) =>
    <String, dynamic>{
      if (instance.field case final value?) 'field': value,
      if (instance.fieldMatch case final value?) 'fieldMatch': value,
      if (instance.value case final value?) 'value': value,
      if (_$KindEnumEnumMap[instance.kind] case final value?) 'kind': value,
    };

const _$KindEnumEnumMap = {
  KindEnum.string: 'String',
  KindEnum.int: 'Int',
  KindEnum.float: 'Float',
  KindEnum.boolean: 'Boolean',
  KindEnum.iD: 'ID',
  KindEnum.date: 'Date',
  KindEnum.dateTime: 'DateTime',
  KindEnum.age: 'Age',
};
