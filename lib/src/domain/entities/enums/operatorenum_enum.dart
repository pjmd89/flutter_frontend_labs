import "package:json_annotation/json_annotation.dart";
part "operatorenum_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum OperatorEnum {
  @JsonValue("eq")
  eq,
  @JsonValue("gt")
  gt,
  @JsonValue("gte")
  gte,
  @JsonValue("lt")
  lt,
  @JsonValue("lte")
  lte,
  @JsonValue("ne")
  ne,
  @JsonValue("all")
  all,
  // "in" es palabra reservada, renombrado a "in_"
  @JsonValue("in")
  in_,
  @JsonValue("nin")
  nin,
  @JsonValue("regex")
  regex,
  @JsonValue("size")
  size,
  @JsonValue("mod")
  mod,
  @JsonValue("exists")
  exists,
}
