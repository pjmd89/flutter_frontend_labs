import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "centeroperatorinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CenterOperatorInput extends ChangeNotifier {
  num _lat = 0;
  num get lat => _lat;
  set lat(num value) {
    _lat = value;
    notifyListeners();
  }
  num _lon = 0;
  num get lon => _lon;
  set lon(num value) {
    _lon = value;
    notifyListeners();
  }
  num _radius = 0;
  num get radius => _radius;
  set radius(num value) {
    _radius = value;
    notifyListeners();
  }
  DistanceOperatorEnum _radiusOperator = DistanceOperatorEnum.values.first;
  DistanceOperatorEnum get radiusOperator => _radiusOperator;
  set radiusOperator(DistanceOperatorEnum value) {
    _radiusOperator = value;
    notifyListeners();
  }
  CenterOperatorInput({
    num? lat,
    num? lon,
    num? radius,
    DistanceOperatorEnum? radiusOperator,
  }) {
    this.lat = lat ?? 0;
    this.lon = lon ?? 0;
    this.radius = radius ?? 0;
    this.radiusOperator = radiusOperator ?? DistanceOperatorEnum.values.first;
  }
  factory CenterOperatorInput.fromJson(Map<String, dynamic> json) => _$CenterOperatorInputFromJson(json);
  Map<String, dynamic> toJson() => _$CenterOperatorInputToJson(this);
}
