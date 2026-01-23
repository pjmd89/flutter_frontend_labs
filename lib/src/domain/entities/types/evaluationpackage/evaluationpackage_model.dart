import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "evaluationpackage_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EvaluationPackage {
  @JsonKey(name: "_id")
  final String id;
  final Patient? patient;
  final List<ExamResult> valuesByExam;
  final ResultStatus? status;
  final String pdfFilepath;
  final int completedAt;
  final String referred;
  final List<String> observations;
  final bool isApproved;
  final BioanalystReview? bioanalystReview;
  final int created;
  final int updated;
  EvaluationPackage({
    this.id = "",
    this.patient,
    this.valuesByExam = const [],
    this.status,
    this.pdfFilepath = "",
    this.completedAt = 0,
    this.referred = "",
    this.observations = const [],
    this.isApproved = false,
    this.bioanalystReview,
    this.created = 0,
    this.updated = 0,
  });
  factory EvaluationPackage.fromJson(Map<String, dynamic> json) => _$EvaluationPackageFromJson(json);
  Map<String, dynamic> toJson() => _$EvaluationPackageToJson(this);
}
