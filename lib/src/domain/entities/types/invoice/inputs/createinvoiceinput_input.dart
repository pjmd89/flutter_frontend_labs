import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createinvoiceinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateInvoiceInput extends ChangeNotifier {
  String _patientID = "";
  String get patientID => _patientID;
  set patientID(String value) {
    _patientID = value;
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
  CreateInvoiceInput({
    String? patientID,
    List<String>? examIDs,
    String? referred,
  }) {
    this.patientID = patientID ?? "";
    this.examIDs = examIDs ?? const [];
    this.referred = referred ?? "";
  }
  factory CreateInvoiceInput.fromJson(Map<String, dynamic> json) => _$CreateInvoiceInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateInvoiceInputToJson(this);
}
