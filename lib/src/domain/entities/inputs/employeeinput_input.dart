import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
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
  EmployeeInput({
    String? id,
  }) {
    this.id = id ?? "";
  }
  factory EmployeeInput.fromJson(Map<String, dynamic> json) => _$EmployeeInputFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeeInputToJson(this);
}
