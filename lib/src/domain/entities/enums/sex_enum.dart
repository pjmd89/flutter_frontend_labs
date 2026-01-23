import "package:json_annotation/json_annotation.dart";
part "sex_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum Sex {
  @JsonValue("FEMALE")
  fEMALE,
  @JsonValue("MALE")
  mALE,
  @JsonValue("INTERSEX")
  iNTERSEX,
}
