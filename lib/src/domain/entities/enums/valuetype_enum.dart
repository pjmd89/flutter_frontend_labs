import "package:json_annotation/json_annotation.dart";
part "valuetype_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum ValueType {
  @JsonValue("NUMERIC")
  nUMERIC,
  @JsonValue("TEXT")
  tEXT,
  @JsonValue("BOOLEAN")
  bOOLEAN,
}
