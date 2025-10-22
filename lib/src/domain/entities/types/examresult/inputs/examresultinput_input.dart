import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "examresultinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class ExamResultInput extends ChangeNotifier {
  String _examID = "";
  String get examID => _examID;
  set examID(String value) {
    _examID = value;
    notifyListeners();
  }
  List<String> _resultValues = const [];
  List<String> get resultValues => _resultValues;
  set resultValues(List<String> value) {
    _resultValues = value;
    notifyListeners();
  }
  ExamResultInput({
    String? examID,
    List<String>? resultValues,
  }) {
    this.examID = examID ?? "";
    this.resultValues = resultValues ?? const [];
  }
  factory ExamResultInput.fromJson(Map<String, dynamic> json) => _$ExamResultInputFromJson(json);
  Map<String, dynamic> toJson() => _$ExamResultInputToJson(this);
}
