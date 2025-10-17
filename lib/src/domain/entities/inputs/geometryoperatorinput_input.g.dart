// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geometryoperatorinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeometryOperatorInput _$GeometryOperatorInputFromJson(
  Map<String, dynamic> json,
) => GeometryOperatorInput(
  type: $enumDecodeNullable(_$GeometryTypeEnumEnumMap, json['type']),
  coordinates:
      (json['coordinates'] as List<dynamic>?)
          ?.map((e) => CoordinatesInput.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GeometryOperatorInputToJson(
  GeometryOperatorInput instance,
) => <String, dynamic>{
  'type': _$GeometryTypeEnumEnumMap[instance.type]!,
  'coordinates': instance.coordinates,
};

const _$GeometryTypeEnumEnumMap = {
  GeometryTypeEnum.point: 'Point',
  GeometryTypeEnum.lineString: 'LineString',
  GeometryTypeEnum.polygon: 'Polygon',
  GeometryTypeEnum.multiPoint: 'MultiPoint',
  GeometryTypeEnum.multiLineString: 'MultiLineString',
};
