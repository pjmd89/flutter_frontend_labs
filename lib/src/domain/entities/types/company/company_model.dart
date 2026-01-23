import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "company_model.g.dart";
@JsonSerializable(includeIfNull: false)
class Company {
  @JsonKey(name: "_id")
  final String id;
  final String name;
  final String logo;
  final String taxID;
  final User? owner;
  final String created;
  final String updated;
  Company({
    this.id = "",
    this.name = "",
    this.logo = "",
    this.taxID = "",
    this.owner,
    this.created = "",
    this.updated = "",
  });
  factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);
  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}
