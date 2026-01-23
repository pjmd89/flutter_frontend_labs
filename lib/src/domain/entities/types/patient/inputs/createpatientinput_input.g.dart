// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'createpatientinput_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePatientInput _$CreatePatientInputFromJson(Map<String, dynamic> json) =>
    CreatePatientInput(
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      sex: $enumDecodeNullable(_$SexEnumMap, json['sex']),
      birthDate: json['birthDate'] as String?,
      species: json['species'] as String?,
      patientType: $enumDecodeNullable(
        _$PatientTypeEnumMap,
        json['patientType'],
      ),
      dni: json['dni'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      laboratory: json['laboratory'] as String?,
    );

Map<String, dynamic> _$CreatePatientInputToJson(CreatePatientInput instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      if (instance.lastName case final value?) 'lastName': value,
      'sex': _$SexEnumMap[instance.sex]!,
      if (instance.birthDate case final value?) 'birthDate': value,
      if (instance.species case final value?) 'species': value,
      'patientType': _$PatientTypeEnumMap[instance.patientType]!,
      if (instance.dni case final value?) 'dni': value,
      if (instance.phone case final value?) 'phone': value,
      if (instance.email case final value?) 'email': value,
      if (instance.address case final value?) 'address': value,
      if (instance.laboratory case final value?) 'laboratory': value,
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
