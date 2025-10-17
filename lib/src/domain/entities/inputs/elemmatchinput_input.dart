import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "elemmatchinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class ElemMatchInput extends ChangeNotifier {
  String? _field;
  String? get field => _field;
  set field(String? value) {
    _field = value;
    notifyListeners();
  }
  String? _fieldMatch;
  String? get fieldMatch => _fieldMatch;
  set fieldMatch(String? value) {
    _fieldMatch = value;
    notifyListeners();
  }
  String? _value;
  String? get value => _value;
  set value(String? value) {
    _value = value;
    notifyListeners();
  }
  KindEnum? _kind;
  KindEnum? get kind => _kind;
  set kind(KindEnum? value) {
    _kind = value;
    notifyListeners();
  }
  ElemMatchInput({
    String? field,
    String? fieldMatch,
    String? value,
    KindEnum? kind,
  }) {
    this.field = field ?? "";
    this.fieldMatch = fieldMatch ?? "";
    this.value = value ?? "";
    this.kind = kind;
  }
  factory ElemMatchInput.fromJson(Map<String, dynamic> json) => _$ElemMatchInputFromJson(json);
  Map<String, dynamic> toJson() => _$ElemMatchInputToJson(this);
}
