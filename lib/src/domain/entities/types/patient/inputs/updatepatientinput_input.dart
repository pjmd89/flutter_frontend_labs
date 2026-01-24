import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updatepatientinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdatePatientInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  String? _firstName;
  String? get firstName => _firstName;
  set firstName(String? value) {
    _firstName = value;
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
  UpdatePatientInput({
    String? id,
    String? firstName,
    String? lastName,
    String? birthDate,
    String? dni,
    String? phone,
    String? email,
    String? address,
  }) {
    this.id = id ?? "";
    // ✅ Usar null en lugar de "" para campos opcionales
    // Esto permite que @JsonSerializable(includeIfNull: false) funcione correctamente
    this.firstName = firstName;
    this.lastName = lastName;
    this.birthDate = birthDate;
    this.dni = dni;
    this.phone = phone;
    this.email = email;
    this.address = address;
  }
  factory UpdatePatientInput.fromJson(Map<String, dynamic> json) => _$UpdatePatientInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePatientInputToJson(this);
}
