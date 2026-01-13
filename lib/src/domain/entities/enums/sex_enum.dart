import "package:json_annotation/json_annotation.dart";
part "sex_enum.g.dart";
@JsonEnum(alwaysCreate: true, fieldRename: FieldRename.screamingSnake)
enum Sex {
  female,
  male,
  intersex,
}

// Helper para decodificar valores en minúsculas del backend
Sex? sexFromJson(dynamic value) {
  if (value == null) return null;
  final stringValue = value.toString().toUpperCase();
  
  // Mapeo manual
  switch (stringValue) {
    case 'FEMALE':
      return Sex.female;
    case 'MALE':
      return Sex.male;
    case 'INTERSEX':
      return Sex.intersex;
    default:
      return null;
  }
}
