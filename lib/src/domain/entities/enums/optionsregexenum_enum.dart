import "package:json_annotation/json_annotation.dart";
part "optionsregexenum_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum OptionsRegexEnum {
  @JsonValue("i")
  i,
  @JsonValue("m")
  m,
  @JsonValue("x")
  x,
  @JsonValue("s")
  s,
}
