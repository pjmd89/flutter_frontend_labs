import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "loggeduser_model.g.dart";
@JsonSerializable(includeIfNull: false)
class LoggedUser {
  final User? user;
  final Laboratory? currentLaboratory;
  @JsonKey(unknownEnumValue: JsonKey.nullForUndefinedEnumValue)
  final LabMemberRole? labRole;
  final bool userIsLabOwner;
  LoggedUser({
    this.user,
    this.currentLaboratory,
    this.labRole,
    this.userIsLabOwner = false,
  });
  factory LoggedUser.fromJson(Map<String, dynamic> json) => _$LoggedUserFromJson(json);
  Map<String, dynamic> toJson() => _$LoggedUserToJson(this);
}
