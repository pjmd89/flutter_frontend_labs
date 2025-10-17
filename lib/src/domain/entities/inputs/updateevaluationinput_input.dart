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
  List<String?>? _observations;
  List<String?>? get observations => _observations;
  set observations(List<String?>? value) {
    _observations = value;
    notifyListeners();
  }
  List<ExamResultInput>? _resultsByExam;
  List<ExamResultInput>? get resultsByExam => _resultsByExam;
  set resultsByExam(List<ExamResultInput>? value) {
    _resultsByExam = value;
    notifyListeners();
  }
  UpdateEvaluationInput({
    String? id,
    List<String>? observations,
    List<ExamResultInput>? resultsByExam,
  }) {
    this.id = id ?? "";
    this.observations = observations;
    this.resultsByExam = resultsByExam;
  }
  factory UpdateEvaluationInput.fromJson(Map<String, dynamic> json) => _$UpdateEvaluationInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateEvaluationInputToJson(this);
}
