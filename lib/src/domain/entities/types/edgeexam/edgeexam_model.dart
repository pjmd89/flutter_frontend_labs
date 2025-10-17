import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgeexam_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeExam {
  final List<Exam> edges;
  final PageInfo? pageInfo;
  EdgeExam({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeExam.fromJson(Map<String, dynamic> json) => _$EdgeExamFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeExamToJson(this);
}
