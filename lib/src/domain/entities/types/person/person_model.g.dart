// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  id: json['_id'] as String? ?? "",
  firstName: json['firstName'] as String? ?? "",
  lastName: json['lastName'] as String? ?? "",
  dni: json['dni'] as String? ?? "",
  phone: json['phone'] as String? ?? "",
  email: json['email'] as String? ?? "",
  address: json['address'] as String? ?? "",
  birthDate: (json['birthDate'] as num?)?.toInt() ?? 0,
  sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  created: (json['created'] as num?)?.toInt() ?? 0,
  updated: (json['updated'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  'dni': instance.dni,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  'birthDate': instance.birthDate,
  if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$SexEnumMap = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};
