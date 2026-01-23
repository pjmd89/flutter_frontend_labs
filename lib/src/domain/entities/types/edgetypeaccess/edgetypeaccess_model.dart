import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgetypeaccess_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeTypeAccess {
  final List<TypeAccess> edges;
  final PageInfo? pageInfo;
  EdgeTypeAccess({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeTypeAccess.fromJson(Map<String, dynamic> json) => _$EdgeTypeAccessFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeTypeAccessToJson(this);
}
