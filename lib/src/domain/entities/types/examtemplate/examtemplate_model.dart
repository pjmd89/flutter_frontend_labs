import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "examtemplate_model.g.dart";
@JsonSerializable(includeIfNull: false)
class ExamTemplate {
  @JsonKey(name: "_id")
  final String id;
  final String name;
  final String description;
  final List<ExamIndicator> indicators;
  final String created;
  final String updated;
  ExamTemplate({
    this.id = "",
    this.name = "",
    this.description = "",
    this.indicators = const [],
    this.created = "",
    this.updated = "",
  });
  factory ExamTemplate.fromJson(Map<String, dynamic> json) => _$ExamTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$ExamTemplateToJson(this);
}
