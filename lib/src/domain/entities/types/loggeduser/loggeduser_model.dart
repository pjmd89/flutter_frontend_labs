import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "loggeduser_model.g.dart";

/// Helper function para parsear labRole manejando strings vacíos
LabMemberRole? _labRoleFromJson(dynamic value) {
  if (value == null || value == '') {
    return null;
  }
  return $enumDecodeNullable(_$LabMemberRoleEnumMap, value);
}

@JsonSerializable(includeIfNull: false)
class LoggedUser {
  final User? user;
  final Laboratory? currentLaboratory;
  
  @JsonKey(fromJson: _labRoleFromJson)
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
