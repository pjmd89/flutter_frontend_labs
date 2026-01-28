import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updateexamtemplateinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdateExamTemplateInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  String? _name;
  String? get name => _name;
  set name(String? value) {
    _name = value;
    notifyListeners();
  }
  String? _description;
  String? get description => _description;
  set description(String? value) {
    _description = value;
    notifyListeners();
  }
  List<CreateExamIndicator>? _indicators;
  List<CreateExamIndicator>? get indicators => _indicators;
  set indicators(List<CreateExamIndicator>? value) {
    _indicators = value;
    notifyListeners();
  }
  UpdateExamTemplateInput({
    String? id,
    String? name,
    String? description,
    List<CreateExamIndicator>? indicators,
  }) {
    this.id = id ?? "";
    this.name = name ?? "";
    this.description = description ?? "";
    this.indicators = indicators;
  }
  factory UpdateExamTemplateInput.fromJson(Map<String, dynamic> json) => _$UpdateExamTemplateInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateExamTemplateInputToJson(this);
}
