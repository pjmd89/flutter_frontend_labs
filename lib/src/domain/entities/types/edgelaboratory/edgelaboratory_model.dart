import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgelaboratory_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeLaboratory {
  final List<Laboratory> edges;
  final PageInfo? pageInfo;
  EdgeLaboratory({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeLaboratory.fromJson(Map<String, dynamic> json) => _$EdgeLaboratoryFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeLaboratoryToJson(this);
}
