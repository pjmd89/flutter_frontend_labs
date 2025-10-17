import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "sortinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class SortInput extends ChangeNotifier {
  String _field = "";
  String get field => _field;
  set field(String value) {
    _field = value;
    notifyListeners();
  }
  SortEnum? _order;
  SortEnum? get order => _order;
  set order(SortEnum? value) {
    _order = value;
    notifyListeners();
  }
  SortInput({
    String? field,
    SortEnum? order,
  }) {
    this.field = field ?? "";
    this.order = order;
  }
  factory SortInput.fromJson(Map<String, dynamic> json) => _$SortInputFromJson(json);
  Map<String, dynamic> toJson() => _$SortInputToJson(this);
}
