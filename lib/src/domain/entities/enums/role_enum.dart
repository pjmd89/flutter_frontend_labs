import "package:json_annotation/json_annotation.dart";
part "role_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum Role {
  @JsonValue("ROOT")
  root,
  @JsonValue("ADMIN")
  admin,
  @JsonValue("OWNER")
  owner,
  @JsonValue("TECHNICIAN")
  technician,
  @JsonValue("BILLING")
  billing,
}
