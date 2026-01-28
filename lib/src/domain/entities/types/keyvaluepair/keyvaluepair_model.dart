import "package:json_annotation/json_annotation.dart";
part "keyvaluepair_model.g.dart";
@JsonSerializable(includeIfNull: false)
class KeyValuePair {
  final String key;
  final String value;
  KeyValuePair({
    this.key = "",
    this.value = "",
  });
  factory KeyValuePair.fromJson(Map<String, dynamic> json) => _$KeyValuePairFromJson(json);
  Map<String, dynamic> toJson() => _$KeyValuePairToJson(this);
}
