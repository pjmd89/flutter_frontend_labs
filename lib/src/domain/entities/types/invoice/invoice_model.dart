import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "invoice_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Invoice {
  @JsonKey(name: "_id")
  final String id;
  final Patient? patient;
  final num totalAmount;
  final String orderID;
  final PaymentStatus paymentStatus;
  final Laboratory? laboratory;
  final EvaluationPackage? evaluationPackage;
  final num? created;
  final num? updated;
  Invoice({
    this.id = "",
    this.patient,
    this.totalAmount = 0,
    this.orderID = "",
    this.paymentStatus = PaymentStatus.paid,
    this.laboratory,
    this.evaluationPackage,
    this.created,
    this.updated,
  });
  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
