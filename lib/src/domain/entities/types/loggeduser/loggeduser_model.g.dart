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
  labRole: const LabMemberRoleConverter().fromJson(json['labRole'] as String?),
  userIsLabOwner: json['userIsLabOwner'] as bool? ?? false,
);

Map<String, dynamic> _$LoggedUserToJson(
  LoggedUser instance,
) => <String, dynamic>{
  if (instance.user case final value?) 'user': value,
  if (instance.currentLaboratory case final value?) 'currentLaboratory': value,
  if (const LabMemberRoleConverter().toJson(instance.labRole) case final value?)
    'labRole': value,
  'userIsLabOwner': instance.userIsLabOwner,
};
