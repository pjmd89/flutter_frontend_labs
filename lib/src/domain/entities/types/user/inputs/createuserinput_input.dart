import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createuserinput_input.g.dart";

@JsonSerializable(includeIfNull: false)
class CreateUserInput extends ChangeNotifier {
  String _firstName = "";
  String get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
    notifyListeners();
  }

  String _lastName = "";
  String get lastName => _lastName;
  set lastName(String value) {
    _lastName = value;
    notifyListeners();
  }

  String _email = "";
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  bool? _isAdmin;
  bool? get isAdmin => _isAdmin;
  set isAdmin(bool? value) {
    _isAdmin = value;
    notifyListeners();
  }

  String? _laboratoryID;
  String? get laboratoryID => _laboratoryID;
  set laboratoryID(String? value) {
    _laboratoryID = value;
    notifyListeners();
  }

  CreateCompanyInput? _companyInfo;
  CreateCompanyInput? get companyInfo => _companyInfo;
  set companyInfo(CreateCompanyInput? value) {
    _companyInfo = value;
    notifyListeners();
  }

  String? _cutOffDate;
  String? get cutOffDate => _cutOffDate;
  set cutOffDate(String? value) {
    _cutOffDate = value;
    notifyListeners();
  }

  num? _fee;
  num? get fee => _fee;
  set fee(num? value) {
    _fee = value;
    notifyListeners();
  }

  CreateUserInput({
    String? firstName,
    String? lastName,
    String? email,
    bool? isAdmin,
    String? laboratoryID,
    CreateCompanyInput? companyInfo,
    String? cutOffDate,
    num? fee,
  }) {
    this.firstName = firstName ?? "";
    this.lastName = lastName ?? "";
    this.email = email ?? "";
    this.isAdmin = isAdmin ?? false;
    this.laboratoryID = laboratoryID ?? "";
    this.companyInfo = companyInfo;
    this.cutOffDate = cutOffDate;
    this.fee = fee ?? 0;
  }
  factory CreateUserInput.fromJson(Map<String, dynamic> json) =>
      _$CreateUserInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateUserInputToJson(this);
}
