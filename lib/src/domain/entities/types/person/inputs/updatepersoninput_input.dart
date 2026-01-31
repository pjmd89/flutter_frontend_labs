import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updatepersoninput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdatePersonInput extends ChangeNotifier {
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
  UpdatePersonInput({
    String? id,
    String? firstName,
    String? lastName,
    String? dni,
    String? phone,
    String? email,
    String? address,
    String? birthDate,
    Sex? sex,
  }) {
    this.id = id ?? "";
    this.firstName = firstName ?? "";
    this.lastName = lastName ?? "";
    this.dni = dni ?? "";
    this.phone = phone ?? "";
    this.email = email ?? "";
    this.address = address ?? "";
    this.birthDate = birthDate ?? "";
    this.sex = sex;
  }
  factory UpdatePersonInput.fromJson(Map<String, dynamic> json) => _$UpdatePersonInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePersonInputToJson(this);
}
