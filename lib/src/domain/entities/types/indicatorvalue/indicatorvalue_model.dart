import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "indicatorvalue_model.g.dart";
@JsonSerializable(includeIfNull: false)
class IndicatorValue {
  final ExamIndicator? indicator;
  final String value;
  IndicatorValue({
    this.indicator,
    this.value = "",
  });
  factory IndicatorValue.fromJson(Map<String, dynamic> json) => _$IndicatorValueFromJson(json);
  Map<String, dynamic> toJson() => _$IndicatorValueToJson(this);
}
