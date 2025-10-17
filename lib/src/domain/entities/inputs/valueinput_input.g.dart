// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'valueinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ValueInput _$ValueInputFromJson(Map<String, dynamic> json) => ValueInput(
  value: json['value'] as String?,
  values: (json['values'] as List<dynamic>?)?.map((e) => e as String).toList(),
  kind: $enumDecodeNullable(_$KindEnumEnumMap, json['kind']),
  operator: $enumDecodeNullable(_$OperatorEnumEnumMap, json['operator']),
  regexOption: $enumDecodeNullable(
    _$OptionsRegexEnumEnumMap,
    json['regexOption'],
  ),
  modOption:
      json['modOption'] == null
          ? null
          : ModInput.fromJson(json['modOption'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ValueInputToJson(ValueInput instance) =>
    <String, dynamic>{
      if (instance.value case final value?) 'value': value,
      if (instance.values case final value?) 'values': value,
      if (_$KindEnumEnumMap[instance.kind] case final value?) 'kind': value,
      if (_$OperatorEnumEnumMap[instance.operator] case final value?)
        'operator': value,
      if (_$OptionsRegexEnumEnumMap[instance.regexOption] case final value?)
        'regexOption': value,
      if (instance.modOption case final value?) 'modOption': value,
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

const _$OperatorEnumEnumMap = {
  OperatorEnum.eq: 'eq',
  OperatorEnum.gt: 'gt',
  OperatorEnum.gte: 'gte',
  OperatorEnum.lt: 'lt',
  OperatorEnum.lte: 'lte',
  OperatorEnum.ne: 'ne',
  OperatorEnum.all: 'all',
  OperatorEnum.in_: 'in',
  OperatorEnum.nin: 'nin',
  OperatorEnum.regex: 'regex',
  OperatorEnum.size: 'size',
  OperatorEnum.mod: 'mod',
  OperatorEnum.exists: 'exists',
};

const _$OptionsRegexEnumEnumMap = {
  OptionsRegexEnum.i: 'i',
  OptionsRegexEnum.m: 'm',
  OptionsRegexEnum.x: 'x',
  OptionsRegexEnum.s: 's',
};
