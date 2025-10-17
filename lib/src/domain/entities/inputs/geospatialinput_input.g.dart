// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geospatialinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoSpatialInput _$GeoSpatialInputFromJson(
  Map<String, dynamic> json,
) => GeoSpatialInput(
  geoIntersects:
      (json['geoIntersects'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
  geoWithin:
      json['geoWithin'] == null
          ? null
          : GeoSpatialGeoWithinOperatorsInput.fromJson(
            json['geoWithin'] as Map<String, dynamic>,
          ),
  near:
      json['near'] == null
          ? null
          : GeoSpatialNearInput.fromJson(json['near'] as Map<String, dynamic>),
  nearSphere:
      (json['nearSphere'] as List<dynamic>?)?.map((e) => e as String).toList(),
);

Map<String, dynamic> _$GeoSpatialInputToJson(GeoSpatialInput instance) =>
    <String, dynamic>{
      if (instance.geoIntersects case final value?) 'geoIntersects': value,
      if (instance.geoWithin case final value?) 'geoWithin': value,
      if (instance.near case final value?) 'near': value,
      if (instance.nearSphere case final value?) 'nearSphere': value,
    };
