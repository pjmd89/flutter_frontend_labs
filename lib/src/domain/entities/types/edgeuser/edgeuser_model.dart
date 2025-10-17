import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "edgeuser_model.g.dart";
@JsonSerializable(includeIfNull: false)
class EdgeUser {
  final List<User> edges;
  final PageInfo? pageInfo;
  EdgeUser({
    this.edges = const [],
    this.pageInfo,
  });
  factory EdgeUser.fromJson(Map<String, dynamic> json) => _$EdgeUserFromJson(json);
  Map<String, dynamic> toJson() => _$EdgeUserToJson(this);
}
