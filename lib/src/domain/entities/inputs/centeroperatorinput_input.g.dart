// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'centeroperatorinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CenterOperatorInput _$CenterOperatorInputFromJson(Map<String, dynamic> json) =>
    CenterOperatorInput(
      lat: json['lat'] as num?,
      lon: json['lon'] as num?,
      radius: json['radius'] as num?,
      radiusOperator: $enumDecodeNullable(
        _$DistanceOperatorEnumEnumMap,
        json['radiusOperator'],
      ),
    );

Map<String, dynamic> _$CenterOperatorInputToJson(
  CenterOperatorInput instance,
) => <String, dynamic>{
  'lat': instance.lat,
  'lon': instance.lon,
  'radius': instance.radius,
  'radiusOperator': _$DistanceOperatorEnumEnumMap[instance.radiusOperator]!,
};

const _$DistanceOperatorEnumEnumMap = {
  DistanceOperatorEnum.meter: 'meter',
  DistanceOperatorEnum.kilometer: 'kilometer',
  DistanceOperatorEnum.miles: 'miles',
};
