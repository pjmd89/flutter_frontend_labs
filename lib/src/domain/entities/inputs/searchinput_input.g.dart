// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'searchinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchInput _$SearchInputFromJson(Map<String, dynamic> json) => SearchInput(
  field: json['field'] as String?,
  value:
      (json['value'] as List<dynamic>?)
          ?.map((e) => ValueInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  and:
      (json['and'] as List<dynamic>?)
          ?.map((e) => SearchInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  not:
      (json['not'] as List<dynamic>?)
          ?.map((e) => SearchInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  nor:
      (json['nor'] as List<dynamic>?)
          ?.map((e) => SearchInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  or:
      (json['or'] as List<dynamic>?)
          ?.map((e) => SearchInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  elemMatch:
      (json['elemMatch'] as List<dynamic>?)
          ?.map((e) => ElemMatchInput.fromJson(e as Map<String, dynamic>))
          .toList(),
  geoSpatial:
      json['geoSpatial'] == null
          ? null
          : GeoSpatialInput.fromJson(
            json['geoSpatial'] as Map<String, dynamic>,
          ),
);

Map<String, dynamic> _$SearchInputToJson(SearchInput instance) =>
    <String, dynamic>{
      if (instance.field case final value?) 'field': value,
      if (instance.value case final value?) 'value': value,
      if (instance.and case final value?) 'and': value,
      if (instance.not case final value?) 'not': value,
      if (instance.nor case final value?) 'nor': value,
      if (instance.or case final value?) 'or': value,
      if (instance.elemMatch case final value?) 'elemMatch': value,
      if (instance.geoSpatial case final value?) 'geoSpatial': value,
    };
