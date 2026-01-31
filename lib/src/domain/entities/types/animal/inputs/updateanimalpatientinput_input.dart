import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updateanimalpatientinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateAnimalPatientInput extends ChangeNotifier {
  String? _firstName;
  String? get firstName => _firstName;
  set firstName(String? value) {
    _firstName = value;
    notifyListeners();
  }
  String? _species;
  String? get species => _species;
  set species(String? value) {
    _species = value;
    notifyListeners();
  }
  String? _lastName;
  String? get lastName => _lastName;
  set lastName(String? value) {
    _lastName = value;
    notifyListeners();
  }
  String? _birthDate;
  String? get birthDate => _birthDate;
  set birthDate(String? value) {
    _birthDate = value;
    notifyListeners();
  }
  Sex? _sex;
  Sex? get sex => _sex;
  set sex(Sex? value) {
    _sex = value;
    notifyListeners();
  }
  UpdateAnimalPatientInput({
    String? firstName,
    String? species,
    String? lastName,
    String? birthDate,
    Sex? sex,
  }) {
    this.firstName = firstName ?? "";
    this.species = species ?? "";
    this.lastName = lastName ?? "";
    this.birthDate = birthDate ?? "";
    this.sex = sex;
  }
  factory UpdateAnimalPatientInput.fromJson(Map<String, dynamic> json) => _$UpdateAnimalPatientInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateAnimalPatientInputToJson(this);
}
