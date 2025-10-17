import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "valueinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class ValueInput extends ChangeNotifier {
  String? _value;
  String? get value => _value;
  set value(String? value) {
    _value = value;
    notifyListeners();
  }
  List<String?>? _values;
  List<String?>? get values => _values;
  set values(List<String?>? value) {
    _values = value;
    notifyListeners();
  }
  KindEnum? _kind;
  KindEnum? get kind => _kind;
  set kind(KindEnum? value) {
    _kind = value;
    notifyListeners();
  }
  OperatorEnum? _operator;
  OperatorEnum? get operator => _operator;
  set operator(OperatorEnum? value) {
    _operator = value;
    notifyListeners();
  }
  OptionsRegexEnum? _regexOption;
  OptionsRegexEnum? get regexOption => _regexOption;
  set regexOption(OptionsRegexEnum? value) {
    _regexOption = value;
    notifyListeners();
  }
  ModInput? _modOption;
  ModInput? get modOption => _modOption;
  set modOption(ModInput? value) {
    _modOption = value;
    notifyListeners();
  }
  ValueInput({
    String? value,
    List<String>? values,
    KindEnum? kind,
    OperatorEnum? operator,
    OptionsRegexEnum? regexOption,
    ModInput? modOption,
  }) {
    this.value = value ?? "";
    this.values = values;
    this.kind = kind;
    this.operator = operator;
    this.regexOption = regexOption;
    this.modOption = modOption;
  }
  factory ValueInput.fromJson(Map<String, dynamic> json) => _$ValueInputFromJson(json);
  Map<String, dynamic> toJson() => _$ValueInputToJson(this);
}
