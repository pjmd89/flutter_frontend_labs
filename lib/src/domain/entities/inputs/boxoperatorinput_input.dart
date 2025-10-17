import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "boxoperatorinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class BoxOperatorInput extends ChangeNotifier {
  num _bottomLeft = 0;
  num get bottomLeft => _bottomLeft;
  set bottomLeft(num value) {
    _bottomLeft = value;
    notifyListeners();
  }
  num _upperRight = 0;
  num get upperRight => _upperRight;
  set upperRight(num value) {
    _upperRight = value;
    notifyListeners();
  }
  BoxOperatorInput({
    num? bottomLeft,
    num? upperRight,
  }) {
    this.bottomLeft = bottomLeft ?? 0;
    this.upperRight = upperRight ?? 0;
  }
  factory BoxOperatorInput.fromJson(Map<String, dynamic> json) => _$BoxOperatorInputFromJson(json);
  Map<String, dynamic> toJson() => _$BoxOperatorInputToJson(this);
}
