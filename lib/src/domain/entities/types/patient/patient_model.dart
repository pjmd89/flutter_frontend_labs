import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "patient_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Patient {
  @JsonKey(name: "_id")
  final String id;
  final String firstName;
  final String lastName;
  final Sex? sex;
  final String birthDate;
  final String species;
  final String dni;
  final String phone;
  final String email;
  final String address;
  final Laboratory? laboratory;
  final String created;
  final String updated;
  Patient({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.sex,
    this.birthDate = "",
    this.species = "",
    this.dni = "",
    this.phone = "",
    this.email = "",
    this.address = "",
    this.laboratory,
    this.created = "",
    this.updated = "",
  });
  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}
