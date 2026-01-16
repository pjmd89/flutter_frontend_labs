import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updateevaluationinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateEvaluationInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  List<String>? _observations;
  List<String>? get observations => _observations;
  set observations(List<String>? value) {
    _observations = value;
    notifyListeners();
  }
  List<ExamResultInput>? _valuesByExam;
  List<ExamResultInput>? get valuesByExam => _valuesByExam;
  set valuesByExam(List<ExamResultInput>? value) {
    _valuesByExam = value;
    notifyListeners();
  }
  bool? _allResultsCompleted;
  bool? get allResultsCompleted => _allResultsCompleted;
  set allResultsCompleted(bool? value) {
    _allResultsCompleted = value;
    notifyListeners();
  }
  UpdateEvaluationInput({
    String? id,
    List<String>? observations,
    List<ExamResultInput>? valuesByExam,
    bool? allResultsCompleted,
  }) {
    this.id = id ?? "";
    this.observations = observations;
    this.valuesByExam = valuesByExam;
    this.allResultsCompleted = allResultsCompleted;
  }
  factory UpdateEvaluationInput.fromJson(Map<String, dynamic> json) => _$UpdateEvaluationInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateEvaluationInputToJson(this);
}
