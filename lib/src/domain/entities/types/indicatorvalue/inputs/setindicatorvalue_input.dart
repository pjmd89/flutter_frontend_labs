import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "setindicatorvalue_input.g.dart";
@JsonSerializable(includeIfNull: false)
class SetIndicatorValue extends ChangeNotifier {
  num _indicatorIndex = 0;
  num get indicatorIndex => _indicatorIndex;
  set indicatorIndex(num value) {
    _indicatorIndex = value;
    notifyListeners();
  }
  String _value = "";
  String get value => _value;
  set value(String value) {
    _value = value;
    notifyListeners();
  }
  SetIndicatorValue({
    num? indicatorIndex,
    String? value,
  }) {
    this.indicatorIndex = indicatorIndex ?? 0;
    this.value = value ?? "";
  }
  factory SetIndicatorValue.fromJson(Map<String, dynamic> json) => _$SetIndicatorValueFromJson(json);
  Map<String, dynamic> toJson() => _$SetIndicatorValueToJson(this);
}
