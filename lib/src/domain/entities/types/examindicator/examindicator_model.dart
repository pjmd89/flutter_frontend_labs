import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "examindicator_model.g.dart";
@JsonSerializable(includeIfNull: false)
class ExamIndicator {
  final String name;
  final ValueType? valueType;
  final String unit;
  final String normalRange;
  ExamIndicator({
    this.name = "",
    this.valueType,
    this.unit = "",
    this.normalRange = "",
  });
  factory ExamIndicator.fromJson(Map<String, dynamic> json) => _$ExamIndicatorFromJson(json);
  Map<String, dynamic> toJson() => _$ExamIndicatorToJson(this);
}
