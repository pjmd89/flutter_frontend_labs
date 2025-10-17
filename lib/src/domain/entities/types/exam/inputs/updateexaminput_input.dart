import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updateexaminput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateExamInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  num _baseCost = 0;
  num get baseCost => _baseCost;
  set baseCost(num value) {
    _baseCost = value;
    notifyListeners();
  }
  UpdateExamInput({
    String? id,
    num? baseCost,
  }) {
    this.id = id ?? "";
    this.baseCost = baseCost ?? 0;
  }
  factory UpdateExamInput.fromJson(Map<String, dynamic> json) => _$UpdateExamInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateExamInputToJson(this);
}
