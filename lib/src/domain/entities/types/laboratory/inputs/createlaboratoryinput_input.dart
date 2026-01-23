import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createlaboratoryinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateLaboratoryInput extends ChangeNotifier {
  String? _companyID;
  String? get companyID => _companyID;
  set companyID(String? value) {
    _companyID = value;
    notifyListeners();
  }
  String _address = "";
  String get address => _address;
  set address(String value) {
    _address = value;
    notifyListeners();
  }
  List<String>? _contactPhoneNumbers;
  List<String>? get contactPhoneNumbers => _contactPhoneNumbers;
  set contactPhoneNumbers(List<String>? value) {
    _contactPhoneNumbers = value;
    notifyListeners();
  }
  CreateLaboratoryInput({
    String? companyID,
    String? address,
    List<String>? contactPhoneNumbers,
  }) {
    this.companyID = companyID;
    this.address = address ?? "";
    this.contactPhoneNumbers = contactPhoneNumbers;
  }
  factory CreateLaboratoryInput.fromJson(Map<String, dynamic> json) => _$CreateLaboratoryInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateLaboratoryInputToJson(this);
}
