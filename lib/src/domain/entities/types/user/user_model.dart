import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "user_model.g.dart";
@JsonSerializable(includeIfNull: false)
class User {
  @JsonKey(name: "_id")
  final String id;
  final String firstName;
  final String lastName;
  final Role? role;
  final String email;
  final int cutOffDate;
  final num fee;
  final int created;
  final int updated;
  User({
    this.id = "",
    this.firstName = "",
    this.lastName = "",
    this.role,
    this.email = "",
    this.cutOffDate = 0,
    this.fee = 0,
    this.created = 0,
    this.updated = 0,
  });
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
