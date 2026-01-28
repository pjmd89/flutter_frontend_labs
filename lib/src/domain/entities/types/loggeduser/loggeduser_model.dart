import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "loggeduser_model.g.dart";

// Converter para manejar strings vacíos en el enum LabMemberRole
class LabMemberRoleConverter implements JsonConverter<LabMemberRole?, String?> {
  const LabMemberRoleConverter();

  @override
  LabMemberRole? fromJson(String? json) {
    if (json == null || json.isEmpty) return null;
    
    // Conversión manual del string al enum
    switch (json) {
      case 'OWNER':
        return LabMemberRole.oWNER;
      case 'TECHNICIAN':
        return LabMemberRole.tECHNICIAN;
      case 'BILLING':
        return LabMemberRole.bILLING;
      case 'BIOANALYST':
        return LabMemberRole.bIOANALYST;
      default:
        return null;
    }
  }

  @override
  String? toJson(LabMemberRole? object) {
    if (object == null) return null;
    
    switch (object) {
      case LabMemberRole.oWNER:
        return 'OWNER';
      case LabMemberRole.tECHNICIAN:
        return 'TECHNICIAN';
      case LabMemberRole.bILLING:
        return 'BILLING';
      case LabMemberRole.bIOANALYST:
        return 'BIOANALYST';
    }
  }
}

@JsonSerializable(includeIfNull: false)
class LoggedUser {
  final User? user;
  final Laboratory? currentLaboratory;
  
  @LabMemberRoleConverter()
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
