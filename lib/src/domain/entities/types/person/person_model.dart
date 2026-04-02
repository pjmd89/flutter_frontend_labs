import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
import "/src/domain/entities/enums/sex_enum.dart";
part "person_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Person {
  @JsonKey(name: "_id")
  final String id;
  final String firstName;
  final String lastName;
  final String dni;
  final String phone;
  final String email;
  final String address;
  final int birthDate;
  @JsonKey(fromJson: _sexFromJson, toJson: _sexToJson)
  final Sex? sex;
  final Laboratory? laboratory;
  final int created;
  final int updated;
  Person({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.dni = "",
    this.phone = "",
    this.email = "",
    this.address = "",
    this.birthDate = 0,
    this.sex,
    this.laboratory,
    this.created = 0,
    this.updated = 0,
  });
  factory Person.fromJson(Map<String, dynamic> json) {
    // Normalizar sex vacío para evitar fallos de enum decode
    final normalized = Map<String, dynamic>.from(json);
    final sexValue = normalized['sex'];
    if (sexValue is String && sexValue.isEmpty) {
      normalized.remove('sex');
    }

    return _$PersonFromJson(normalized);
  }
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

// Mapa local para conversión de Sex enum
const _sexEnumMap = {
  'FEMALE': Sex.fEMALE,
  'MALE': Sex.mALE,
  'INTERSEX': Sex.iNTERSEX,
};

const _sexEnumMapReverse = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};

// Permite que sex venga vacío o null sin romper el decode
Sex? _sexFromJson(String? value) {
  if (value == null || value.isEmpty) return null;
  try {
    return _sexEnumMap[value];
  } catch (_) {
    return null;
  }
}

String? _sexToJson(Sex? sex) {
  return sex == null ? null : _sexEnumMapReverse[sex];
}
