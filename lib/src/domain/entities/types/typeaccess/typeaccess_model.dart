import "package:json_annotation/json_annotation.dart";
part "typeaccess_model.g.dart";
@JsonSerializable(includeIfNull: false)
class TypeAccess {
  @JsonKey(name: "_id")
  final String id;
  final String name;
  final List<String> operations;
  TypeAccess({
    this.id = "",
    this.name = "",
    this.operations = const [],
  });
  factory TypeAccess.fromJson(Map<String, dynamic> json) => _$TypeAccessFromJson(json);
  Map<String, dynamic> toJson() => _$TypeAccessToJson(this);
}
