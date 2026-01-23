import "package:json_annotation/json_annotation.dart";
part "invoicekind_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum InvoiceKind {
  @JsonValue("INVOICE")
  iNVOICE,
  @JsonValue("CREDIT_NOTE")
  cREDIT_NOTE,
}
