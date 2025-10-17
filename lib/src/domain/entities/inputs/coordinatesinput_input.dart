import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "coordinatesinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CoordinatesInput extends ChangeNotifier {
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
  CoordinatesInput({
    num? lat,
    num? lon,
  }) {
    this.lat = lat ?? 0;
    this.lon = lon ?? 0;
  }
  factory CoordinatesInput.fromJson(Map<String, dynamic> json) => _$CoordinatesInputFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesInputToJson(this);
}
