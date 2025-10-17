import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "geospatialnearinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class GeoSpatialNearInput extends ChangeNotifier {
  CoordinatesInput _pointCoordinates = CoordinatesInput();
  CoordinatesInput get pointCoordinates => _pointCoordinates;
  set pointCoordinates(CoordinatesInput value) {
    _pointCoordinates = value;
    notifyListeners();
  }
  num? _maxDistance;
  num? get maxDistance => _maxDistance;
  set maxDistance(num? value) {
    _maxDistance = value;
    notifyListeners();
  }
  DistanceOperatorEnum? _distanceOperator;
  DistanceOperatorEnum? get distanceOperator => _distanceOperator;
  set distanceOperator(DistanceOperatorEnum? value) {
    _distanceOperator = value;
    notifyListeners();
  }
  GeoSpatialNearInput({
    CoordinatesInput? pointCoordinates,
    num? maxDistance,
    DistanceOperatorEnum? distanceOperator,
  }) {
    this.pointCoordinates = pointCoordinates ?? CoordinatesInput();
    this.maxDistance = maxDistance ?? 0;
    this.distanceOperator = distanceOperator;
  }
  factory GeoSpatialNearInput.fromJson(Map<String, dynamic> json) => _$GeoSpatialNearInputFromJson(json);
  Map<String, dynamic> toJson() => _$GeoSpatialNearInputToJson(this);
}
