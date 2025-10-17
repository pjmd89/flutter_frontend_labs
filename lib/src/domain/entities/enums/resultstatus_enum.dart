import "package:json_annotation/json_annotation.dart";
part "resultstatus_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum ResultStatus {
  @JsonValue("pending")
  pending,
  @JsonValue("inProgress")
  inProgress,
  @JsonValue("completed")
  completed,
}
