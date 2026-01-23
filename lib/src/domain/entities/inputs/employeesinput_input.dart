import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "employeesinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class EmployeesInput extends ChangeNotifier {
  String? _id;
  @JsonKey(name: "_id")
  String? get id => _id;
  set id(String? value) {
    _id = value;
    notifyListeners();
  }
  List<String> _employees = const [];
  List<String> get employees => _employees;
  set employees(List<String> value) {
    _employees = value;
    notifyListeners();
  }
  bool _remove = false;
  bool get remove => _remove;
  set remove(bool value) {
    _remove = value;
    notifyListeners();
  }
  EmployeesInput({
    String? id,
    List<String>? employees,
    bool? remove,
  }) {
    this.id = id ?? "";
    this.employees = employees ?? const [];
    this.remove = remove ?? false;
  }
  factory EmployeesInput.fromJson(Map<String, dynamic> json) => _$EmployeesInputFromJson(json);
  Map<String, dynamic> toJson() => _$EmployeesInputToJson(this);
}
