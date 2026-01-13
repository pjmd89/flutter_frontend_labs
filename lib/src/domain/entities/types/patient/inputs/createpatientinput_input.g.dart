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
      patientType: $enumDecodeNullable(
        _$PatientTypeEnumMap,
        json['patientType'],
      ),
      birthDate: json['birthDate'] as String?,
      species: json['species'] as String?,
      dni: json['dni'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] as String?,
      laboratory: json['laboratory'] as String?,
    );

Map<String, dynamic> _$CreatePatientInputToJson(CreatePatientInput instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'sex': _$SexEnumMap[instance.sex]!,
      'patientType': _$PatientTypeEnumMap[instance.patientType]!,
      'birthDate': instance.birthDate,
      'species': instance.species,
      'dni': instance.dni,
      'phone': instance.phone,
      'email': instance.email,
      'address': instance.address,
      'laboratory': instance.laboratory,
    };

const _$SexEnumMap = {
  Sex.female: 'FEMALE',
  Sex.male: 'MALE',
  Sex.intersex: 'INTERSEX',
};

const _$PatientTypeEnumMap = {
  PatientType.human: 'HUMAN',
  PatientType.animal: 'ANIMAL',
};
