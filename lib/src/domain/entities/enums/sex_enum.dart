import "package:json_annotation/json_annotation.dart";
part "sex_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum Sex {
  @JsonValue("female")
  female,
  @JsonValue("male")
  male,
  @JsonValue("intersex")
  intersex,
}
