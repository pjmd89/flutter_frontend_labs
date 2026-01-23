import "package:json_annotation/json_annotation.dart";
part "paymentstatus_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum PaymentStatus {
  @JsonValue("PAID")
  pAID,
  @JsonValue("PENDING")
  pENDING,
  @JsonValue("CANCELED")
  cANCELED,
}
