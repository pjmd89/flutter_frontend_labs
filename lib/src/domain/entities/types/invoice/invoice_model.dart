import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "invoice_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Invoice {
  @JsonKey(name: "_id")
  final String id;
  final Patient? patient;
  final ResponsibleParty? billTo;
  final num totalAmount;
  final String orderID;
  final PaymentStatus? paymentStatus;
  final InvoiceKind? kind;
  final Laboratory? laboratory;
  final EvaluationPackage? evaluationPackage;
  final int created;
  final int updated;
  Invoice({
    this.id = "",
    this.patient,
    this.billTo,
    this.totalAmount = 0,
    this.orderID = "",
    this.paymentStatus,
    this.kind,
    this.laboratory,
    this.evaluationPackage,
    this.created = 0,
    this.updated = 0,
  });
  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
