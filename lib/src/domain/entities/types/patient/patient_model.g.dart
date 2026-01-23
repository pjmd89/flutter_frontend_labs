// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['_id'] as String? ?? "",
  firstName: json['firstName'] as String? ?? "",
  lastName: json['lastName'] as String? ?? "",
  sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
  patientType: $enumDecodeNullable(_$PatientTypeEnumMap, json['patientType']),
  birthDate: (json['birthDate'] as num?)?.toInt() ?? 0,
  species: json['species'] as String? ?? "",
  dni: json['dni'] as String?,
  phone: json['phone'] as String?,
  email: json['email'] as String?,
  address: json['address'] as String?,
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  created: (json['created'] as num?)?.toInt() ?? 0,
  updated: (json['updated'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
  if (_$PatientTypeEnumMap[instance.patientType] case final value?)
    'patientType': value,
  if (instance.birthDate case final value?) 'birthDate': value,
  'species': instance.species,
  if (instance.dni case final value?) 'dni': value,
  if (instance.phone case final value?) 'phone': value,
  if (instance.email case final value?) 'email': value,
  if (instance.address case final value?) 'address': value,
  if (instance.laboratory case final value?) 'laboratory': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$SexEnumMap = {
  Sex.fEMALE: 'FEMALE',
  Sex.mALE: 'MALE',
  Sex.iNTERSEX: 'INTERSEX',
};

const _$PatientTypeEnumMap = {
  PatientType.hUMAN: 'HUMAN',
  PatientType.aNIMAL: 'ANIMAL',
};
