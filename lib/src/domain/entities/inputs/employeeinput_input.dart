import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "../enums/labmemberrole_enum.dart";
part "employeeinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class EmployeeInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  
  LabMemberRole? _role;
  LabMemberRole? get role => _role;
  set role(LabMemberRole? value) {
    _role = value;
    notifyListeners();
  }
  
  EmployeeInput({
    String? id,
    LabMemberRole? role,
  }) {
    this.id = id ?? "";
    this.role = role;
  }
  factory EmployeeInput.fromJson(Map<String, dynamic> json) => _$EmployeeInputFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeInputToJson(this);
}
