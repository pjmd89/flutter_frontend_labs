import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createexamindicator_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateExamIndicator extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
  ValueType _valueType = ValueType.numeric;
  ValueType get valueType => _valueType;
  set valueType(ValueType value) {
    _valueType = value;
    notifyListeners();
  }
  String? _unit;
  String? get unit => _unit;
  set unit(String? value) {
    _unit = value;
    notifyListeners();
  }
  String? _normalRange;
  String? get normalRange => _normalRange;
  set normalRange(String? value) {
    _normalRange = value;
    notifyListeners();
  }
  CreateExamIndicator({
    String? name,
    ValueType? valueType,
    String? unit,
    String? normalRange,
  }) {
    this.name = name ?? "";
    this.valueType = valueType ?? ValueType.numeric;
    this.unit = unit ?? "";
    this.normalRange = normalRange ?? "";
  }
  factory CreateExamIndicator.fromJson(Map<String, dynamic> json) => _$CreateExamIndicatorFromJson(json);
  Map<String, dynamic> toJson() => _$CreateExamIndicatorToJson(this);
}
