import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgelabmembershipinfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeLabMembershipInfo {
  final List<LabMembershipInfo> edges;
  final PageInfo? pageInfo;
  EdgeLabMembershipInfo({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeLabMembershipInfo.fromJson(Map<String, dynamic> json) => _$EdgeLabMembershipInfoFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeLabMembershipInfoToJson(this);
}
