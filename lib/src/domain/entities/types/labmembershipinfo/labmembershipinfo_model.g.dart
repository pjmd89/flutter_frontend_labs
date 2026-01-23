// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'labmembershipinfo_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LabMembershipInfo _$LabMembershipInfoFromJson(Map<String, dynamic> json) =>
    LabMembershipInfo(
      id: json['_id'] as String? ?? "",
      role: $enumDecodeNullable(_$LabMemberRoleEnumMap, json['role']),
      member:
          json['member'] == null
              ? null
              : User.fromJson(json['member'] as Map<String, dynamic>),
      laboratory:
          json['laboratory'] == null
              ? null
              : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
      access:
          (json['access'] as List<dynamic>?)
              ?.map((e) => MemberAccess.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      created: (json['created'] as num?)?.toInt() ?? 0,
      updated: (json['updated'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$LabMembershipInfoToJson(
  LabMembershipInfo instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (_$LabMemberRoleEnumMap[instance.role] case final value?) 'role': value,
  if (instance.member case final value?) 'member': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  'access': instance.access,
  'created': instance.created,
  'updated': instance.updated,
};

const _$LabMemberRoleEnumMap = {
  LabMemberRole.oWNER: 'OWNER',
  LabMemberRole.tECHNICIAN: 'TECHNICIAN',
  LabMemberRole.bILLING: 'BILLING',
  LabMemberRole.bIOANALYST: 'BIOANALYST',
};
