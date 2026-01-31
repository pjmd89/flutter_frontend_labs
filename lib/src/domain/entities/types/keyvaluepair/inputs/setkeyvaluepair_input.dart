import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "setkeyvaluepair_input.g.dart";
@JsonSerializable(includeIfNull: false)
class SetKeyValuePair extends ChangeNotifier {
  String _key = "";
  String get key => _key;
  set key(String value) {
    _key = value;
    notifyListeners();
  }
  String _value = "";
  String get value => _value;
  set value(String value) {
    _value = value;
    notifyListeners();
  }
  SetKeyValuePair({
    String? key,
    String? value,
  }) {
    this.key = key ?? "";
    this.value = value ?? "";
  }
  factory SetKeyValuePair.fromJson(Map<String, dynamic> json) => _$SetKeyValuePairFromJson(json);
  Map<String, dynamic> toJson() => _$SetKeyValuePairToJson(this);
}
