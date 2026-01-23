import "package:json_annotation/json_annotation.dart";
part "resultstatus_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum ResultStatus {
  @JsonValue("PENDING")
  pENDING,
  @JsonValue("INPROGRESS")
  iNPROGRESS,
  @JsonValue("COMPLETED")
  cOMPLETED,
}
