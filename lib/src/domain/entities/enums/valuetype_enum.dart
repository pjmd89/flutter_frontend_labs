import "package:json_annotation/json_annotation.dart";
part "valuetype_enum.g.dart";

// Enum para tipos de valores de indicadores de examen
// Acepta valores en mayúsculas Y minúsculas por compatibilidad con backend
@JsonEnum(alwaysCreate: true)
enum ValueType {
  // Valores en mayúsculas
  @JsonValue("NUMERIC")
  nUMERIC,
  @JsonValue("TEXT")
  tEXT,
  @JsonValue("BOOLEAN")
  bOOLEAN,
  // Valores en minúsculas (compatibilidad backend)
  @JsonValue("numeric")
  numeric,
  @JsonValue("text")
  text,
  @JsonValue("boolean")
  boolean,
}
