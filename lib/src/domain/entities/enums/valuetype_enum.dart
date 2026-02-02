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
  // Valores en minúsculas para compatibilidad con datos legacy del backend
  @JsonValue("numeric")
  numeric,
  @JsonValue("text")
  text,
  @JsonValue("boolean")
  boolean,
}

// Extension para normalizar valores y facilitar comparaciones
extension ValueTypeExtension on ValueType {
  /// Normaliza el valor del enum a su versión en mayúsculas
  ValueType normalize() {
    switch (this) {
      case ValueType.nUMERIC:
      case ValueType.numeric:
        return ValueType.nUMERIC;
      case ValueType.tEXT:
      case ValueType.text:
        return ValueType.tEXT;
      case ValueType.bOOLEAN:
      case ValueType.boolean:
        return ValueType.bOOLEAN;
    }
  }
  
  /// Retorna el valor del enum en mayúsculas para display
  String get displayValue {
    switch (normalize()) {
      case ValueType.nUMERIC:
        return 'NUMERIC';
      case ValueType.tEXT:
        return 'TEXT';
      case ValueType.bOOLEAN:
        return 'BOOLEAN';
      default:
        return 'TEXT';
    }
  }
  
  /// Verifica si es tipo numérico (incluyendo legacy)
  bool get isNumeric => 
    this == ValueType.nUMERIC || this == ValueType.numeric;
  
  /// Verifica si es tipo texto (incluyendo legacy)
  bool get isText => 
    this == ValueType.tEXT || this == ValueType.text;
  
  /// Verifica si es tipo booleano (incluyendo legacy)
  bool get isBoolean => 
    this == ValueType.bOOLEAN || this == ValueType.boolean;
}
