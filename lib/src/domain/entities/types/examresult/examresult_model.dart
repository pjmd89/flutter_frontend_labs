import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "examresult_model.g.dart";
@JsonSerializable(includeIfNull: false)
class ExamResult {
  final Exam? exam;
  final num cost;
  final List<IndicatorValue> indicatorValues;
  ExamResult({
    this.exam,
    this.cost = 0,
    this.indicatorValues = const [],
  });
  factory ExamResult.fromJson(Map<String, dynamic> json) => _$ExamResultFromJson(json);
  Map<String, dynamic> toJson() => _$ExamResultToJson(this);
}
