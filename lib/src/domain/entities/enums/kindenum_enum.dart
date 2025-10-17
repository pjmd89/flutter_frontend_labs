import "package:json_annotation/json_annotation.dart";
part "kindenum_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum KindEnum {
  @JsonValue("String")
  string,
  @JsonValue("Int")
  int,
  @JsonValue("Float")
  float,
  @JsonValue("Boolean")
  boolean,
  @JsonValue("ID")
  iD,
  @JsonValue("Date")
  date,
  @JsonValue("DateTime")
  dateTime,
  @JsonValue("Age")
  age,
}
