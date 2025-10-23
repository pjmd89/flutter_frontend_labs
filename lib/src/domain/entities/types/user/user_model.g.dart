// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  id: json['_id'] as String? ?? "",
  firstName: json['firstName'] as String? ?? "",
  lastName: json['lastName'] as String? ?? "",
  role: $enumDecodeNullable(_$RoleEnumMap, json['role']),
  email: json['email'] as String? ?? "",
  cutOffDate: json['cutOffDate'] as num? ?? 0,
  fee: json['fee'] as num? ?? 0,
  created: json['created'] as String? ?? "",
  updated: json['updated'] as String? ?? "",
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  if (_$RoleEnumMap[instance.role] case final value?) 'role': value,
  'email': instance.email,
  'cutOffDate': instance.cutOffDate,
  'fee': instance.fee,
  'created': instance.created,
  'updated': instance.updated,
};

const _$RoleEnumMap = {
  Role.root: 'root',
  Role.admin: 'admin',
  Role.owner: 'owner',
  Role.technician: 'technician',
  Role.billing: 'billing',
};
