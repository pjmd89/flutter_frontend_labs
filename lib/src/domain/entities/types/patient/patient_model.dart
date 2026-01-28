import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "patient_model.g.dart";

// Converter para el union type PatientEntity
class PatientEntityConverter implements JsonConverter<dynamic, Map<String, dynamic>?> {
  const PatientEntityConverter();

  @override
  dynamic fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    
    // Mapear aliases de Person a campos normales
    if (json.containsKey('personFirstName')) {
      final normalizedJson = Map<String, dynamic>.from(json);
      normalizedJson['firstName'] = json['personFirstName'];
      normalizedJson['lastName'] = json['personLastName'];
      normalizedJson['sex'] = json['personSex'];
      normalizedJson.remove('personFirstName');
      normalizedJson.remove('personLastName');
      normalizedJson.remove('personSex');
      return Person.fromJson(normalizedJson);
    }
    
    // Mapear aliases de Animal a campos normales
    if (json.containsKey('animalFirstName')) {
      final normalizedJson = Map<String, dynamic>.from(json);
      normalizedJson['firstName'] = json['animalFirstName'];
      normalizedJson['lastName'] = json['animalLastName'];
      normalizedJson['sex'] = json['animalSex'];
      normalizedJson.remove('animalFirstName');
      normalizedJson.remove('animalLastName');
      normalizedJson.remove('animalSex');
      return Animal.fromJson(normalizedJson);
    }
    
    // Fallback: detectar por campos (para compatibilidad)
    if (json.containsKey('dni')) {
      return Person.fromJson(json);
    } else if (json.containsKey('species') || json.containsKey('owner')) {
      return Animal.fromJson(json);
    }
    
    return null;
  }

  @override
  Map<String, dynamic>? toJson(dynamic object) {
    if (object == null) return null;
    
    if (object is Person) {
      return object.toJson();
    } else if (object is Animal) {
      return object.toJson();
    }
    
    return null;
  }
}

@JsonSerializable(includeIfNull: false)
class Patient {
  @JsonKey(name: "_id")
  final String id;
  final PatientType? patientType;
  
  @PatientEntityConverter()
  final dynamic patientData; // Puede ser Person o Animal
  
  final List<KeyValuePair>? metadata;
  final Laboratory? laboratory;
  final int created;
  final int updated;
  
  Patient({
    this.id = "",
    this.patientType,
    this.patientData,
    this.metadata,
    this.laboratory,
    this.created = 0,
    this.updated = 0,
  });
  
  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
  
  // Helper getters
  Person? get asPerson => patientData is Person ? patientData as Person : null;
  Animal? get asAnimal => patientData is Animal ? patientData as Animal : null;
  bool get isPerson => patientData is Person;
  bool get isAnimal => patientData is Animal;
}
