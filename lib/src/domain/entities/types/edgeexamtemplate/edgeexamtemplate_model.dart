import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgeexamtemplate_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeExamTemplate {
  final List<ExamTemplate> edges;
  final PageInfo? pageInfo;
  EdgeExamTemplate({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeExamTemplate.fromJson(Map<String, dynamic> json) => _$EdgeExamTemplateFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeExamTemplateToJson(this);
}
