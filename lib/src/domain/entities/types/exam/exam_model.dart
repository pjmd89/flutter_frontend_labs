import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "exam_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Exam {
  @JsonKey(name: "_id")
  final String id;
  final ExamTemplate? template;
  final Laboratory? laboratory;
  final num baseCost;
  final String created;
  final String updated;
  Exam({
    this.id = "",
    this.template,
    this.laboratory,
    this.baseCost = 0,
    this.created = "",
    this.updated = "",
  });
  factory Exam.fromJson(Map<String, dynamic> json) => _$ExamFromJson(json);
  Map<String, dynamic> toJson() => _$ExamToJson(this);
}
