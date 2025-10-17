import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updateuserinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateUserInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  String? _firstName;
  String? get firstName => _firstName;
  set firstName(String? value) {
    _firstName = value;
    notifyListeners();
  }
  String? _lastName;
  String? get lastName => _lastName;
  set lastName(String? value) {
    _lastName = value;
    notifyListeners();
  }
  String? _email;
  String? get email => _email;
  set email(String? value) {
    _email = value;
    notifyListeners();
  }
  UpdateUserInput({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
  }) {
    this.id = id ?? "";
    this.firstName = firstName ?? "";
    this.lastName = lastName ?? "";
    this.email = email ?? "";
  }
  factory UpdateUserInput.fromJson(Map<String, dynamic> json) => _$UpdateUserInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateUserInputToJson(this);
}
