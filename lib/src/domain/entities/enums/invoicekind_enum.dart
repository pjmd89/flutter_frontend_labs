import "package:json_annotation/json_annotation.dart";
part "invoicekind_enum.g.dart";
@JsonEnum(alwaysCreate: true)
enum InvoiceKind {
  @JsonValue("INVOICE")
  invoice,
  @JsonValue("CREDIT_NOTE")
  creditNote,
}
