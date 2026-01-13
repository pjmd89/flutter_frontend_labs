// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
  id: json['_id'] as String? ?? "",
  firstName: json['firstName'] as String? ?? "",
  lastName: json['lastName'] as String? ?? "",
  sex: sexFromJson(json['sex']),
  birthDate: json['birthDate'] as num? ?? 0,
  species: json['species'] as String? ?? "",
  patientType: $enumDecodeNullable(_$PatientTypeEnumMap, json['patientType']),
  dni: json['dni'] as String? ?? "",
  phone: json['phone'] as String? ?? "",
  email: json['email'] as String? ?? "",
  address: json['address'] as String? ?? "",
  laboratory:
      json['laboratory'] == null
          ? null
          : Laboratory.fromJson(json['laboratory'] as Map<String, dynamic>),
  created: json['created'] as num? ?? 0,
  updated: json['updated'] as num? ?? 0,
);

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
  '_id': instance.id,
  'firstName': instance.firstName,
  'lastName': instance.lastName,
  if (_$SexEnumMap[instance.sex] case final value?) 'sex': value,
  'birthDate': instance.birthDate,
  'species': instance.species,
  if (_$PatientTypeEnumMap[instance.patientType] case final value?)
    'patientType': value,
  'dni': instance.dni,
  'phone': instance.phone,
  'email': instance.email,
  'address': instance.address,
  if (instance.laboratory case final value?) 'laboratory': value,
  'created': instance.created,
  'updated': instance.updated,
};

const _$PatientTypeEnumMap = {
  PatientType.human: 'HUMAN',
  PatientType.animal: 'ANIMAL',
};

const _$SexEnumMap = {
  Sex.female: 'FEMALE',
  Sex.male: 'MALE',
  Sex.intersex: 'INTERSEX',
};
