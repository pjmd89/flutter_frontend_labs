import "package:json_annotation/json_annotation.dart";
part "labmemberrole_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum LabMemberRole {
  @JsonValue("OWNER")
  oWNER,
  @JsonValue("TECHNICIAN")
  tECHNICIAN,
  @JsonValue("BILLING")
  bILLING,
  @JsonValue("BIOANALYST")
  bIOANALYST,
}
