import "package:json_annotation/json_annotation.dart";
part "patienttype_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum PatientType {
  @JsonValue("HUMAN")
  hUMAN,
  @JsonValue("ANIMAL")
  aNIMAL,
}
