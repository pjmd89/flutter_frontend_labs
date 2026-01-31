import "/src/domain/entities/main.dart";
import "package:flutter/foundation.dart";
import "package:json_annotation/json_annotation.dart";
part "updatepatientinput_input.g.dart";
@JsonSerializable(includeIfNull: false)
class UpdatePatientInput extends ChangeNotifier {
  String _id = "";
  @JsonKey(name: "_id")
  String get id => _id;
  set id(String value) {
    _id = value;
    notifyListeners();
  }
  List<SetKeyValuePair>? _metadata;
  List<SetKeyValuePair>? get metadata => _metadata;
  set metadata(List<SetKeyValuePair>? value) {
    _metadata = value;
    notifyListeners();
  }
  UpdateAnimalPatientInput? _animalData;
  UpdateAnimalPatientInput? get animalData => _animalData;
  set animalData(UpdateAnimalPatientInput? value) {
    _animalData = value;
    notifyListeners();
  }
  UpdatePatientInput({
    String? id,
    List<SetKeyValuePair>? metadata,
    UpdateAnimalPatientInput? animalData,
  }) {
    this.id = id ?? "";
    this.metadata = metadata;
    this.animalData = animalData;
  }
  factory UpdatePatientInput.fromJson(Map<String, dynamic> json) => _$UpdatePatientInputFromJson(json);
  Map<String, dynamic> toJson() => _$UpdatePatientInputToJson(this);
}
