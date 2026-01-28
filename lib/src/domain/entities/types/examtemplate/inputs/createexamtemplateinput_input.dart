import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "createexamtemplateinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class CreateExamTemplateInput extends ChangeNotifier {
  String _name = "";
  String get name => _name;
  set name(String value) {
    _name = value;
    notifyListeners();
  }
  String? _description;
  String? get description => _description;
  set description(String? value) {
    _description = value;
    notifyListeners();
  }
  List<CreateExamIndicator> _indicators = const [];
  List<CreateExamIndicator> get indicators => _indicators;
  set indicators(List<CreateExamIndicator> value) {
    _indicators = value;
    notifyListeners();
  }
  CreateExamTemplateInput({
    String? name,
    String? description,
    List<CreateExamIndicator>? indicators,
  }) {
    this.name = name ?? "";
    this.description = description ?? "";
    this.indicators = indicators ?? const [];
  }
  factory CreateExamTemplateInput.fromJson(Map<String, dynamic> json) => _$CreateExamTemplateInputFromJson(json);
  Map<String, dynamic> toJson() => _$CreateExamTemplateInputToJson(this);
}
