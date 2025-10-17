import "package:json_annotation/json_annotation.dart";
part "role_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum Role {
  @JsonValue("root")
  root,
  @JsonValue("admin")
  admin,
  @JsonValue("owner")
  owner,
  @JsonValue("technician")
  technician,
}
