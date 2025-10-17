import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createcompanyinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateCompanyInput extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
  String? _logo;
  String? get logo => _logo;
  set logo(String? value) {
    _logo = value;
    notifyListeners();
  }
  String _taxID = "";
  String get taxID => _taxID;
  set taxID(String value) {
    _taxID = value;
    notifyListeners();
  }
  CreateLaboratoryInput _laboratoryInfo = CreateLaboratoryInput();
  CreateLaboratoryInput get laboratoryInfo => _laboratoryInfo;
  set laboratoryInfo(CreateLaboratoryInput value) {
    _laboratoryInfo = value;
    notifyListeners();
  }
  CreateCompanyInput({
    String? name,
    String? logo,
    String? taxID,
    CreateLaboratoryInput? laboratoryInfo,
  }) {
    this.name = name ?? "";
    this.logo = logo ?? "";
    this.taxID = taxID ?? "";
    this.laboratoryInfo = laboratoryInfo ?? CreateLaboratoryInput();
  }
  factory CreateCompanyInput.fromJson(Map<String, dynamic> json) => _$CreateCompanyInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateCompanyInputToJson(this);
}
