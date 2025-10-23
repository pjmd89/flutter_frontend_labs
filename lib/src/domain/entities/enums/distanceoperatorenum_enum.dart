import "package:json_annotation/json_annotation.dart";
part "distanceoperatorenum_enum.g.dart";

@JsonEnum(alwaysCreate: true)
enum DistanceOperatorEnum {
  @JsonValue("meter")
  meter,
  @JsonValue("kilometer")
  kilometer,
  @JsonValue("miles")
  miles,
}
