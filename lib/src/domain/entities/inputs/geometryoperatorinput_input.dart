import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "geometryoperatorinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class GeometryOperatorInput extends ChangeNotifier {
  GeometryTypeEnum _type = GeometryTypeEnum.values.first;
  GeometryTypeEnum get type => _type;
  set type(GeometryTypeEnum value) {
    _type = value;
    notifyListeners();
  }
  List<CoordinatesInput> _coordinates = const [];
  List<CoordinatesInput> get coordinates => _coordinates;
  set coordinates(List<CoordinatesInput> value) {
    _coordinates = value;
    notifyListeners();
  }
  GeometryOperatorInput({
    GeometryTypeEnum? type,
    List<CoordinatesInput>? coordinates,
  }) {
    this.type = type ?? GeometryTypeEnum.values.first;
    this.coordinates = coordinates ?? const [];
  }
  factory GeometryOperatorInput.fromJson(Map<String, dynamic> json) => _$GeometryOperatorInputFromJson(json);
  Map<String, dynamic> toJson() => _$GeometryOperatorInputToJson(this);
}
