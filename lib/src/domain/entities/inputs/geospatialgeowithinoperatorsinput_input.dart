import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "geospatialgeowithinoperatorsinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class GeoSpatialGeoWithinOperatorsInput extends ChangeNotifier {
  BoxOperatorInput? _box;
  BoxOperatorInput? get box => _box;
  set box(BoxOperatorInput? value) {
    _box = value;
    notifyListeners();
  }
  CenterOperatorInput? _center;
  CenterOperatorInput? get center => _center;
  set center(CenterOperatorInput? value) {
    _center = value;
    notifyListeners();
  }
  CenterOperatorInput? _centerSphere;
  CenterOperatorInput? get centerSphere => _centerSphere;
  set centerSphere(CenterOperatorInput? value) {
    _centerSphere = value;
    notifyListeners();
  }
  GeometryOperatorInput? _geometry;
  GeometryOperatorInput? get geometry => _geometry;
  set geometry(GeometryOperatorInput? value) {
    _geometry = value;
    notifyListeners();
  }
  List<CoordinatesInput?>? _polygon;
  List<CoordinatesInput?>? get polygon => _polygon;
  set polygon(List<CoordinatesInput?>? value) {
    _polygon = value;
    notifyListeners();
  }
  GeoSpatialGeoWithinOperatorsInput({
    BoxOperatorInput? box,
    CenterOperatorInput? center,
    CenterOperatorInput? centerSphere,
    GeometryOperatorInput? geometry,
    List<CoordinatesInput>? polygon,
  }) {
    this.box = box;
    this.center = center;
    this.centerSphere = centerSphere;
    this.geometry = geometry;
    this.polygon = polygon;
  }
  factory GeoSpatialGeoWithinOperatorsInput.fromJson(Map<String, dynamic> json) => _$GeoSpatialGeoWithinOperatorsInputFromJson(json);
  Map<String, dynamic> toJson() => _$GeoSpatialGeoWithinOperatorsInputToJson(this);
}
