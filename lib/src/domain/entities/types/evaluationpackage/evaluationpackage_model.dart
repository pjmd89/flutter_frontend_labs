import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "evaluationpackage_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EvaluationPackage {
  @JsonKey(name: "_id")
  final String id;
  final List<ExamResult> valuesByExam;
  final ResultStatus? status;
  final String pdfFilepath;
  final String completedAt;
  final String referred;
  final List<String> observations;
  final num? created;
  final num? updated;
  EvaluationPackage({
    this.id = "",
    this.valuesByExam = const [],
    this.status,
    this.pdfFilepath = "",
    this.completedAt = "",
    this.referred = "",
    this.observations = const [],
    this.created,
    this.updated,
  });
  factory EvaluationPackage.fromJson(Map<String, dynamic> json) => _$EvaluationPackageFromJson(json);
  Map<String, dynamic> toJson() => _$EvaluationPackageToJson(this);
}
