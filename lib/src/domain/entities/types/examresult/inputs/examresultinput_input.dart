import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "examresultinput_input.g.dart";

@JsonSerializable(includeIfNull: false)
class ExamResultInput extends ChangeNotifier {
  String _exam = "";
  String get exam => _exam;
  set exam(String value) {
    _exam = value;
    notifyListeners();
  }

  List<SetIndicatorValue> _indicatorValues = const [];
  List<SetIndicatorValue> get indicatorValues => _indicatorValues;
  set indicatorValues(List<SetIndicatorValue> value) {
    _indicatorValues = value;
    notifyListeners();
  }

  ExamResultInput({
    String? exam,
    List<SetIndicatorValue>? indicatorValues,
  }) {
    this.exam = exam ?? "";
    this.indicatorValues = indicatorValues ?? const [];
  }

  factory ExamResultInput.fromJson(Map<String, dynamic> json) => _$ExamResultInputFromJson(json);
  Map<String, dynamic> toJson() => _$ExamResultInputToJson(this);
}

