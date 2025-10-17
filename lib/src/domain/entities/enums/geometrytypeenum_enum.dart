import "package:json_annotation/json_annotation.dart";
part "geometrytypeenum_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum GeometryTypeEnum {
  @JsonValue("Point")
  point,
  @JsonValue("LineString")
  lineString,
  @JsonValue("Polygon")
  polygon,
  @JsonValue("MultiPoint")
  multiPoint,
  @JsonValue("MultiLineString")
  multiLineString,
}
