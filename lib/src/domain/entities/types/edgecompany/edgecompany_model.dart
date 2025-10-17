import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgecompany_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeCompany {
  final List<Company> edges;
  final PageInfo? pageInfo;
  EdgeCompany({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeCompany.fromJson(Map<String, dynamic> json) => _$EdgeCompanyFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeCompanyToJson(this);
}
