import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updatelaboratoryinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateLaboratoryInput extends ChangeNotifier {
  String? _id;
  @JsonKey(name: "_id")
  String? get id => _id;
  set id(String? value) {
    _id = value;
    notifyListeners();
  }
  String? _address;
  String? get address => _address;
  set address(String? value) {
    _address = value;
    notifyListeners();
  }
  List<String>? _contactPhoneNumbers;
  List<String>? get contactPhoneNumbers => _contactPhoneNumbers;
  set contactPhoneNumbers(List<String>? value) {
    _contactPhoneNumbers = value;
    notifyListeners();
  }
  UpdateLaboratoryInput({
    String? id,
    String? address,
    List<String>? contactPhoneNumbers,
  }) {
    this.id = id ?? "";
    this.address = address ?? "";
    this.contactPhoneNumbers = contactPhoneNumbers;
  }
  factory UpdateLaboratoryInput.fromJson(Map<String, dynamic> json) => _$UpdateLaboratoryInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateLaboratoryInputToJson(this);
}
