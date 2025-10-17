// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geospatialnearinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoSpatialNearInput _$GeoSpatialNearInputFromJson(Map<String, dynamic> json) =>
    GeoSpatialNearInput(
      pointCoordinates:
          json['pointCoordinates'] == null
              ? null
              : CoordinatesInput.fromJson(
                json['pointCoordinates'] as Map<String, dynamic>,
              ),
      maxDistance: json['maxDistance'] as num?,
      distanceOperator: $enumDecodeNullable(
        _$DistanceOperatorEnumEnumMap,
        json['distanceOperator'],
      ),
    );

Map<String, dynamic> _$GeoSpatialNearInputToJson(
  GeoSpatialNearInput instance,
) => <String, dynamic>{
  'pointCoordinates': instance.pointCoordinates,
  if (instance.maxDistance case final value?) 'maxDistance': value,
  if (_$DistanceOperatorEnumEnumMap[instance.distanceOperator]
      case final value?)
    'distanceOperator': value,
};

const _$DistanceOperatorEnumEnumMap = {
  DistanceOperatorEnum.meter: 'meter',
  DistanceOperatorEnum.kilometer: 'kilometer',
  DistanceOperatorEnum.miles: 'miles',
};
