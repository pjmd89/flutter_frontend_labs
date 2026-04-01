import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
import "employeeinput_input.dart";
part "employeesinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class LaboratoryEmployeesInput extends ChangeNotifier {
  String? _id;
  @JsonKey(name: "_id")
  String? get id => _id;
  set id(String? value) {
    _id = value;
    notifyListeners();
  }
  List<EmployeeInput> _employees = const [];
  List<EmployeeInput> get employees => _employees;
  set employees(List<EmployeeInput> value) {
    _employees = value;
    notifyListeners();
  }
  bool _remove = false;
  bool get remove => _remove;
  set remove(bool value) {
    _remove = value;
    notifyListeners();
  }
  LaboratoryEmployeesInput({
    String? id,
    List<EmployeeInput>? employees,
    bool? remove,
  }) {
    this.id = id ?? "";
    this.employees = employees ?? const [];
    this.remove = remove ?? false;
  }
  factory LaboratoryEmployeesInput.fromJson(Map<String, dynamic> json) => _$LaboratoryEmployeesInputFromJson(json);
  Map<String, dynamic> toJson() => _$LaboratoryEmployeesInputToJson(this);
}
