import "package:json_annotation/json_annotation.dart";
part "sortenum_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum SortEnum {
  @JsonValue("asc")
  asc,
  @JsonValue("desc")
  desc,
}
