// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loggeduser_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoggedUser _$LoggedUserFromJson(Map<String, dynamic> json) => LoggedUser(
  user:
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
  currentLaboratory:
      json['currentLaboratory'] == null
          ? null
          : Laboratory.fromJson(
            json['currentLaboratory'] as Map<String, dynamic>,
          ),
  labRole: _labRoleFromJson(json['labRole']),
  userIsLabOwner: json['userIsLabOwner'] as bool? ?? false,
);

Map<String, dynamic> _$LoggedUserToJson(
  LoggedUser instance,
) => <String, dynamic>{
  if (instance.user case final value?) 'user': value,
  if (instance.currentLaboratory case final value?) 'currentLaboratory': value,
  if (_$LabMemberRoleEnumMap[instance.labRole] case final value?)
    'labRole': value,
  'userIsLabOwner': instance.userIsLabOwner,
};

const _$LabMemberRoleEnumMap = {
  LabMemberRole.oWNER: 'OWNER',
  LabMemberRole.tECHNICIAN: 'TECHNICIAN',
  LabMemberRole.bILLING: 'BILLING',
  LabMemberRole.bIOANALYST: 'BIOANALYST',
};
