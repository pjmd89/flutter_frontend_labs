import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "animal_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Animal {
  final String firstName;
  final String species;
  final String lastName;
  final int birthDate;
  final Sex? sex;
  Animal({
    this.firstName = "",
    this.species = "",
    this.lastName = "",
    this.birthDate = 0,
    this.sex,
  });
  factory Animal.fromJson(Map<String, dynamic> json) => _$AnimalFromJson(json);
  Map<String, dynamic> toJson() => _$AnimalToJson(this);
}
