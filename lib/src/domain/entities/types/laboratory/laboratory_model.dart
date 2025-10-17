import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "laboratory_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Laboratory {
  @JsonKey(name: "_id")
  final String id;
  final Company? company;
  final EdgeUser? employees;
  final String address;
  final List<String> contactPhoneNumbers;
  final String created;
  final String updated;
  Laboratory({
    this.id = "",
    this.company,
    this.employees,
    this.address = "",
    this.contactPhoneNumbers = const [],
    this.created = "",
    this.updated = "",
  });
  factory Laboratory.fromJson(Map<String, dynamic> json) => _$LaboratoryFromJson(json);
  Map<String, dynamic> toJson() => _$LaboratoryToJson(this);
}
