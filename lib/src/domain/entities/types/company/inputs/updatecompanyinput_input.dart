import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updatecompanyinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateCompanyInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  String? _name;
  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }
  String? _logo;
  String? get logo => _logo;
  set logo(String? value) {
    _logo = value;
    notifyListeners();
  }
  String? _taxID;
  String? get taxID => _taxID;
  set taxID(String? value) {
    _taxID = value;
    notifyListeners();
  }
  UpdateCompanyInput({
    String? id,
    String? name,
    String? logo,
    String? taxID,
  }) {
    this.id = id ?? "";
    this.name = name ?? "";
    this.logo = logo ?? "";
    this.taxID = taxID ?? "";
  }
  factory UpdateCompanyInput.fromJson(Map<String, dynamic> json) => _$UpdateCompanyInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateCompanyInputToJson(this);
}
