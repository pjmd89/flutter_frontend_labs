import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "approveevaluationinput_input.g.dart";

@JsonSerializable(includeIfNull: false)
class ApproveEvaluationInput extends ChangeNotifier {
  String _id = "";
  
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  
  bool? _isApproved;
  bool? get isApproved => _isApproved;
  set isApproved(bool? value) {
    _isApproved = value;
    notifyListeners();
  }
  
  String? _signatureFilepath;
  String? get signatureFilepath => _signatureFilepath;
  set signatureFilepath(String? value) {
    _signatureFilepath = value;
    notifyListeners();
  }
  
  ApproveEvaluationInput({
    String? id,
    bool? isApproved,
    String? signatureFilepath,
  }) {
    this.id = id ?? "";
    this.isApproved = isApproved ?? true;
    this.signatureFilepath = signatureFilepath;
  }
  
  factory ApproveEvaluationInput.fromJson(Map<String, dynamic> json) => 
      _$ApproveEvaluationInputFromJson(json);
  Map<String, dynamic> toJson() => _$ApproveEvaluationInputToJson(this);
}
