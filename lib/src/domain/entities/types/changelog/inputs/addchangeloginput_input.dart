import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "addchangeloginput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class AddChangeLogInput extends ChangeNotifier {
  String _version = "";
  String get version => _version;
  set version(String value) {
    _version = value;
    notifyListeners();
  }
  String _date = "";
  String get date => _date;
  set date(String value) {
    _date = value;
    notifyListeners();
  }
  String _description = "";
  String get description => _description;
  set description(String value) {
    _description = value;
    notifyListeners();
  }
  AddChangeLogInput({
    String? version,
    String? date,
    String? description,
  }) {
    this.version = version ?? "";
    this.date = date ?? "";
    this.description = description ?? "";
  }
  factory AddChangeLogInput.fromJson(Map<String, dynamic> json) => _$AddChangeLogInputFromJson(json);
  Map<String, dynamic> toJson() => _$AddChangeLogInputToJson(this);
}
