import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "uploadinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class uploadInput extends ChangeNotifier {
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
  String _folder = "";
  String get folder => _folder;
  set folder(String value) {
    _folder = value;
    notifyListeners();
  }
  String _file = "";
  String get file => _file;
  set file(String value) {
    _file = value;
    notifyListeners();
  }
  bool? _isThumb;
  bool? get isThumb => _isThumb;
  set isThumb(bool? value) {
    _isThumb = value;
    notifyListeners();
  }
  uploadInput({
    String? name,
    num? size,
    String? type,
    String? folder,
    String? file,
    bool? isThumb,
  }) {
    this.name = name ?? "";
    this.size = size ?? 0;
    this.type = type ?? "";
    this.folder = folder ?? "";
    this.file = file ?? "";
    this.isThumb = isThumb ?? false;
  }
  factory uploadInput.fromJson(Map<String, dynamic> json) => _$uploadInputFromJson(json);
  Map<String, dynamic> toJson() => _$uploadInputToJson(this);
}
