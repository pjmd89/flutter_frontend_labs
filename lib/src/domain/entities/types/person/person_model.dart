import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
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
  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
