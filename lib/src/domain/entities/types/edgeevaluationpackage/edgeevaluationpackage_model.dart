import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgeevaluationpackage_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeEvaluationPackage {
  final List<EvaluationPackage> edges;
  final PageInfo? pageInfo;
  EdgeEvaluationPackage({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeEvaluationPackage.fromJson(Map<String, dynamic> json) => _$EdgeEvaluationPackageFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeEvaluationPackageToJson(this);
}
