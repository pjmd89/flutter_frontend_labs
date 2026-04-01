// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeeinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeInput _$EmployeeInputFromJson(Map<String, dynamic> json) =>
    EmployeeInput(
      id: json['_id'] as String?,
      role: $enumDecodeNullable(_$LabMemberRoleEnumMap, json['role']),
    );

Map<String, dynamic> _$EmployeeInputToJson(
  EmployeeInput instance,
) => <String, dynamic>{
  '_id': instance.id,
  if (_$LabMemberRoleEnumMap[instance.role] case final value?) 'role': value,
};

const _$LabMemberRoleEnumMap = {
  LabMemberRole.oWNER: 'OWNER',
  LabMemberRole.tECHNICIAN: 'TECHNICIAN',
  LabMemberRole.bILLING: 'BILLING',
  LabMemberRole.bIOANALYST: 'BIOANALYST',
};
