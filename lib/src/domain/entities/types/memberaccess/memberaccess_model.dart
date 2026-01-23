import "package:json_annotation/json_annotation.dart";
part "memberaccess_model.g.dart";
@JsonSerializable(includeIfNull: false)
class MemberAccess {
  final String type;
  final List<String> permissions;
  MemberAccess({
    this.type = "",
    this.permissions = const [],
  });
  factory MemberAccess.fromJson(Map<String, dynamic> json) => _$MemberAccessFromJson(json);
  Map<String, dynamic> toJson() => _$MemberAccessToJson(this);
}
