import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "checkuploadinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CheckUploadInput extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
  num _size = 0;
  num get size => _size;
  set size(num value) {
    _size = value;
    notifyListeners();
  }
  String _type = "";
  String get type => _type;
  set type(String value) {
    _type = value;
    notifyListeners();
  }
  CheckUploadInput({
    String? name,
    num? size,
    String? type,
  }) {
    this.name = name ?? "";
    this.size = size ?? 0;
    this.type = type ?? "";
  }
  factory CheckUploadInput.fromJson(Map<String, dynamic> json) => _$CheckUploadInputFromJson(json);
  Map<String, dynamic> toJson() => _$CheckUploadInputToJson(this);
}
