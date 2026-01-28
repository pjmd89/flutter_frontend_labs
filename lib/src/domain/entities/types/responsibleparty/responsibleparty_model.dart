import "package:json_annotation/json_annotation.dart";
part "responsibleparty_model.g.dart";
@JsonSerializable(includeIfNull: false)
class ResponsibleParty {
  final String firstName;
  final String lastName;
  final String dni;
  final String address;
  ResponsibleParty({
    this.firstName = "",
    this.lastName = "",
    this.dni = "",
    this.address = "",
  });
  factory ResponsibleParty.fromJson(Map<String, dynamic> json) => _$ResponsiblePartyFromJson(json);
  Map<String, dynamic> toJson() => _$ResponsiblePartyToJson(this);
}
