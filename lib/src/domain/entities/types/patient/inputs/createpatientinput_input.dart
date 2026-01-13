import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createpatientinput_input.g.dart";
@JsonSerializable(includeIfNull: true)
class CreatePatientInput extends ChangeNotifier {
  String _firstName = "";
  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }
  String? _lastName;
  String? get lastName => _lastName;
  set lastName(String? value) {
    _lastName = value;
    notifyListeners();
  }
  Sex _sex = Sex.values.first;
  Sex get sex => _sex;
  set sex(Sex value) {
    _sex = value;
    notifyListeners();
  }
  PatientType _patientType = PatientType.human;
  PatientType get patientType => _patientType;
  set patientType(PatientType value) {
    _patientType = value;
    notifyListeners();
  }
  String? _birthDate;
  String? get birthDate => _birthDate;
  set birthDate(String? value) {
    _birthDate = value;
    notifyListeners();
  }
  String? _species;
  String? get species => _species;
  set species(String? value) {
    _species = value;
    notifyListeners();
  }
  String? _dni;
  String? get dni => _dni;
  set dni(String? value) {
    _dni = value;
    notifyListeners();
  }
  String? _phone;
  String? get phone => _phone;
  set phone(String? value) {
    _phone = value;
    notifyListeners();
  }
  String? _email;
  String? get email => _email;
  set email(String? value) {
    _email = value;
    notifyListeners();
  }
  String? _address;
  String? get address => _address;
  set address(String? value) {
    _address = value;
    notifyListeners();
  }
  String _laboratory = "";
  String get laboratory => _laboratory;
  set laboratory(String value) {
    _laboratory = value;
    notifyListeners();
  }
  CreatePatientInput({
    String? firstName,
    String? lastName,
    Sex? sex,
    PatientType? patientType,
    String? birthDate,
    String? species,
    String? dni,
    String? phone,
    String? email,
    String? address,
    String? laboratory,
  }) {
    this.firstName = firstName ?? "";
    this.lastName = lastName ?? "";
    this.sex = sex ?? Sex.values.first;
    this.patientType = patientType ?? PatientType.human;
    this.birthDate = birthDate ?? "";
    this.species = species ?? "";
    this.dni = dni ?? "";
    this.phone = phone ?? "";
    this.email = email ?? "";
    this.address = address ?? "";
    this.laboratory = laboratory ?? "";
  }
  factory CreatePatientInput.fromJson(Map<String, dynamic> json) => _$CreatePatientInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreatePatientInputToJson(this);
}
