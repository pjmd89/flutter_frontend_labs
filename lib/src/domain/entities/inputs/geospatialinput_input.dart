import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "geospatialinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class GeoSpatialInput extends ChangeNotifier {
  List<String?>? _geoIntersects;
  List<String?>? get geoIntersects => _geoIntersects;
  set geoIntersects(List<String?>? value) {
    _geoIntersects = value;
    notifyListeners();
  }
  GeoSpatialGeoWithinOperatorsInput? _geoWithin;
  GeoSpatialGeoWithinOperatorsInput? get geoWithin => _geoWithin;
  set geoWithin(GeoSpatialGeoWithinOperatorsInput? value) {
    _geoWithin = value;
    notifyListeners();
  }
  GeoSpatialNearInput? _near;
  GeoSpatialNearInput? get near => _near;
  set near(GeoSpatialNearInput? value) {
    _near = value;
    notifyListeners();
  }
  List<String?>? _nearSphere;
  List<String?>? get nearSphere => _nearSphere;
  set nearSphere(List<String?>? value) {
    _nearSphere = value;
    notifyListeners();
  }
  GeoSpatialInput({
    List<String>? geoIntersects,
    GeoSpatialGeoWithinOperatorsInput? geoWithin,
    GeoSpatialNearInput? near,
    List<String>? nearSphere,
  }) {
    this.geoIntersects = geoIntersects;
    this.geoWithin = geoWithin;
    this.near = near;
    this.nearSphere = nearSphere;
  }
  factory GeoSpatialInput.fromJson(Map<String, dynamic> json) => _$GeoSpatialInputFromJson(json);
  Map<String, dynamic> toJson() => _$GeoSpatialInputToJson(this);
}
