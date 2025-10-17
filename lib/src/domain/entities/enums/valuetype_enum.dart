import "package:json_annotation/json_annotation.dart";
part "valuetype_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum ValueType {
  @JsonValue("numeric")
  numeric,
  @JsonValue("text")
  text,
  @JsonValue("boolean")
  boolean,
}
