import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createinvoiceinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateInvoiceInput extends ChangeNotifier {
  String _patient = "";
  String get patient => _patient;
  set patient(String value) {
    _patient = value;
    notifyListeners();
  }
  List<String> _examIDs = const [];
  List<String> get examIDs => _examIDs;
  set examIDs(List<String> value) {
    _examIDs = value;
    notifyListeners();
  }
  String? _referred;
  String? get referred => _referred;
  set referred(String? value) {
    _referred = value;
    notifyListeners();
  }
  InvoiceKind _kind = InvoiceKind.values.first;
  InvoiceKind get kind => _kind;
  set kind(InvoiceKind value) {
    _kind = value;
    notifyListeners();
  }
  String _billTo = "";
  String get billTo => _billTo;
  set billTo(String value) {
    _billTo = value;
    notifyListeners();
  }
  CreateInvoiceInput({
    String? patient,
    List<String>? examIDs,
    String? referred,
    InvoiceKind? kind,
    String? billTo,
  }) {
    this.patient = patient ?? "";
    this.examIDs = examIDs ?? const [];
    this.referred = referred ?? "";
    this.kind = kind ?? InvoiceKind.values.first;
    this.billTo = billTo ?? "";
  }
  factory CreateInvoiceInput.fromJson(Map<String, dynamic> json) => _$CreateInvoiceInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateInvoiceInputToJson(this);
}
