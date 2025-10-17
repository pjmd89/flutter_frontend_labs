import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "modinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class ModInput extends ChangeNotifier {
  num? _divisor;
  num? get divisor => _divisor;
  set divisor(num? value) {
    _divisor = value;
    notifyListeners();
  }
  num? _remainder;
  num? get remainder => _remainder;
  set remainder(num? value) {
    _remainder = value;
    notifyListeners();
  }
  ModInput({
    num? divisor,
    num? remainder,
  }) {
    this.divisor = divisor ?? 0;
    this.remainder = remainder ?? 0;
  }
  factory ModInput.fromJson(Map<String, dynamic> json) => _$ModInputFromJson(json);
  Map<String, dynamic> toJson() => _$ModInputToJson(this);
}
