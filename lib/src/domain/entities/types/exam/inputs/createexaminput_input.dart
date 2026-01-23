import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createexaminput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateExamInput extends ChangeNotifier {
  String _template = "";
  String get template => _template;
  set template(String value) {
    _template = value;
    notifyListeners();
  }
  String? _laboratory;
  String? get laboratory => _laboratory;
  set laboratory(String? value) {
    _laboratory = value;
    notifyListeners();
  }
  num _baseCost = 0;
  num get baseCost => _baseCost;
  set baseCost(num value) {
    _baseCost = value;
    notifyListeners();
  }
  CreateExamInput({
    String? template,
    String? laboratory,
    num? baseCost,
  }) {
    this.template = template ?? "";
    this.laboratory = laboratory ?? "";
    this.baseCost = baseCost ?? 0;
  }
  factory CreateExamInput.fromJson(Map<String, dynamic> json) => _$CreateExamInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateExamInputToJson(this);
}
