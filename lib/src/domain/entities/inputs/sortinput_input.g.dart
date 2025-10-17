// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sortinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SortInput _$SortInputFromJson(Map<String, dynamic> json) => SortInput(
  field: json['field'] as String?,
  order: $enumDecodeNullable(_$SortEnumEnumMap, json['order']),
);

Map<String, dynamic> _$SortInputToJson(SortInput instance) => <String, dynamic>{
  'field': instance.field,
  if (_$SortEnumEnumMap[instance.order] case final value?) 'order': value,
};

const _$SortEnumEnumMap = {SortEnum.asc: 'asc', SortEnum.desc: 'desc'};
