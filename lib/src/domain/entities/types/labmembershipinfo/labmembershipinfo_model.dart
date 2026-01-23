import "/src/domain/entities/main.dart";
import "package:json_annotation/json_annotation.dart";
part "labmembershipinfo_model.g.dart";
@JsonSerializable(includeIfNull: false)
class LabMembershipInfo {
  @JsonKey(name: "_id")
  final String id;
  final LabMemberRole? role;
  final User? member;
  final Laboratory? laboratory;
  final List<MemberAccess> access;
  final int created;
  final int updated;
  LabMembershipInfo({
    this.id = "",
    this.role,
    this.member,
    this.laboratory,
    this.access = const [],
    this.created = 0,
    this.updated = 0,
  });
  factory LabMembershipInfo.fromJson(Map<String, dynamic> json) => _$LabMembershipInfoFromJson(json);
  Map<String, dynamic> toJson() => _$LabMembershipInfoToJson(this);
}
