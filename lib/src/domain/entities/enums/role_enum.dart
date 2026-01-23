import "package:json_annotation/json_annotation.dart";
part "role_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum Role {
  @JsonValue("ROOT")
  rOOT,
  @JsonValue("ADMIN")
  aDMIN,
  @JsonValue("USER")
  uSER,
}
