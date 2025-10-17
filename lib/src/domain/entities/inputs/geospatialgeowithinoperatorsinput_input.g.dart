// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geospatialgeowithinoperatorsinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoSpatialGeoWithinOperatorsInput _$GeoSpatialGeoWithinOperatorsInputFromJson(
  Map<String, dynamic> json,
) => GeoSpatialGeoWithinOperatorsInput(
  box:
      json['box'] == null
          ? null
          : BoxOperatorInput.fromJson(json['box'] as Map<String, dynamic>),
  center:
      json['center'] == null
          ? null
          : CenterOperatorInput.fromJson(
            json['center'] as Map<String, dynamic>,
          ),
  centerSphere:
      json['centerSphere'] == null
          ? null
          : CenterOperatorInput.fromJson(
            json['centerSphere'] as Map<String, dynamic>,
          ),
  geometry:
      json['geometry'] == null
          ? null
          : GeometryOperatorInput.fromJson(
            json['geometry'] as Map<String, dynamic>,
          ),
  polygon:
      (json['polygon'] as List<dynamic>?)
          ?.map((e) => CoordinatesInput.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$GeoSpatialGeoWithinOperatorsInputToJson(
  GeoSpatialGeoWithinOperatorsInput instance,
) => <String, dynamic>{
  if (instance.box case final value?) 'box': value,
  if (instance.center case final value?) 'center': value,
  if (instance.centerSphere case final value?) 'centerSphere': value,
  if (instance.geometry case final value?) 'geometry': value,
  if (instance.polygon case final value?) 'polygon': value,
};
